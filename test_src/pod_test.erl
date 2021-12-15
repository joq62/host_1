%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(pod_test).   
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% External exports
-export([start/0]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
  %  io:format("~p~n",[{"Start setup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=setup(),
  %  io:format("~p~n",[{"Stop setup",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start pass1()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=pass1(),
    io:format("~p~n",[{"Stop pass1()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start desired_state()",?MODULE,?FUNCTION_NAME,?LINE}]),
 %   ok=desired_state(),
 %   io:format("~p~n",[{"Stop desired_state()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start os_stop()",?MODULE,?FUNCTION_NAME,?LINE}]),
 %   ok=os_stop(),
  %  io:format("~p~n",[{"Stop os_stop()",?MODULE,?FUNCTION_NAME,?LINE}]),
   
      %% End application tests
  %  io:format("~p~n",[{"Start cleanup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=cleanup(),
  %  io:format("~p~n",[{"Stop cleaup",?MODULE,?FUNCTION_NAME,?LINE}]),
   
    io:format("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
pass1()->
%    io:format("mnesia:system_info()~p~n",[{mnesia:system_info(),?MODULE,?FUNCTION_NAME,?LINE}]),
    [HostNode1,HostNode2,HostNode3,HostNode4]=nodes(),
    host1@c100=HostNode1,
    Date=date(),
    %% Start HostNode
    %%
    % start a pod 
    PodId1=integer_to_list(erlang:system_time(millisecond)),
    PodDir1=PodId1++".pod",
    NodeName1=PodId1,
    Cookie=atom_to_list(erlang:get_cookie()),
    Args="-setcookie "++Cookie,
    {ok,HostName}=net:gethostname(),
    {ok,Pod1,PodDir1}=pod:start_slave(HostNode1,HostName,NodeName1,Args,PodDir1),   
    D=rpc:call(Pod1,erlang,date,[],2000),
    
   % load app1
    App1=myadd,
    MyaddAppInfo=db_service_catalog:read({App1,"1.0.0"}),
    ok=pod:load_app(Pod1,PodDir1,MyaddAppInfo),
  
    %start_app
    Env=[],
    ok=pod:start_app(Pod1,App1,Env),
    42=rpc:call(Pod1,myadd,add,[20,22],2*1000),

    
    % load sd
    SdInfo=db_service_catalog:read({sd,"1.0.0"}),
    ok=pod:load_app(Pod1,PodDir1,SdInfo),
    %start_app
    Env=[],
    ok=pod:start_app(Pod1,sd,Env),
    io:format("sd:all()~p~n",[{rpc:call(Pod1,sd,all,[],2*1000),?MODULE,?FUNCTION_NAME,?LINE}]),
      
    

    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
 

setup()->

   ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
  
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

