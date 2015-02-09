# dot

Ubuntu-oriented dot file management system providing:
* modular architecture with modules for specific configuration sets (e.g. for your public terminal configuration, for your public GUI configuration, for your private laptop configuration etc.) that can be stacked on top of each other
* console GUI tools for selecting configuration subsets provided by the modules (called systems) that can modify your environment variables and automatically run init scripts
* console GUI menu for running commands that can be customized for each system

Check out the default module provided with this package for inspiration.

## Module Structure

Each module is typically stored in its own repo which will be cloned into the `modules`. This permits selection of modules to be used. Each module typically consists of the following folders:
* `bin` - Folder added automatically to your `$PATH`. The installer will put links to your scripts and binaries there.
* `config` - Local user config files in the same folder structure in which they should be placed in your `$HOME`. Don't worry, you get to choose if they are copied there, linked there or appended/prepended to existing files.
* `config-sys` - Global system config files in the same folder structure in which they should be placed in your system root folder `/`.
* `opt` - Folder where local dependencies are installed.
* `shell` - Shell scripts configuring your environment. Two files should be present there `setup.bash` and `setup.profile`. `setup.bash` will automatically be executed by your `~/.bashrc` and `setup.profile` by your `~/.profile`.
* `systems` - Systems provided by the module. See the systems description below.
* `tmp` - Temporary folder used for storing files during module installation. You can safely delete the files/folders there after the installation finishes.

## Systems

A system is a:
* set of environment settings
* an initialization scripts
* a set of commands to be easily run in a terminal console GUI

Each module can provide systems and all those systems will be available. A special commadn `sys` allows you to select which system to use at a given time. Only one system from all the modules can be used at a time. Once a system is selected with the command `sys` the current console environment as well as the environment of all the consoles started from then on will be affected by the system configuration. Additionally, the system initialization script will be run.

When a system is selected, the command `cmd` opens a console GUI that allows you to select a command to be run in the console. This is useful for executing complex commands and serves a similar purpose as bash aliases, but allows you to specify a name for each command and the commands are listed by the GUI.

Please see the empty system in the default module for the definition of a system.

## Installation

1. Clone the repository to a convenient location e.g. `~/.dot`
2. Go to that directory and run `install.sh`
3. Clone/install your modules in `./modules`. The name of the module determines it's priority.
4. Run `install.sh` in each module.
