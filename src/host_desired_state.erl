%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
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
    StartedHosts=lib_status:os_started(),
   % io:format("StartedHosts = ~p~n",[[{?MODULE,?FUNCTION_NAME,?LINE,StartedHosts}]]),
    NodesToStart=[Id||Id<-StartedHosts,
		 true=:=lib_status:node_stopped(Id)],
    StartedNodesId=[lib_os:start(Id)||Id<-NodesToStart],
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


