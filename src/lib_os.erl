%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lib_os).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
-compile(export_all).


%% ====================================================================
%% External functions
%% ====================================================================
restart(HostName)->
    Ip=host_config:ip(HostName),
    Port=host_config:ssh_port(HostName),
    Uid=host_config:uid(HostName),
    Pwd=host_config:passwd(HostName),
    HostNode=host_config:node(HostName),
    rpc:cast(HostNode,init,stop,[]),
    ssh:start(), 
    Cmd="shutdown -r",
    _Result=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,Cmd, 5*1000],4*1000), 
   
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
-define(ApplicationDir,"applications").
start(HostName)->
    Ip=host_config:ip(HostName),
    Port=host_config:ssh_port(HostName),
    Uid=host_config:uid(HostName),
    Pwd=host_config:passwd(HostName),
    HostNode=host_config:node(HostName),
    
    Erl=host_config:erl_cmd(HostName),
    EnvVars=host_config:env_vars(HostName),
    NodeName=host_config:nodename(HostName),
    Cookie=host_config:cookie(HostName),
    
   % ErlCmd=Erl++" "++"-sname "++NodeName++" "++EnvVars++" "++"-setcookie "++Cookie,
    ssh:start(), 
    ErlCmd=Erl++" "++"-sname "++NodeName++" "++"-setcookie "++Cookie,
    _Result=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,ErlCmd, 5*1000],4*1000), 
   % io:format("Result = ~p~n",[Result]),
    Result=case node_started(HostNode) of
	       false->
		   {error,[false,HostName,HostNode]};
	       true->
		   R=rpc:call(HostNode,application,set_env,[EnvVars],5*1000),
		   rpc:call(HostNode,os,cmd,["rm -rf "++?ApplicationDir],2000),
		   timer:sleep(1000),
		   ok=rpc:call(HostNode,file,make_dir,[?ApplicationDir],2000),
		   timer:sleep(1000),
		   {R,[HostName,HostNode]}
	   end,
    Result.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------



%% --------------------------------------------------------------------
%% Function:start
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
	      
node_started(Node)->
    check_started(5,Node,20,false).
    
check_started(_N,_Vm,_SleepTime,true)->
   true;
check_started(0,_Vm,_SleepTime,Result)->
    Result;
check_started(N,Vm,SleepTime,_Result)->
 %   io:format("net_adm ~p~n",[{Vm,net_adm:ping(Vm)}]),
    NewResult= case net_adm:ping(Vm) of
		   pong->
		      true;
		  pang->
		      timer:sleep(SleepTime),
		      false;
		   {badrpc,_}->
		      timer:sleep(SleepTime),
		      false
	      end,
    check_started(N-1,Vm,SleepTime,NewResult).


%% --------------------------------------------------------------------
%% Function:start
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------

node_stopped(Node)->
    check_stopped(100,Node,50,false).
    
check_stopped(_N,_Vm,_SleepTime,true)->
   true;
check_stopped(0,_Vm,_SleepTime,Result)->
    Result;
check_stopped(N,Vm,SleepTime,_Result)->
 %   io:format("net_Adm ~p~n",[net_adm:ping(Vm)]),
    NewResult= case net_adm:ping(Vm) of
	%case rpc:call(node(),net_adm,ping,[Vm],1000) of
		  pang->
		     true;
		  pong->
		       timer:sleep(SleepTime),
		       false;
		   {badrpc,_}->
		       true
	       end,
    check_stopped(N-1,Vm,SleepTime,NewResult).

