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
restart(Id)->
    Ip=db_host:ip(Id),
    Port=db_host:ssh_port(Id),
    Uid=db_host:uid(Id),
    Pwd=db_host:passwd(Id),
    HostNode=db_host:node(Id),
    rpc:cast(HostNode,init,stop,[]),
    ssh:start(), 
    Cmd="shutdown -r",
    _Result=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,Cmd, 5*1000],4*1000), 
    db_host:update_status(Id,stopped), 
   
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start(Id)->
    io:format("node = ~p~n",[{node(),?MODULE,?FUNCTION_NAME,?LINE}]),
    
    Ip=db_host:ip(Id),
    Port=db_host:port(Id),
    Uid=db_host:uid(Id),
    Pwd=db_host:passwd(Id),
    HostNode=db_host:node(Id),
    
    Erl=db_host:erl_cmd(Id),
    EnvVars=db_host:env_vars(Id),
    NodeName=db_host:nodename(Id),
    Cookie=db_host:cookie(Id),
    ApplicationDir=db_host:application_dir(Id),
   % ErlCmd=Erl++" "++"-sname "++NodeName++" "++EnvVars++" "++"-setcookie "++Cookie,
    ssh:start(), 
    ErlCmd=Erl++" "++"-sname "++NodeName++" "++"-setcookie "++Cookie,
    SshResult=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,ErlCmd, 5*1000],4*1000), 
    io:format("SshResult = ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,SshResult}]),
    Result=case node_started(HostNode) of
	       false->
		   db_host:update_status(Id,host_started),
		   {error,[false,Id,HostNode]};
	       true->
		   R=rpc:call(HostNode,application,set_env,[EnvVars],5*1000),
		   rpc:call(HostNode,os,cmd,["rm -rf "++ApplicationDir],2000),
		   timer:sleep(1000),
		   io:format("ApplicationDir = ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,ApplicationDir}]),
		   X=rpc:call(HostNode,file,make_dir,[ApplicationDir],2000),
		   io:format("make dir result = ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,X}]),
		   timer:sleep(1000),
		   db_host:update_status(Id,node_started),
		   {R,[Id,HostNode]}
	   end,
 %    io:format("Result = ~p~n",[[{Result,?MODULE,?FUNCTION_NAME,?LINE}]]),
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

