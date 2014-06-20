---
layout: post
title:  "Vimmified!"
date:   2014-06-14 20:52:15
categories: software Vim editors
---

I'm not sure why I've started to use Vim obsessively over the last week - there are a number of factors feeding in, mostly centred around my perverse need to do make something more difficult than is strictly necessary; I'm learning Vim "Because it's there"...

That's not strictly true - if I'm going to blame something it's going to be Windows Vista. Or, more speifically, the way Windows Vista insists on sporadically freezing my mouse for 10-20 seconds every fifteen minutes or so.  It starts to add up, killing the flow of the work and slowing me down no end.

So I discovered [Vimium][Vimium], an extension for Chromium that puts all the Vim keys into the browser. If you've used the shortcut keys in Twitter you'll be right at home (the same with Gmail's shortcuts but slightly less so). It's not only let me circumvent my mouse when it freezes; I've found myself using it in preference to the mouse in most cases, fingers sitting happily on the home keys as I navigate around the web, mostly without any hold ups. Even if you don't think you'll use it it's worth installing just to see the way it implements link clicking.

So having got this far it felt churlish not to go and install Vim, by way of the Windows build of [Gvim][Gvim]. Now, while I'm trying to wean myself off Windows (made much easier by having a Vista box at work), I am still forced to use it (oh that Vista box at work). I'd been happy up to now with [Sublime Text 3][ST3], which I have synced across all my computers and which also implements a ['Vintage'][ST3Vim] (should that be 'Vimtage') mode with a most of the Vim commands intact. But it's always worth trying new things I figured, and getting Vim going nicely on Windows seemed like a fun challenge.

Challenge it was. I love the Sublime Text [Package Manager][STPM], which beautifully lists and installs packages from Sublime Text itself. Very cool.  Looking for something similar in Vim I found [Vundle][Vundle], which installs Vim packages directly from Github, locally, or almost anywhere, when they're listed in the `.vimrc` configuration file. Like everything in the open-source community it's all geared up for \*nix systems, so takes [a little bit of tweaking][VundleWin] to get going on Windows.

Even more tweaking was required when I decided to take a great leap forward and put [Vimified][Vimified] on as well, a starting collection of packages for Vim.  Which of course was also [fraught on Windows][VimifiedWin]. But ultimately successful (even if I did seem to spend at least three days getting the [Airline/Powerline][Airline] status bar fonts working).

Half the fun of this little project has been learning how to edit the .vimrc file - and by extension all \*nix config files. More confidence at the command line can only be a good thing, and a good poke around the workings of Linux has made me feel a little more confident (even so far as to getting the
[Powerline][Powerline] fonts working in Bash).


What strikes me as I write this (in Vim - but on the Linux box at home) about a month on is how swiftly the Vim keys have worked themselves into my average workflow. I find it faster to open new lines, append lines, and navigate with J/K than arrows.  Combined with Alt-Tabbing between windows, and Vimium in the browser, I haven't touched the mouse in creating this document - including all the copy-pasting of links. I haven't even left the home keys.

I'm not quite happy to leave Sublime Text yet - but I'm certainly seeing my way there.

[STPM]: https://sublime.wbond.net/
[Gvim]: http://www.vim.org/download.php
[ST3]: http://www.sublimetext.com/3
[ST3Vim]: http://www.sublimetext.com/docs/3/vintage.html
[VundleWin]: https://github.com/gmarik/Vundle.vim/wiki/Vundle-for-Windows
[Vundle]: https://github.com/gmarik/Vundle.vim/wiki/Vundle-for-Windows
[Vimified]: https://github.com/zaiste/vimified
[VimifiedWin]: http://kaszkowiak.eu/windows-vimified/
[Vimium]: https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en
[Airline]: https://github.com/bling/vim-airline
[Powerline]: https://github.com/Lokaltog/powerline
