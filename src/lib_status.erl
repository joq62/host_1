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
	 node_started/0,
	 node_started/1,
	 node_stopped/0,
	 node_stopped/1,
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

node_started(Id)->
    lists:member(Id,node_started()).
node_stopped(Id)->
    lists:member(Id,node_stopped()).

node_started()->
    {ok,Started,_Stopped}=node_check(),
    Started.
node_stopped()->
    {ok,_Started,Stopped}=node_check(),
    Stopped.

node_check()->
    AllIds=lists:sort(db_host:ids()),
  %  io:format("AllIds = ~p~n",[[{node(),?MODULE,?FUNCTION_NAME,?LINE,AllIds}]]),
    CheckResult=[{Id,net_adm:ping(db_host:node(Id))}||Id<-AllIds],
%    io:format("CheckResult = ~p~n",[[{node(),?MODULE,?FUNCTION_NAME,?LINE,CheckResult}]]),
    Started=[Id||{Id,pong}<-CheckResult],
    Stopped=[Id||{Id,pang}<-CheckResult],
  %  io:format("Stopped = ~p~n",[[{node(),?MODULE,?FUNCTION_NAME,?LINE,Stopped}]]),
    {ok,Started,Stopped}.

%% -------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
os_started(Id)->
   lists:member(Id,os_started()).

os_stopped(Id)->
   lists:member(Id,os_stopped()).
    

os_started()->
    {ok,Started,_Stopped}=start(),
    [Id||{host_started,Id,_Ip,_Port}<-Started].
os_stopped()->
    {ok,_Started,Stopped}=start(),
    [Id||{host_stopped,Id,_Ip,_Port}<-Stopped].

start()->
    F1=fun get_hostname/2,
    F2=fun check_host_status/3,
    ssh:start(),
    AllIds=lists:sort(db_host:ids()),
  %  io:format("AllIds = ~p~n",[{?MODULE,?LINE,AllIds}]),
  %  timer:sleep(5000),
    Status=mapreduce:start(F1,F2,[],AllIds),
%    io:format("Status = ~p~n",[{?MODULE,?LINE,Status}]),
    Started=[{host_started,Id,Ip,Port}||{running,Id,Ip,Port}<-Status],
    Stopped=[{host_stopped,Id,Ip,Port}||{missing,Id,Ip,Port}<-Status],
    [db_host:update_status(Id,host_stopped)||{_,Id,_,_}<-Stopped],
    {ok,Started,Stopped}.

get_hostname(Parent,Id)->   
    Ip=db_host:ip(Id),
    SshPort=db_host:port(Id),
    Uid=db_host:uid(Id),
    Pwd=db_host:passwd(Id),
    {Host,_}=Id,
   % io:format("get_hostname= ~p~n",[{?MODULE,?LINE,HostId,User,PassWd,IpAddr,Port}]),
    Msg="hostname",
    R1=rpc:call(node(),my_ssh,ssh_send,[Ip,SshPort,Uid,Pwd,Msg, 5*1000],4*1000),
    Result=case R1=:=[Host] of
	       false->
		   [R1];
	       true->
		   ok
	   end,
	
    Parent!{machine_status,{Id,Ip,SshPort,Result}}.

check_host_status(machine_status,Vals,_)->
    check_host_status(Vals,[]).

check_host_status([],Status)->
    Status;
check_host_status([{Id,IpAddr,Port,ok}|T],Acc)->
    NewAcc=[{running,Id,IpAddr,Port}|Acc],
    case net_adm:ping(db_host:node(Id)) of
	pong->
	    {atomic,ok}=db_host:update_status(Id,node_started);
	pang->
	     {atomic,ok}=db_host:update_status(Id,host_started)
    end,    
    timer:sleep(1000),
    check_host_status(T,NewAcc);
check_host_status([{Id,IpAddr,Port,{error,_Err}}|T],Acc) ->
    check_host_status(T,[{missing,Id,IpAddr,Port}|Acc]);
check_host_status([{Id,IpAddr,Port,{badrpc,timeout}}|T],Acc) ->
    check_host_status(T,[{missing,Id,IpAddr,Port}|Acc]);
check_host_status([X|T],Acc) ->
    io:format("Error = ~p~n",[{X,?MODULE,?FUNCTION_NAME,?LINE}]),
    check_host_status(T,[{x,X}|Acc]).

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
