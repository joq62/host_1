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
    StartedOs=lists:sort(lib_status:os_started()),
    StartedHostNodes=lists:sort(lib_status:node_started()),
    HostsToStart=[HostId||HostId<-StartedOs,
			  false=:=lists:member(HostId,StartedHostNodes)],
    pod:map_ssh_start(HostsToStart).

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


