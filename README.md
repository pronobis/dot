# dot

Ubuntu-oriented dot file management system providing:
* modular architecture with modules for specific configuration sets (e.g. for your public terminal configuration, for your public GUI configuration, for your private laptop configuration etc.) that can be stacked on top of each other
* console GUI tools for selecting configuration subsets provided by the modules (called systems) that can modify your environment variables and automatically run init scripts
* console GUI menu for running commands that can be customized for each system

Check out the default module provided with this package for inspiration.


## Installation

1. Clone the repository to a convenient location e.g. `~/.dot`
2. Go to that directory and run `install.sh`
3. Clone/install your modules in `./modules`. The name of the module determines it's priority.
4. Run `install.sh` in each module.
