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
%% --------------------------------------------------------------------

%% External exports
-export([start/0]).

-define(PodDir,"test.pod").

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
    Nodes=get_nodes(),
   % gl=Nodes,
    [rpc:call(Node,init,stop,[],100)||Node<-Nodes],
  %  timer:sleep(2000),
    [{ok,host1@c100},
     {ok,host2@c100},
     {ok,host3@c100},
     {ok,host4@c100}]=[start_slave(NodeName)||NodeName<-["host1","host2","host3","host4"]],
   % [{ok,host1@c100}]= [start_slave(NodeName)||NodeName<-["host1"]],


    %load configas
    os:cmd("mkdir "++?PodDir),
    ok=lib_controller:load_configs(?PodDir),
    ok=application:start(dbase_infra),
    ok=lib_controller:initiate_dbase(?PodDir),
    
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
