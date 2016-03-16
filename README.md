# dot

dot is a versatile framework for package installation and configuration file management (dot files) for POSIX systems (currently, with particular focus on Ubuntu and embedded Linux). Designed to support wide range of custom configurations, yet making package and dot file installation clean and easy. Offers:
* modular architecture with modules for specific configuration sets (e.g. public terminal-only configuration, public desktop configuration, private laptop configuration etc.)
* specifying dependencies between the modules
* automatic module downloading and updating from git repositories
* configuration sets within modules (called systems) that can be used to specialize environment variables in real time depending on the currently performed task
* console GUI menus for bookmarking custom commands that can be customized for each system

Check out the default module provided with this package for inspiration.


## How it Works?

The basic idea behind dot is simple. You clone the dot repository into a convenient location (e.g. `~/.dot`) and run `install.sh`. This will add one line to your `.profile` and `.bashrc` files. No other fiels are modified by dot itself. Then, you create your own configuration sets in the `modules` sub-folder. Each module should be stored in its own git repository. The name of the module determines it's priority as it is often the case for Linux `.d` folders. Using number prefixes such as `10_dot-module-my` is a good idea. Every module placed in the `modules` folder is detected and used automatically.


## Building Modules

Each module should be stored in its own git repo which will be cloned into the `modules` folder. This way, it is easy to download and install a specific set of modules to configure a specific system. Each module typically consists of the following folders:
* `bin` - Folder added automatically to your `$PATH`. The installer will put links to your scripts and binaries there.
* `config` - Local user config files in the same folder structure in which they should be placed in your `$HOME`. Don't worry, you get to choose if they are copied there, linked there or appended/prepended to existing files.
* `config-sys` - Global system config files in the same folder structure in which they should be placed in your system root folder `/`.
* `opt` - Folder where local dependencies are installed.
* `shell` - Shell scripts configuring your environment. Several files can be present there:
    * `setup.profile` - Executed for interactive and non-interactive login sessions for any POSIX shell.
    * `setup.bash` - Executed for interactive and non-interactive, login and non-login Bash sessions.
    * `setup.sh` - Executed for interactive and non-interactive, login and non-login sessions for any POSIX shell.
    * `setup-interactive.bash` - Executed for interactive, login and non-login Bash sessions.
    * `setup-interactive.sh` - Executed for interactive, login and non-login sessions for any POSIX shell.
* `systems` - Systems provided by the module. See the systems description below.
* `tmp` - Temporary folder used for storing files during module installation. You can safely delete the files/folders there after the installation finishes.
* `install.sh` - Installation script installing user configuration and packages.

The installation script `install.sh` is used to install the module. It should be written by the user and use a set of predefined installation commands provided by dot. To see the available installation commands, check out the [`shell/tools.sh`](../shell/tools.sh) file.


## Systems

A system is a:
* set of environment settings
* an initialization scripts
* a set of commands to be easily run in a terminal console GUI

Each module can provide systems and all those systems will be available. A special commadn `sys` allows you to select which system to use at a given time. Only one system from all the modules can be used at a time. Once a system is selected with the command `sys` the current console environment as well as the environment of all the consoles started from then on will be affected by the system configuration. Additionally, the system initialization script will be run.

When a system is selected, the command `cmd` opens a console GUI that allows you to select a command to be run in the console. This is useful for executing complex commands and serves a similar purpose as bash aliases, but allows you to specify a name for each command and the commands are listed by the GUI.

Please see the empty system in the default module for the definition of a system.

## Installation

The instructions below are outdated. Module installation has been greatly simplified thanks to the `dot-get` script.

0. Close any app that you will be re-configuring by changing its config files.
1. Clone the repository to a convenient location e.g. `~/.dot` using `git clone git@github.com:pronobis/dot.git ~/.dot`
2. Go to that directory `cd ~/.dot` and run `./install.sh`
3. If you have access to sudo/root and want to install system-wide module configuration, run `sudo -EH ./install.sh`. Don't forget about the `-EH` options!
4. Clone/install your modules in `./modules`. 
5. Install each module. This typically means running (optionally) `sudo -EH ./install-sys.sh` of that module for installing global system configuration and `install.sh` for installing local user configuration. Please note that some modules might require system-wide dependency installation before user local installation can be performed.
6. Re-login
