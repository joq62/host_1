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
%-compile(export_all).
-export([
	 load_start_apps/4,
	 start_pod/4,
	 scoring_hosts/1,
	 filter_hosts/2,
	 ssh_start/1,
	 ssh_restart/1,
	 load_app/3,
	 start_app/3,
	 stop_app/2,
	 unload_app/3,
	 start_slave/3,
	 start_slave/5,
	 stop_slave/3
	]).
	 

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
ssh_start(HostId)->
    HostNode=db_host:node(HostId),
    Erl=db_host:erl_cmd(HostId),
    % EnvVars=db_host:env_vars(HostId),
    NodeName=db_host:nodename(HostId),
    Cookie=db_host:cookie(HostId), 
    ssh_start(HostId,HostNode,NodeName,Cookie,Erl).

ssh_start(HostId,HostNode,NodeName,Cookie,Erl)->
    ssh:start(),
    Ip=db_host:ip(HostId),
    Port=db_host:port(HostId),
    Uid=db_host:uid(HostId),
    Pwd=db_host:passwd(HostId),
    AppDir=db_host:application_dir(HostId),
   
    %% Added Host dir where all deployments are stored
    Rm="rm -rf "++AppDir,
    SshRmCmd="nohup "++Rm++" &",
    SshRmCmdRes=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,SshRmCmd, 5*1000],4*1000), 
   
    MkDir="mkdir "++AppDir,
    SshMkDirCmd="nohup "++MkDir++" &",
    SshMkDirCmdRes=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,SshMkDirCmd, 5*1000],4*1000), 

    ErlCmd=Erl++" "++"-sname "++NodeName++" "++"-setcookie "++Cookie,
    SshErlCmd="nohup "++ErlCmd++" &",
    SshErlCmdRes=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,SshErlCmd, 5*1000],4*1000), 
 %  io:format("SshResult = ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,SshResult}]),
    Result=case node_started(HostNode) of
	       false->
		   db_host:update_status(HostId,host_started),
		   {error,[false,HostId,HostNode]};
	       true->
		   db_host:update_status(HostId,node_started),
		   {ok,[HostId,HostNode]}
	   end,
     io:format("Result = ~p~n",[[{Result,?MODULE,?FUNCTION_NAME,?LINE}]]),
    Result.

ssh_restart(HostId)->
    ssh:start(), 
    Ip=db_host:ip(HostId),
    Port=db_host:port(HostId),
    Uid=db_host:uid(HostId),
    Pwd=db_host:passwd(HostId),
    HostNode=db_host:node(HostId),
    rpc:cast(HostNode,init,stop,[]),
    Cmd="shutdown -r",
    _Result=rpc:call(node(),my_ssh,ssh_send,[Ip,Port,Uid,Pwd,Cmd, 5*1000],4*1000), 
    db_host:update_status(HostId,stopped), 
   
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% ------------------------------------------------------------------- 
load_start_apps(AppIds,PodId,PodNode,PodDir)->
    io:format("AppIds,PodId,PodNode,PodDir ~p~n",[{AppIds,PodId,PodNode,PodDir,?MODULE,?FUNCTION_NAME,?LINE}]),
    load_start_app(AppIds,PodId,PodNode,PodDir,[]).
    
load_start_app([],_PodId,_PodNode,_PodDir,StartRes)->
    Res=[{error,Reason}||{error,Reason}<-StartRes],
    case Res of
	[]->
	    {ok,[PodAppInfo||{ok,PodAppInfo}<-StartRes]};
	ErrorList->
	    {error,ErrorList}
    end;
load_start_app([AppId|T],PodId,PodNode,PodDir,Acc)->
    App=db_service_catalog:app(AppId),
    Vsn=db_service_catalog:vsn(AppId),
    GitPath=db_service_catalog:git_path(AppId),
    NewAcc=case pod:load_app(PodNode,PodDir,{App,Vsn,GitPath}) of
	       {error,Reason}->
		   [{error,Reason}|Acc];
	       ok->
		   Env=[],
		   case pod:start_app(PodNode,App,Env) of
		       {error,Reason}->
			   [{error,Reason}|Acc];
		       ok->
			   [{ok,{PodId,PodNode,PodDir,App,Vsn}}|Acc]
		   end
	   end,
    load_start_app(T,PodId,PodNode,PodDir,NewAcc).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
    

load_app(Pod,PodDir,{Application,_Vsn,GitPath})->
    AppDirSource=atom_to_list(Application),
    AppDirDest=filename:join(PodDir,AppDirSource),
    rpc:call(Pod,os,cmd,["rm -rf "++AppDirDest],2*1000),
    rpc:call(Pod,os,cmd,["git clone "++GitPath],3*1000),
    rpc:call(Pod,os,cmd,["mv "++AppDirSource++" "++AppDirDest],10*1000),
    Ebin=filename:join(AppDirDest,"ebin"),
    true=rpc:call(Pod,filelib,is_dir,[Ebin],3*1000),
    true=rpc:call(Pod,code,add_patha,[Ebin],3*1000),
    ok.

start_app(Pod,App,Env)->
    AppFile=atom_to_list(App)++".app",
    Result=case rpc:call(Pod,code,where_is_file,[AppFile],5*1000) of
	       {badrpc,Reason}->
		   {badrpc,Reason};
	       non_existing ->
		   {error,[non_existing,Pod,App]};
	       _ ->
		   case Env of 
		       []->
			   rpc:call(Pod,application,start,[App],10*1000);
		       Env->
			   rpc:call(Pod,application,set_env,[Env],5*1000),
			   rpc:call(Pod,application,start,[App],10*1000)
		   end
	   end,	   
    Result.
	
stop_app(Pod,App)->	   
    rpc:call(Pod,application,stop,[App],5*1000).

unload_app(Pod,App,AppDir)->
    rpc:call(Pod,os,cmd,["rm -rf "++AppDir],5*1000),
    rpc:call(Pod,application,unload,[App],5*1000).

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------	       
start_pod(PodId,HostId,DepId,DeployInstanceId)->
    UniquePod=integer_to_list(erlang:system_time(millisecond)),
    {PodName,_Vsn}=PodId,
    HostNode=db_host:node(HostId),
    HostName=db_host:hostname(HostId), 
    NodeName=HostName++"_"++PodName++"_"++UniquePod,
    AppDir=db_host:application_dir(HostId),
    PodDir=filename:join(AppDir,NodeName++".pod"),
 
    rpc:call(HostNode,os,cmd,["rm -rf "++PodDir],5*1000),
    timer:sleep(1000),
    ok=rpc:call(HostNode,file,make_dir,[PodDir],5*1000),
    Cookie=atom_to_list(erlang:get_cookie()),
    Args="-setcookie "++Cookie,
    Result=case pod:start_slave(HostNode,HostName,NodeName,Args,PodDir) of
	       {error,Reason}->
		   rpc:call(HostNode,os,cmd,["rm -rf "++PodDir],5*1000),
		   {error,Reason};
	       {ok,PodNode,PodDir} ->
		   {atomic,ok}=db_deploy_state:add_pod_status(DeployInstanceId,{PodNode,PodDir,PodId}),
		   {ok,PodNode,PodDir} 
	   end,
    Result.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start_slave(HostId,NodeName,PodDir)->
    {Host,_}=HostId,
    HostNode=db_host:node(HostId),
    Cookie=db_host:cookie(HostId),
    Args="-setcookie "++Cookie,
    start_slave(HostNode,Host,NodeName,Args,PodDir).

start_slave(Node,Host,NodeName,Args,PodDir)->
    rpc:call(Node,os,cmd,["rm -rf "++PodDir],5*1000),
    timer:sleep(1000),
    ok=rpc:call(Node,file,make_dir,[PodDir],5*1000),
    {ok,Pod}=rpc:call(Node,slave,start,[Host,NodeName,Args],5*1000),
    true=net_kernel:connect_node(Pod),
    {ok,Pod,PodDir}.
    
    
stop_slave(HostNode,Pod,PodDir)->
    ok=rpc:call(HostNode,slave,stop,[Pod],5*1000),
    rpc:call(HostNode,os,cmd,["rm -rf "++PodDir],5*1000),
    ok.


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

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% ------------------------------------------------------------------- 

filter_hosts([],AffinityList)->
    AffinityList;
filter_hosts({hosts,HostList},AffinityList)->
    Candidates=[Id||Id<-AffinityList,
		    lists:member(Id,HostList),
	            pong=:=net_adm:ping(list_to_atom(db_host:node(Id)))],
    Candidates.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
scoring_hosts([])->
    {error,[no_nodes_available]};
scoring_hosts(Candidates)->
    NodeAdded=[{Id,db_host:node(Id)}||Id<-Candidates],
    Nodes=[Node||{_,Node}<-NodeAdded],
    Apps=[{Node,rpc:call(Node,application,loaded_applications,[],5*1000)}||Node<-[node()|Nodes]],
    AvailableNodes=[{Node,AppList}||{Node,AppList}<-Apps,
				    AppList/={badrpc,nodedown}],
     Z=[{lists:flatlength(L),Node}||{Node,L}<-AvailableNodes],
  %  io:format("Z ~p~n",[Z]),
    S1=lists:keysort(1,Z),
  %  io:format("S1 ~p~n",[S1]),
    SortedList=lists:reverse([Id||{Id,Node}<-NodeAdded,
		 lists:keymember(Node,2,S1)]),
    SortedList.
    
