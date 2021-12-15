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


%   io:format("~p~n",[{"Start detailed()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=detailed(),
    io:format("~p~n",[{"Stop detailed()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start os_status()",?MODULE,?FUNCTION_NAME,?LINE}]),
%    ok=os_status(),
%    io:format("~p~n",[{"Stop os_status()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   io:format("~p~n",[{"Start node_status()",?MODULE,?FUNCTION_NAME,?LINE}]),
%    ok=node_status(),
%    io:format("~p~n",[{"Stop node_status()",?MODULE,?FUNCTION_NAME,?LINE}]),

%   io:format("~p~n",[{"Start start_args()",?MODULE,?FUNCTION_NAME,?LINE}]),
%    ok=start_args(),
%    io:format("~p~n",[{"Stop start_args()",?MODULE,?FUNCTION_NAME,?LINE}]),

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
    
    "192.168.0.100"=db_host:ip({"c100","host2"}),
    22=db_host:port({"c100","host2"}),
    "joq62"=db_host:uid({"c100","host2"}),
    "festum01"=db_host:passwd({"c100","host2"}),
    host2@c100=db_host:node({"c100","host2"}),

    "erl -detached"=db_host:erl_cmd({"c100","host2"}),
    [{kublet,[{mode,controller}]},
    {dbase_infra,[{nodes,[host1@c100,host3@c100,host4@c100]}]},
    {bully,[{nodes,[host1@c100,host3@c100,host4@c100]}]}]=db_host:env_vars({"c100","host2"}),
    "host2"=db_host:nodename({"c100","host2"}),
    "cookie_test"=db_host:cookie({"c100","host2"}),
    
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
start_args()->
   [{erl_cmd,"erl -detached"},
    {cookie,"cookie_test"},
    {env_vars,[{kublet,[{mode,controller}]}]},
    {nodename,"host1"}]=db_host:start_args({"c100","host1"}),
    
    [{erl_cmd,"erl -detached"},
     {cookie,"cookie_test"},
     {env_vars,[{kublet,[{mode,worker}]}]},
     {nodename,"host4"}]=db_host:start_args({"c100","host4"}),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
access_info()->
    AllAccesInfo=access_info_all(),
    AllAccesInfo=db_host:access_info(),
    ["c100","c100","c100","c100"]=lists:sort(db_host:hosts()),

    [{hostname,"c100"},
     {ip,"192.168.0.100"},
     {ssh_port,22},
     {uid,"joq62"},
     {pwd,"festum01"},
     {node,host1@c100}]=db_host:access_info({"c100","host1"}),
    [{hostname,"c100"},
     {ip,"192.168.0.100"},
     {ssh_port,22},
     {uid,"joq62"},
     {pwd,"festum01"},
     {node,host3@c100}]=db_host:access_info({"c100","host3"}),
    
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
    [{{"c100","host4"},
     [{hostname,"c100"},
      {ip,"192.168.0.100"},
      {ssh_port,22},
      {uid,"joq62"},
      {pwd,"festum01"},
      {node,host4@c100}]},
    {{"c100","host2"},
     [{hostname,"c100"},
      {ip,"192.168.0.100"},
      {ssh_port,22},
      {uid,"joq62"},
      {pwd,"festum01"},
      {node,host2@c100}]},
    {{"c100","host1"},
     [{hostname,"c100"},
      {ip,"192.168.0.100"},
      {ssh_port,22}, 
      {uid,"joq62"},
      {pwd,"festum01"},
      {node,host1@c100}]},
    {{"c100","host3"},
     [{hostname,"c100"},
      {ip,"192.168.0.100"},
      {ssh_port,22},
      {uid,"joq62"},
      {pwd,"festum01"},
      {node,host3@c100}]}].
