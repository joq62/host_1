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
-include("logger_infra.hrl").
%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
%-compile(export_all).
-export([
	 start/0

	 ]).

%% ====================================================================
%% External functions
%% ====================================================================
start()->
    StartedOs=lists:sort(lib_status:os_started()),
    StartedHostNodes=lists:sort(lib_status:node_started()),
    HostsToStart=[HostId||HostId<-StartedOs,
			  false=:=lists:member(HostId,StartedHostNodes)],
    case HostsToStart of
	[]->
	    ok;
	HostsToStart->
	    log:log(?logger_info(info,"HostsToStart",[HostsToStart])),
	    pod:map_ssh_start(HostsToStart)
    end.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
