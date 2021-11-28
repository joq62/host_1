%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lib_status).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
%-compile(export_all).
-export([
	 os_started/0,
	 os_started/1,
	 os_stopped/0,
	 os_stopped/1,
	 start/0
	]).

%% ====================================================================
%% External functions
%% ====================================================================

%% -------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
os_started(HostName)->
   lists:member(HostName,os_started()).

os_stopped(HostName)->
   lists:member(HostName,os_stopped()).
    

os_started()->
    {ok,Started,_Stopped}=start(),
    [Host||{started,Host,_Ip,_Port}<-Started].
os_stopped()->
    {ok,_Started,Stopped}=start(),
    [Host||{stopped,Host,_Ip,_Port}<-Stopped].

start()->
    F1=fun get_hostname/2,
    F2=fun check_host_status/3,
    ssh:start(),
    AllHosts=lists:sort(host_config:host()),
%    io:format("AllHosts = ~p~n",[{?MODULE,?LINE,AllHosts}]),
    Status=mapreduce:start(F1,F2,[],AllHosts),
%    io:format("Status = ~p~n",[{?MODULE,?LINE,Status}]),
    Started=[{started,HostId,Ip,Port}||{running,HostId,Ip,Port}<-Status],
    Stopped=[{stopped,HostId,Ip,Port}||{missing,HostId,Ip,Port}<-Status],
    {ok,Started,Stopped}.

get_hostname(Parent,HostName)->   
    Info=host_config:access_info(HostName), 
    Ip=proplists:get_value(ip,Info),
    SshPort=proplists:get_value(ssh_port,Info),
    Uid=proplists:get_value(uid,Info),
    Pwd=proplists:get_value(pwd,Info),
    
   % io:format("get_hostname= ~p~n",[{?MODULE,?LINE,HostId,User,PassWd,IpAddr,Port}]),
    Msg="hostname",
    Result=rpc:call(node(),my_ssh,ssh_send,[Ip,SshPort,Uid,Pwd,Msg, 5*1000],4*1000),
  %  io:format("Result, HostId= ~p~n",[{?MODULE,?LINE,Result,HostId}]),
    Parent!{machine_status,{HostName,Ip,SshPort,Result}}.

check_host_status(machine_status,Vals,_)->
    check_host_status(Vals,[]).

check_host_status([],Status)->
    Status;
check_host_status([{HostId,IpAddr,Port,[HostId]}|T],Acc)->
    NewAcc=[{running,HostId,IpAddr,Port}|Acc],
    check_host_status(T,NewAcc);
check_host_status([{HostId,IpAddr,Port,{error,_Err}}|T],Acc) ->
    check_host_status(T,[{missing,HostId,IpAddr,Port}|Acc]);
check_host_status([{HostId,IpAddr,Port,{badrpc,timeout}}|T],Acc) ->
    check_host_status(T,[{missing,HostId,IpAddr,Port}|Acc]);
check_host_status([X|T],Acc) ->
    io:format("Error = ~p~n",[{X,?MODULE,?FUNCTION_NAME,?LINE}]),
    check_host_status(T,[{x,X}|Acc]).

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
