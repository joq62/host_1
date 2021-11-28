%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(host_config).   
 
    
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ConfigDir,"host_configuration").
-define(Extension,".host").

%% --------------------------------------------------------------------


%% External exports
-export([
	 access_info/0,
	 access_info/1,
	 host/0
	 
	]).



%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:start
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
host()->
    AllHostInfo=access_info(),
    AccessInfoList=[proplists:get_value(access_info,AccessInfo)||AccessInfo<-AllHostInfo],
    Hosts=[proplists:get_value(hostname,AccessInfo)||AccessInfo<-AccessInfoList],
    Hosts.
    


%% --------------------------------------------------------------------
%% Function:start
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
access_info()->
    {ok,Files}=file:list_dir(?ConfigDir),
    HostFiles=[File||File<-Files,
		     ?Extension=:=filename:extension(File)],
    HostFileNames=[filename:join(?ConfigDir,File)||File<-HostFiles],
    AccessInfo=create_list(HostFileNames),
    AccessInfo.
access_info(HostName)->
    AllHostInfo=access_info(),
    AccessInfoList=[proplists:get_value(access_info,AccessInfo)||AccessInfo<-AllHostInfo],
    R=[Info||Info<-AccessInfoList,
	   HostName=:=proplists:get_value(hostname,Info)],
    case R of
	[I]->
	    I;
	undefined->
	    undefined
    end.
	
   
create_list(HostFileNames)->
    create_list(HostFileNames,[]).
create_list([],List)->
    List;
create_list([HostFile|T],Acc)->
    {ok,I}=file:consult(HostFile),
    create_list(T,[I|Acc]).


    


%% --------------------------------------------------------------------
%% Function:start
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
