%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lib_app).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
%-compile(export_all).
-export([
	 git_load/4,
	 load/1,
	 start/1,
	 stop/1,
	 unload/1,
	 delete/2
	]).
	 



%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
delete(App,AppDir)->
    application:stop(App),
    application:unload(App),
    os:cmd("rm -rf "++AppDir),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
load(App)->
    application:load(App).
start(App)->
    application:start(App).

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
unload(App)->
    application:unload(App).
stop(App)->
    application:stop(App).
 
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
git_load(App,Vsn,RootDir,GitPath)->
    AppStr=atom_to_list(App),
    AppDir=AppStr,
    AppDirDest=filename:join(RootDir,AppDir),
    % Create temp dir
    UId=integer_to_list(erlang:system_time(microsecond)),
    TmpDir=UId++".tmp",
    TmpAppDir=filename:join(TmpDir,AppDir),
    ok=file:make_dir(TmpDir),
    ok=file:make_dir(TmpAppDir),

    GitCmd="git clone "++GitPath++" "++TmpAppDir,
    os:cmd(GitCmd),
    TmpAppFile=filename:join([TmpAppDir,"ebin",AppStr++".app"]),		    
    Result=case filelib:is_file(TmpAppFile) of
	       false->
		   {error,[failed_to_git_clone,App,Vsn,GitPath,TmpAppFile]};
	       true->
			     % Set up AppDir
		   os:cmd("rm -rf "++AppDirDest),
		   os:cmd("mv "++TmpAppDir++" "++RootDir),
		   AppFile=filename:join([RootDir,AppDir,"ebin",AppStr++".app"]),		    
		   case filelib:is_file(AppFile) of
		       false->
			   {error,[failed_to_git_clone,App,Vsn,GitPath,AppFile]};
		       true->
			   Ebin=filename:join([RootDir,AppDir,"ebin"]),
			   case code:add_patha(Ebin) of
			       {error,Reason}->
				   {error,Reason};
			       true->
				   ok
			   end
		   end
	   end,

    % Delete tmp
    os:cmd("rm -rf "++TmpDir),
    timer:sleep(200),   
    Result.
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------


