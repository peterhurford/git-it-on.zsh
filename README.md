## Git It On

A lot of times we have to look at files on GitHub.  But this intrudes our ideal command-line workflow, having to switch to a browser and navigate to the URL.  Wouldn't it be nice to just be able to open that file from the command line?

*Git It On*, the plugin for zshell, comes in here.

* `gitit repo` -- opens the repository to your current branch
* `gitit compare` -- opens the compare file between your branch and master
* `gitit file <filename>` -- opens the github page for the desired file
* `gitit history <filename>` -- opens the github history page for the file
* `gitit grep <term>` -- opens the github search page for your term

## Installation
TODO: Write Installation


## But why even leave vim for the command line?
TODO: Make and link vim companion plugin.


## These commands are too long, I want to be even faster!
TODO: Explain aliasing.


## If you like this, you might also like...
* [Send.zsh](https://github.com/robertzk/send.zsh), a git command by ro
bertzk that combines `git add .`, `git commit -a -m`, and `git push ori
gin <branch>`.
* [Send.vim](https://github.com/peterhurford/send.vim), a vim plugin by
 me to do the above _without leaving vim_.
* [Git-aliases.zsh](https://github.com/peterhurford/git-aliases.zsh), an omnibus of useful git aliases for speeding up the git workflow.
