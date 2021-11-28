%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(config_test).   
   
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

%    io:format("~p~n",[{"Start access_info()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=access_info(),
    io:format("~p~n",[{"Stop access_info()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start os_status()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=os_status(),
    io:format("~p~n",[{"Stop os_status()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start node_status()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=node_status(),
    io:format("~p~n",[{"Stop node_status()",?MODULE,?FUNCTION_NAME,?LINE}]),

%   io:format("~p~n",[{"Start start_args()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=start_args(),
    io:format("~p~n",[{"Stop start_args()",?MODULE,?FUNCTION_NAME,?LINE}]),

%   io:format("~p~n",[{"Start detailed()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=detailed(),
    io:format("~p~n",[{"Stop detailed()",?MODULE,?FUNCTION_NAME,?LINE}]),

%   io:format("~p~n",[{"Start start_stop()",?MODULE,?FUNCTION_NAME,?LINE}]),
 %   ok=start_stop(),
 %   io:format("~p~n",[{"Stop start_stop()",?MODULE,?FUNCTION_NAME,?LINE}]),



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


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
 


detailed()->
    
    "192.168.0.201"=host_config:ip("c201"),
    22=host_config:ssh_port("c201"),
    "joq62"=host_config:uid("c201"),
    "festum01"=host_config:passwd("c201"),
    host@c201=host_config:node("c201"),

    "/lib/erlang/bin/erl -detached"=host_config:erl_cmd("c201"),
    [{kublet,[{mode,controller}]}]=host_config:env_vars("c201"),
    "host"=host_config:nodename("c201"),
    "cookie"=host_config:cookie("c201"),
    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
start_args()->
   [{erl_cmd,"/lib/erlang/bin/erl -detached"},
    {cookie,"cookie"},
    {env_vars,[{kublet,[{mode,controller}]}]},
    {nodename,"host"}]=host_config:start_args("c200"),
    
    [{erl_cmd,"/snap/erlang/current/usr/bin/erl -detached"},
     {cookie,"cookie"},
     {env_vars,[{kublet,[{mode,worker}]}]},
     {nodename,"host"}]=host_config:start_args("c203"),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
access_info()->
    AllAccesInfo=access_info_all(),
    AllAccesInfo=host_config:access_info(),
    ["c200","c201","c202","c203"]=lists:sort(host_config:host()),

    [{hostname,"c200"},
     {ip,"192.168.0.200"},
     {ssh_port,22},
     {uid,"joq62"},
     {pwd,"festum01"},
     {node,host@c200}]=host_config:access_info("c200"),
    [{hostname,"c203"},
     {ip,"192.168.0.203"},
     {ssh_port,22},
     {uid,"pi"},
     {pwd,"festum01"},
     {node,host@c203}]=host_config:access_info("c203"),
    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
os_status()->
    Started=lib_status:os_started(),
    Stopped=lib_status:os_stopped(),
    io:format("Started = ~p~n",[Started]),
    io:format("Stopped = ~p~n",[Stopped]),
    
    io:format("Started(c200) = ~p~n",[lib_status:os_started("c200")]),
    io:format("Started(c100) = ~p~n",[lib_status:os_started("c100")]),
    io:format("Stopped(c203) = ~p~n",[lib_status:os_stopped("c203")]),

    
    ok.
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
node_status()->
    Started=lib_status:node_started(),
    Stopped=lib_status:node_stopped(),
    io:format("Started = ~p~n",[Started]),
    io:format("Stopped = ~p~n",[Stopped]),
    
    io:format("Started(c200) = ~p~n",[lib_status:node_started("c200")]),
    io:format("Started(c100) = ~p~n",[lib_status:node_started("c100")]),
    io:format("Stopped(c203) = ~p~n",[lib_status:node_stopped("c203")]),

    
    ok.
    
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


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

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

access_info_all()->
    [[{hostname,"c201"},
      {access_info,
       [{hostname,"c201"},
	{ip,"192.168.0.201"},
	{ssh_port,22},
	{uid,"joq62"},
	{pwd,"festum01"},
	{node,host@c201}]},
      {host_type,[{type,auto_erl_controller}]},
      {start_args,
       [{erl_cmd,"/lib/erlang/bin/erl -detached"},
	{cookie,"cookie"},
	{env_vars,[{kublet,[{mode,controller}]}]},
	{nodename,"host"}]},
      {dirs_to_keep,["logs"]},
      {application_dir,"applications"}],
     [{hostname,"c203"},
      {access_info,
       [{hostname,"c203"},
	{ip,"192.168.0.203"},
	{ssh_port,22},
	{uid,"pi"},
	{pwd,"festum01"},
	{node,host@c203}]},
             {host_type,[{type,non_auto_erl_workerr}]},
      {start_args,
       [{erl_cmd,"/snap/erlang/current/usr/bin/erl -detached"},
	{cookie,"cookie"},
	{env_vars,[{kublet,[{mode,worker}]}]},
	{nodename,"host"}]},
      {dirs_to_keep,["logs"]},
      {application_dir,"applications"}],
     [{hostname,"c200"},
      {access_info,
       [{hostname,"c200"},
	{ip,"192.168.0.200"},
	{ssh_port,22},
	{uid,"joq62"},
	{pwd,"festum01"},
	{node,host@c200}]},
      {host_type,[{type,auto_erl_controller}]},
      {start_args,
       [{erl_cmd,"/lib/erlang/bin/erl -detached"},
	{cookie,"cookie"},
	{env_vars,[{kublet,[{mode,controller}]}]},
	{nodename,"host"}]},
      {dirs_to_keep,["logs"]},
      {application_dir,"applications"}],
     [{hostname,"c202"},
      {access_info,
       [{hostname,"c202"},
	{ip,"192.168.0.202"},
	{ssh_port,22},
	{uid,"joq62"},
	{pwd,"festum01"},
	{node,host@c202}]},
      {host_type,[{type,auto_erl_controller}]},
      {start_args,
       [{erl_cmd,"/lib/erlang/bin/erl -detached"},
	{cookie,"cookie"},
	{env_vars,[{kublet,[{mode,controller}]}]},
	{nodename,"host"}]},
      {dirs_to_keep,["logs"]},
      {application_dir,"applications"}]].
