## Git It On

A lot of times we have to look at files on GitHub.  But this intrudes our ideal command-line workflow, having to switch to a browser and navigate to the URL.  Wouldn't it be nice to just be able to open that file from the command line?

*Git It On*, the plugin for zshell, comes in here.

* `gitit repo` -- opens the base repository to your current branch
* `gitit repo <folder>` -- opens that folder in your current branch
* `gitit repo .` -- opens current folder in git at your current branch
* `gitit compare` -- opens the compare file between your branch and master
* `gitit commits` -- opens the commits for your current branch
* `gitit file <filename>` -- opens the github page for the desired file (files are defined relative to the base repo, not your current path)
* `gitit history <filename>` -- opens the github history page for the file
* `gitit grep <term>` -- opens the github search page for your term

## Installation

Assuming you have [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), you can simply write

```bash
git clone https://github.com/peterhurford/git-it-on.zsh ~/.oh-my-zsh/custom/plugins/git-it-on
echo "plugins+=(git-it-on)" >> ~/.zshrc
```

(Alternatively, you can place the `git-it-on` plugin in the `plugins=(...)` local manually.)

If you're lame and use bash, you can install this directly to your `~/.bash_profile`:

```bash
curl -s https://raw.githubusercontent.com/peterhurford/git-it-on.zsh/master/git-it-on.plugin.zsh >> ~/.bash_profile
```````

## But why even leave vim for the command line?
TODO: Make and link vim companion plugin.


## These commands are too long, I want to be even faster!
You can make commands faster by using aliases.  Put the following in your `.zshrc` (or `.bash_profile`)

```
#Gitit Aliases
alias repo="gitit repo"
alias compare="gitit compare"
alias commits="gitit commits"
alias file="gitit file"
alias gistory="gitit history"
alias gitgrep="gitit grep"
```

Feel free to change the aliases to whatever you'd like. You can even make them shorter, but the above is what I use.  Note that these aliases are not included by default.

If you want more git-related aliases for making your git workflow faster, also look at my [Git-aliases.zsh](https://github.com/peterhurford/git-aliases.zsh) plugin.


## Got any more plugins to share?
* [Send.zsh](https://github.com/robertzk/send.zsh), a git command by ro
bertzk that combines `git add .`, `git commit -a -m`, and `git push ori
gin <branch>`.
* [Send.vim](https://github.com/peterhurford/send.vim), a vim plugin by
 me to do the above _without leaving vim_.
