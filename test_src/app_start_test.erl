%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(app_start_test).    
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include("controller.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([start/0]).

%-define(PodDir,"test.pod").
-define(PodDir,".").

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
    ?debugMsg("Start setup"),
    ?assertEqual(ok,setup()),
    ?debugMsg("stop setup"),

 %   ?debugMsg("Start testXXX"),
 %   ?assertEqual(ok,single_node()),
 %   ?debugMsg("stop single_node"),
    
      %% End application tests
    ?debugMsg("Start cleanup"),
    ?assertEqual(ok,cleanup()),
    ?debugMsg("Stop cleanup"),

    ?debugMsg("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
get_nodes()->
    [host1@c100,host2@c100,host3@c100,host4@c100].
    
start_slave(NodeName)->
    HostId=net_adm:localhost(),
    Node=list_to_atom(NodeName++"@"++HostId),
    rpc:call(Node,init,stop,[]),
    
    Cookie=atom_to_list(erlang:get_cookie()),
   % gl=Cookie,
    Args="-pa ebin -setcookie "++Cookie,
    io:format("Node Args ~p~n",[{Node,Args}]),
    {ok,Node}=slave:start(HostId,NodeName,Args).

setup()->
    %load configas
    os:cmd("mkdir "++?PodDir),
    ok=lib_controller:load_configs(?PodDir),
    ok=application:start(dbase_infra),
    ok=lib_controller:initiate_dbase(?PodDir),    

    [host1@c100,host2@c100,host3@c100]=connect:get(?ControllerNodes),
    Ids=lists:sort(db_host:ids()),
    Ids=[{"c100","host1"},
	 {"c100","host2"},
	 {"c100","host3"},
	 {"c100","host4"}],

    Nodes=[db_host:node(Id)||Id<-Ids],
    [host1@c100,host2@c100,host3@c100,host4@c100]=Nodes,
    [rpc:call(Node,init,stop,[],100)||Node<-Nodes],
    timer:sleep(1000),
    ok.



%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
  
  %  init:stop(),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
