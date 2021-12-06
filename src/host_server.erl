%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : resource discovery accroding to OPT in Action 
%%% This service discovery is adapted to 
%%% Type = application 
%%% Instance ={ip_addr,{IP_addr,Port}}|{erlang_node,{ErlNode}}
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(host_server). 

-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
% -include("").
%% --------------------------------------------------------------------

%-define(ScheduleInterval,1*30*1000).

%% External exports
-export([
	]).


-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
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
   
 %   spawn(fun()->do_desired_state() end),
    
    {ok, #state{}
    }.

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

handle_call({started_nodes},_From, State) ->
    Reply=lib_status:node_started(),
    {reply, Reply, State};
handle_call({host_status},_From, State) ->
    Reply=db_host:status(),
    {reply, Reply, State};
handle_call({host_status,Id},_From, State) ->
    Reply=db_host:status(Id),
    {reply, Reply, State};
handle_call({node_status},_From, State) ->
    Reply=glurk,
    {reply, Reply, State};
handle_call({node_status,Id},_From, State) ->
    Reply=glurk,
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
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_cast({desired_state,CallerPid}, State) ->
    spawn(fun()->do_desired_state(CallerPid) end),
    {noreply, State};

handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{Msg,?MODULE,?LINE,time()}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{Info,?MODULE,?LINE,time()}]),
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
do_desired_state(CallerPid)->
   % io:format("~p~n",[{time(),node(),?MODULE,?FUNCTION_NAME,?LINE,CallerPid}]),
    case rpc:call(node(),host_desired_state,start,[],25*1000) of
	[]->
	    ok;
	Action->
	    {ok,HostName}=net:gethostname(),
	    CallerPid!{{HostName,node()},desired_state_ret,[Action]}
    end.
		  


do_desired_state_old()->
%    io:format("~p~n",[{?MODULE,?FUNCTION_NAME,?LINE,time()}]),
    timer:sleep(glurk),
    Result=case bully:am_i_leader(node()) of
	       false->
		   act_follower;
	       true->
		   rpc:call(node(),host_desired_state,start,[],25*1000)
	   end,
    
    io:format("~p~n",[{time(),node(),Result}]),
    rpc:cast(node(),?MODULE,desired_state,[]).
		  
