%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(pod).  
   
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
restart_host_node(HostId)->
    Ip=db_host:ip(HostId),
    Port=db_host:port(HostId),
    Uid=db_host:uid(HostId),
    Pwd=db_host:passwd(HostId),
    HostNode=db_host:node(HostId),
    rpc:cast(HostNode,init,stop,[]),
    ssh:start(), 
    Cmd="shutdown -r",
    _Result=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,Cmd, 5*1000],4*1000), 
    db_host:update_status(HostId,stopped), 
   
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start(HostId)->
    io:format("node = ~p~n",[{node(),?MODULE,?FUNCTION_NAME,?LINE}]),
    Ip=db_host:ip(HostId),
    Port=db_host:port(HostId),
    Uid=db_host:uid(HostId),
    Pwd=db_host:passwd(HostId),
    HostNode=db_host:node(HostId),
    
    Erl=db_host:erl_cmd(HostId),
    EnvVars=db_host:env_vars(HostId),
    NodeName=db_host:nodename(HostId),
    Cookie=db_host:cookie(HostId),
    io:format("Cookie = ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,Cookie}]),
    ApplicationDir=db_host:application_dir(HostId),

   % ErlCmd=Erl++" "++"-sname "++NodeName++" "++EnvVars++" "++"-setcookie "++Cookie,
    ssh:start(), 
    ErlCmd=Erl++" "++"-sname "++NodeName++" "++"-setcookie "++Cookie,
    
   % ErlCmd="erl_call -s "++"-sname "++NodeName++" "++"-c "++Cookie,
    SshCmd="nohup "++ErlCmd++" &",
    SshResult=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,SshCmd, 5*1000],4*1000), 
   io:format("SshResult = ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,SshResult}]),
    Result=case node_started(HostNode) of
	       false->
		   db_host:update_status(HostId,host_started),
		   {error,[false,HostId,HostNode]};
	       true->
		   R=rpc:call(HostNode,application,set_env,[EnvVars],5*1000),
		   rpc:call(HostNode,os,cmd,["rm -rf "++ApplicationDir],2000),
		   timer:sleep(1000),
%		   io:format("ApplicationDir = ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,ApplicationDir}]),
		   X=rpc:call(HostNode,file,make_dir,[ApplicationDir],2000),
%		   io:format("make dir result = ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,X}]),
		   timer:sleep(1000),
		   db_host:update_status(HostId,node_started),
		   {R,[HostId,HostNode]}
	   end,
 %    io:format("Result = ~p~n",[[{Result,?MODULE,?FUNCTION_NAME,?LINE}]]),
    Result.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start_slave(HostId,NodeName)->
    {Host,_}=HostId,
    HostNode=db_host:node(HostId),
    Cookie=db_host:cookie(HostId),
    ApplicationDir=db_host:application_dir(HostId),
    PodDir=filename:join(ApplicationDir,NodeName),
    Args="-setcookie "++Cookie,
    start_slave(HostNode,Host,NodeName,Args,PodDir).

start_slave(Node,Host,NodeName,Args,PodDir)->
    rpc:call(Node,os,cmd,["rm -rf "++PodDir],5*1000),
    timer:sleep(1000),
    ok=rpc:call(Node,file,make_dir,[PodDir],5*1000),
    {ok,Slave}=rpc:call(Node,slave,start,[Host,NodeName,Args],5*1000),
    {ok,Slave,PodDir}.
    
    
    


    


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

