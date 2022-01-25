%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : resource discovery accroding to OPT in Action 
%%% This service discovery is adapted to 
%%% Type = application 
%%% Instance ={ip_addr,{IP_addr,Port}}|{erlang_node,{ErlNode}}
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(vm_server). 

-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
-include("vm.hrl").
%% --------------------------------------------------------------------



%% External exports
-export([
	]).


-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
		root_dir,
		desired_apps, %[{App,Vsn,GitPath},..]
		current_apps %[{App,Vsn,eexist|not_loaded|not_started|loaded|started}
	       }).

%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    
%    {ok,RootDir}=application:get_env(root_dir),
%    {ok,DesiredApps}=application:get_env(desired_apps),
    
    {ok, #state{root_dir=undefined,
	       desired_apps=[],
	       current_apps=[]}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------


handle_call({set_root_dir,RootDir},_From, State) ->
    Reply= case State#state.root_dir of
	       undefined->
		   NewState=State#state{root_dir=RootDir},
		   ok;
	       ExistingRootDir->
		   NewState=State,
		   {error,[alredy_exists,ExistingRootDir]}
	   end,
    {reply, Reply, NewState};


handle_call({desired_apps,AppInfoList},_From, State) ->
    NewState=State#state{desired_apps=AppInfoList},
    Reply= ok,
    {reply, Reply, NewState};


handle_call({ping},_From, State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call({stopped},_From, State) ->
    Reply=ok,
    {reply, Reply, State};


handle_call({not_implemented},_From, State) ->
    Reply=not_implemented,
    {reply, Reply, State};

handle_call({stop}, _From, State) ->
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    log:log(?Log_ticket("unmatched call",[Request, From])),
    Reply = {ticket,"unmatched call",Request, From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_cast({desired_state}, State) ->
    
    spawn(fun()->do_desired_state(State#state.root_dir,State#state.desired_apps) end),
    {noreply, State};

handle_cast(Msg, State) ->
    log:log(?Log_ticket("unmatched cast",[Msg])),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
    log:log(?Log_ticket("unmatched info",[Info])),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
do_desired_state(RootDir,DesiredApps)->
    % io:format("~p~n",[{time(),node(),?MODULE,?FUNCTION_NAME,?LINE,CallerPid}]),
    rpc:call(node(),lib_vm,desired_state,[RootDir,DesiredApps]),
    timer:sleep(?ScheduleInterval),
    rpc:cast(node(),vm,desired_state,[]).
		  
