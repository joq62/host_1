%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 20121
%%% -------------------------------------------------------------------
-module(host_desired_state).  
    
%% -------------------------------------------------------2 -------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
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
   % [net_adm:ping(db_host:node(HostId))||HostId<-db_host:ids()],
    StartedOs=lists:sort(lib_host:os_started()),
    StartedHostNodes=lists:sort(lib_host:node_started()),
    HostsToStart=[HostId||HostId<-StartedOs,
			  false=:=lists:member(HostId,StartedHostNodes)],
    case HostsToStart of
	[]->
	    ok;
	HostsToStart->
	    log:log(?Log_ticket("hosts to start ",[HostsToStart])),
	 %   Result=[pod:ssh_start(HostId)||HostId<-HostsToStart],
	  %  [net_adm:ping(db_host:node(HostId))||HostId<-db_host:ids()],
	 %   log:log(?Log_ticket("Start Result ",[Result])),
	   % Result=pod:restart_hosts_nodes(HostsToStart),
	    Result=glurk,
	    Result
	    
    end.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
