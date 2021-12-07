%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 20121
%%% -------------------------------------------------------------------
-module(host_desired_state).  
    
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
start()->
    {ok,StartedHosts,StoppedHosts}=lib_status:start(),
    io:format("StartedHosts = ~p~n",[[{node(),?MODULE,?FUNCTION_NAME,?LINE,StartedHosts}]]),

    NodesToStart=[Id||{host_started,Id,_Ip,_Port}<-StartedHosts,
		 true=:=lib_status:node_stopped(Id)],
    io:format("NodesToStart = ~p~n",[[{node(),?MODULE,?FUNCTION_NAME,?LINE,NodesToStart}]]),
    StartedNodesId=[lib_os:start_host_node(Id)||Id<-NodesToStart],
  %  io:format("StartedNodesId = ~p~n",[[{node(),?MODULE,?FUNCTION_NAME,?LINE,StartedNodesId}]]),
    case StartedNodesId of
	[]->
	    ok;
	_->
	    io:format("StartedNodes = ~p~n",[[{?MODULE,?FUNCTION_NAME,?LINE,StartedNodesId}]])
    end,
    StartedNodesId.
    
 %   io:format("NodesToStart = ~p~n",[{?MODULE,?LINE,NodesToStart}]),
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------


