%% Author: uabjle
%% Created: 10 dec 2012
%% Description: TODO: Add description to application_org
-module(vm). 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Definitions 
%% --------------------------------------------------------------------
-define(SERVER,vm_server).
%% --------------------------------------------------------------------
-export([
	 set_root_dir/1,
	 desired_apps/1,
	 ping/0
        ]).

-export([
	
	 start/0,
	 stop/0
	]).



%% ====================================================================
%% External functions
%% ====================================================================

load_start(RootDir,DesiredApps)->
    application:set_env([{vm,[{root_dir,RootDir},{desired_apps,DesiredApps}]}]).
%% Asynchrounus Signals
%% Gen server functions

start()-> gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
stop()-> gen_server:call(?SERVER, {stop},infinity).




%%---------------------------------------------------------------
-spec ping()-> {atom(),node(),module()}|{atom(),term()}.
%% 
%% @doc:check if service is running
%% @param: non
%% @returns:{pong,node,module}|{badrpc,Reason}
%%
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).
set_root_dir(RootDir)-> 
    gen_server:call(?SERVER, {set_root_dir,RootDir},infinity).
desired_apps(AppInfoList)-> 
    gen_server:call(?SERVER, {desired_apps,AppInfoList},infinity).


%%----------------------------------------------------------------------
