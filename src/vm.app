%% This is the application resource file (.app file) for the 'base'
%% application.
{application, vm,
[{description, "Vm application and cluster" },
{vsn, "1.0.0" },
{modules, 
	  [vm_app,vm_sup,vm,vm_server]},
{registered,[vm]},
{applications, [kernel,stdlib]},
{mod, {vm_app,[]}},
{start_phases, []},
{git_path,"https://github.com/joq62/vm_server.git"}
]}.
