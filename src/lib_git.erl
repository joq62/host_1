%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lib_git).   
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
-compile(export_all).

-export([
%	 clone/3
	]).


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
clone(GitName,GitPath)->
    os:cmd("rm -rf "++GitName),    
    os:cmd("git clone "++GitPath),
    {ok,GitName}.

clone_to_dir(GitName,GitPath,DestinationDir)->
    Result=case filelib:is_dir(DestinationDir) of
	       false->
		   {error,[eexists,DestinationDir]};
	       true->
		   GitDir=filename:join(DestinationDir,GitName),
		   os:cmd("rm -rf "++GitDir),
		   os:cmd("git clone "++GitPath++" "++DestinationDir),
		   case filelib:is_dir(GitDir) of
		       false->
			   {error,[clone_failed]};
		       true->
			   {ok,GitDir}
		   end
	   end,
    Result.



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
ssh_call(Id,Msg,Timeout)->
    Ip=db_host:ip(Id),
    SshPort=db_host:port(Id),
    Uid=db_host:uid(Id),
    Pwd=db_host:passwd(Id),
    {Host,_}=Id,
   % io:format("get_hostname= ~p~n",[{?MODULE,?LINE,HostId,User,PassWd,IpAddr,Port}]),
    rpc:call(node(),my_ssh,ssh_send,[Ip,SshPort,Uid,Pwd,Msg,Timeout],Timeout-1000).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
restart(HostId)->
    Type=db_host:type(HostId),
    ssh_call(HostId,"reboot",5000).    

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
