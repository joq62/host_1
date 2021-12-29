%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(init_test).    
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-include("controller.hrl").
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

%    io:format("~p~n",[{"Start pass1()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=pass1(),
    io:format("~p~n",[{"Stop pass1()",?MODULE,?FUNCTION_NAME,?LINE}]),

%    io:format("~p~n",[{"Start pass2()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=pass2(),
    io:format("~p~n",[{"Stop pass2()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start add_node()",?MODULE,?FUNCTION_NAME,?LINE}]),
 %   ok=add_node(),
 %   io:format("~p~n",[{"Stop add_node()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start node_status()",?MODULE,?FUNCTION_NAME,?LINE}]),
 %   ok=node_status(),
 %   io:format("~p~n",[{"Stop node_status()",?MODULE,?FUNCTION_NAME,?LINE}]),

%   io:format("~p~n",[{"Start start_args()",?MODULE,?FUNCTION_NAME,?LINE}]),
 %   ok=start_args(),
 %   io:format("~p~n",[{"Stop start_args()",?MODULE,?FUNCTION_NAME,?LINE}]),

%   io:format("~p~n",[{"Start detailed()",?MODULE,?FUNCTION_NAME,?LINE}]),
%    ok=detailed(),
%    io:format("~p~n",[{"Stop detailed()",?MODULE,?FUNCTION_NAME,?LINE}]),

%   io:format("~p~n",[{"Start start_stop()",?MODULE,?FUNCTION_NAME,?LINE}]),
 %   ok=start_stop(),
 %   io:format("~p~n",[{"Stop start_stop()",?MODULE,?FUNCTION_NAME,?LINE}]),



 %   
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
    [{"c100","host1"},
     {"c100","host2"},
     {"c100","host3"},
     {"c100","host4"}]=lists:sort(lib_status:os_started()),
    []=lists:sort(lib_status:node_started()),
    
    {ok,AppInfo}=host_desired_state:start(),
    [{{"c100","host1"},host1@c100},
     {{"c100","host2"},host2@c100},
     {{"c100","host3"},host3@c100}, 
     {{"c100","host4"},host4@c100}]=lists:keysort(2,AppInfo),
    ok=application:start(host),
    timer:sleep(10*1000),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
pass2()->
    [{"c100","host1"},
     {"c100","host2"},
     {"c100","host3"},
     {"c100","host4"}]=lists:sort(lib_status:os_started()),
    [{"c100","host1"},
     {"c100","host2"},
     {"c100","host3"},
     {"c100","host4"}]=lists:sort(lib_status:node_started()),
    {ok,[]}=host_desired_state:start(),
    ok.
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
    %% 
 %   [CtrlNode|_]=[N||{{"controller","1.0.0"},N,_Dir,_App,Vsn}<-AppInfo],
    
  %  io:format("CtrlNode, sd:all() ~p~n",[{rpc:call(CtrlNode,sd,all,[],5*1000),?MODULE,?FUNCTION_NAME,?LINE}]),
  %  timer:sleep(1000),
  % io:format(" who_is_leader ~p~n",[{rpc:call(CtrlNode,bully,who_is_leader,[],5*1000),?MODULE,?FUNCTION_NAME,?LINE}]),

    
    %%
 %   DbaseNodes=rpc:call(CtrlNode,sd,get,[dbase_infra],5*1000),
 %   io:format("DbaseNodes ~p~n",[{DbaseNodes,?MODULE,?FUNCTION_NAME,?LINE}]),
 %   X1=[{N,rpc:call(N,db_service_catalog,read_all,[],5*1000)}||N<-DbaseNodes],
  %  io:format("db_service_catalog ~p~n",[{X1,?MODULE,?FUNCTION_NAME,?LINE}]),
  %  X2=[{N,rpc:call(N,mnesia,system_info,[],5*1000)}||N<-DbaseNodes],
  %  io:format("mnesia:system_info ~p~n",[{X2,?MODULE,?FUNCTION_NAME,?LINE}]),
    
    %%
 %   io:format("db_deploy_state ~p~n",[{db_deploy_state:read_all(),?MODULE,?FUNCTION_NAME,?LINE}]),
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
    
%get_nodes()->
 %   [host1@c100,host2@c100,host3@c100,host4@c100].
    
%start_slave(NodeName)->
 %   HostId=net_adm:localhost(),
  %  Node=list_to_atom(NodeName++"@"++HostId),
   % rpc:call(Node,init,stop,[]),
    
   % Cookie=atom_to_list(erlang:get_cookie()),
   % gl=Cookie,
  %  Args="-pa ebin -setcookie "++Cookie,
  %  io:format("Node Args ~p~n",[{Node,Args}]),
  %  {ok,Node}=slave:start(HostId,NodeName,Args).

setup()->

 
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
  
    ok.
