# dot

dot is a versatile framework for package installation and configuration file management (dot files) for POSIX systems (currently, with particular focus on Ubuntu and embedded Linux). Designed to support wide range of custom configurations, yet making package and dot file installation clean and easy. Offers:
* modular architecture with modules for specific configuration sets (e.g. public terminal-only configuration, public desktop configuration, private laptop configuration etc.)
* specifying dependencies between the modules
* automatic module downloading and updating from git repositories
* configuration sets within modules (called systems) that can be used to specialize environment variables in real time depending on the currently performed task
* console GUI menus for bookmarking custom commands that can be customized for each system

Check out the default module provided with this package in `modules/00_defaults` for inspiration.


## How it Works?

The basic idea behind dot is simple. You clone the dot repository into a convenient location (e.g. `~/.dot`) and run `install.sh`. This will add one line to your `.profile` and `.bashrc` files. No other fiels are modified by dot itself. Then, you create your own configuration sets in the `modules` sub-folder. Each module should be stored in its own git repository. The name of the module determines it's priority as it is often the case for Linux `.d` folders. Using number prefixes such as `10_dot-module-my` is a good idea. Every module placed in the `modules` folder is detected and used automatically.


## Building Modules

Each module should be stored in its own git repo which will be cloned into the `modules` folder. This way, it is easy to download and install a specific set of modules to configure a specific system. Each module typically consists of the following folders:
* `bin` - Folder added automatically to your `$PATH`. The installer will put links to your scripts and binaries there.
* `config` - Local user config files in the same folder structure in which they should be placed in `$HOME`. You get to choose if they are copied, linked or appended/prepended to existing files.
* `config-sys` - Global system config files in the same folder structure in which they should be placed in the system root folder `/`.
* `opt` - Folder where local dependencies are installed.
* `shell` - Shell scripts configuring the environment. Several files can be present there:
    * `setup.profile` - Executed for interactive and non-interactive login sessions for any POSIX shell.
    * `setup.bash` - Executed for interactive and non-interactive, login and non-login Bash sessions.
    * `setup.sh` - Executed for interactive and non-interactive, login and non-login sessions for any POSIX shell.
    * `setup-interactive.bash` - Executed for interactive, login and non-login Bash sessions.
    * `setup-interactive.sh` - Executed for interactive, login and non-login sessions for any POSIX shell.
* `systems` - Systems provided by the module. See the systems description below.
* `tmp` - Temporary folder used for storing temporary files during module installation. The files in this folder can be safely deleted after the installation finishes.
* `default_name` - File containing the default name of the module used by the `dot-get` installer.
* `dependencies` - File containing the URLs of the git repos of modules on which this module depends.
* `install.sh` - Main installation script installing user configuration and packages.

The default module provided with this package in `modules/00_defaults` serves as an example of a module and can be used to initialize a new git repo with a custom module.

The installation script `install.sh` is used to install the module. It should be written by the user and use the predefined installation commands provided by dot. To see the available installation commands, check out the [`shell/tools.sh`](shell/tools.sh) file.


## Systems

*Systems* are configuration sets within modules that can be used to specialize/modify environment variables in real time depending on the currently performed task. A system is a:
* set of environment settings activated when the system is enabled
* an initialization script run when the system is enabled

Additionally, a system provides a set of command line bookmarks that can be easily run using a terminal console GUI.

Each module can provide multiple *systems*. A special command `sys` is used to select and enable a *system* and only one *system* can be active at a given time. Once a *system* is selected with the command `sys`, the environment of the current console  as well as all the consoles opened from then on will be modified by the *system*. Additionally, the initialization script will be run.

When a *system* is selected, the command `cmd` opens a console GUI that provides access to bookmarks. Each bookmark corresponds to a single command to be executed in the console. This is useful for executing complex commands.

Please see the empty system in the default module `modules/00_defaults` for an example of a definition of a *system*.


## Installation

The first step is to install dot itself. To do so:
* Make sure that `git` is installed on your system
* Clone and install dot:

  ```
  git clone https://github.com/pronobis/dot.git ~/.dot; ~/.dot/install.sh
  ```
  
  Here, dot was installed in `~/.dot`, but any location can be used.
* Re-login

Now, it's time to install modules. Modules are downloaded (and later updated) using the `dot-get` command. To install a new module, run `dot-get add <repo_url> [<module_name>]`. If no name is given, the one defined in the file `default_name` in the module will be used. All module dependencies will be downloaded automatically. Once modules are downloaded, manually run the `install.sh` script of each module. Re-login when done.


## Commands Provided by dot

* `cdot` - `cd` to the folder where dot is installed
* `dot-get` - download/update modules, run `dot-get` without arguments for help
* `cmd` - select and run bookmark commands
* `sys` - select and activate a system
