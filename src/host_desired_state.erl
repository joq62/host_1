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
    NodesToStart=[Host||Host<-StartedHosts,
		 true=:=lib_status:node_stopped(Host)],
    [lib_os:start(Host)||Host<-NodesToStart],
    {ok,NodesToStart}.
    
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


