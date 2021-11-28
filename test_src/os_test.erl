%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(os_test).   
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("kernel/include/logger.hrl").
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

 %   io:format("~p~n",[{"Start os_start()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=os_start(),
    io:format("~p~n",[{"Stop os_start()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start os_stop()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=os_stop(),
    io:format("~p~n",[{"Stop os_stop()",?MODULE,?FUNCTION_NAME,?LINE}]),

 
% 


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
os_start()->
    io:format("os_started() 1 = ~p~n",[lib_status:os_started()]),
    io:format("os_stopped() 1 = ~p~n",[lib_status:os_stopped()]),

    Stopped=lib_status:node_stopped(),
    io:format("Started 1 = ~p~n",[lib_status:node_started()]),
    io:format("Stopped 2 = ~p~n",[Stopped]),
    
    [lib_os:start(Host)||Host<-Stopped],
    
    io:format("Started 1 = ~p~n",[lib_status:node_started()]),
    io:format("Stopped 2 = ~p~n",[lib_status:node_stopped()]),
    
    Env=[{Host,rpc:call(host_config:node(Host),application,get_env,[kublet,mode])}||Host<-lib_status:node_started()],
       io:format("Env = ~p~n",[Env]),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
os_stop()->

    Started=lib_status:node_started(),
    io:format("Started 1 = ~p~n",[Started]),
    io:format("Stopped 2 = ~p~n",[lib_status:node_stopped()]),
    
    [lib_os:restart(Host)||Host<-Started],
    
    io:format("Started 1 = ~p~n",[lib_status:node_started()]),
    io:format("Stopped 2 = ~p~n",[lib_status:node_stopped()]),
   
    io:format("os_started() 1 = ~p~n",[lib_status:os_started()]),
    io:format("os_stopped() 1 = ~p~n",[lib_status:os_stopped()]),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
 

setup()->
 %   {ok,I}=file:consult("boot.config"), 
   
    % create vm dirs
 %   NodesToStart=proplists:get_value(nodes_to_start,I),
   
 %   Dirs=[Dir||{_Host,Dir,Args}<-NodesToStart],
 %   Dirs=["1","2","3","4","5","6","7","8","9","controller","sd","dbase"],
 %   [os:cmd("rm -rf "++Dir)||Dir<-Dirs],   
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

