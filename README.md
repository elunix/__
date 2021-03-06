##### NOTE 
This branch of development can be safely considered as unmaintainable.  

The biggest change which will make it incompatible, is the introduction  
of the tcc compiler as dependency.

The other is that this project will be moved in its permanent place, that is:  

https://github.com/agathoklisx/__

The plan is to continue development from this last commit by preserving also  
git history.

However untill I can find time and especially will, to write a new README,  
the following will continue to be relevant.

### Welcome
This is an unnamed project - a published personal development environment -  
produced by an uncontrollable will to control the way a human being interacts  
with a computer.  
 
(but anyway) If a name should be given, that could reflect the purpose of
this research (which simply is not possible), it could be something like:
 
"easy to use, easy to do, personalized environments based on conscience"

The primary intention is not ever to be a public project with the common  
sense; eventually the code will be extracted to outer repositories in an   
abstracted way that can be used as standalone, as now its closed integrated  
to this system.

Moreover, I can't get the responsibility to expose others to operations that  
are considered dangerous, as I do not have the required knowledge to cover the   
possibilities and the corner cases, and ...  
I do really want to feel free to experiment, as foremost this is intended as  
an educational tool, to cover the absence of a formal education (and this is a  
long trip with many mistakes on the road), especially if it is considered that  
slowly this became quite a complex environment with a huge codebase, which usually  
can not be maintainable in an acceptable way by one person. 

But as this can be seen as a specification for a development environment, it  
is believed that has a value.  

## SYNOPSIS
This application is an implementation of a concept of ideas of an ideal computer  
environment, that is, the user interface, the interaction with the computer but  
also the implementation itself.

The main components are:

..- Common User Interface
..- Self Healing
..- System Administration
..- Self Sufficient
..- Cooperation
..- System Environment
..- Portability
..- Code Implementation
..- Prioritization
..- UTF8
..- Standards
..- Email
..- Network
..- Keyboard and Screen
..- Maintainable

#### Common User Interface
That means:
..- common drawing
..- common bindings
..- (almost) common logic and expected behavior of different applications
..- of an (almost) (replicated) established environment

###### Replicated Established environment
This means one of the three major:
..- Emacs
..- Ed
..- Vi(m)

The implementation should avoid unneeded screen refreshes and generally respect  
the human vision.  

Ideally, the underline machine should have a way to forcibly destroy any attempt  
for distracted pop ups.

#### Self Healing
That means that it should be given the ability to diagnose and repair any kind of  
error at _runtime_, without to **loose data**, and with the minimum side effects  
provided by the error.

#### System Administration
The implementation should offer a way to execute commands using the exec* family of  
functions.
 
It should be also offer a way to modify files with an editor, that replicates the  
most basic functionality and the basic expectations of the above mentioned major  
environments, but at the same time, with a total freedom to experiment beyond 
those expectations.
 
The set of commands should try religiously to mimic their established counterparts,  
but if in doubt or a disagreement with the standards, it may as well choose the  
freedom and do whatever thinks wiser.  

#### Self Sufficient
The system should have the ability to know about itself, so it can keep track  
of changes to its codebase and to install or update itself.
 
This also means that it should minimize to the minimum possible, external  
dependencies and not be obvious lazy.
 
#### Cooperation with the external Environment
That means using existing project libraries from the pool of the Open Source  
Ecosystem.

This also means, packing as much possible inner code and contributing back.

#### System Environment
That simply means that the implementation should be developed in an Open  
Sourced UNIX like system, which provides freedom, conscience, sensibility and  
respect to standards.
 
This also means that the system has installed a C library that conforms as  
much as possibly to POSIX (imho musl is a winner here, but i use glibc (for now),  
a POSIX /bin/sh (dash or mksh), an established Perl Compatible Regexp Machine,  
a C SSL library that provides the SSL established stack (void linux uses libressl)  
and an established C network library (i guess that is libcurl (though it introduced  
a lot of dependencies lately))
 
It also means basic development tools:
..- a C compiler that understands at least C99 (that possibly means gcc)
..- a linker (that possibly means binutils ld)
..- an objdump and related (again from binutils)
..- a make
..- a diff (from diffutils, though libxdiff from git might be enough))
..- a patch that provides unified diffs
..- a groff and a col
..- a tar and compression format handlers
and ... 
..- the zsh shell (updated to the latest version) 
..- and the real editor (an up to date self compiled from the source tree) 
..- a text browser (elinks looks fine)
..- a mailer and related software
..- wpa_supplicant and friends (iw, ip, dhcpcd)

It can also means a way to execute commands as the superuser.

and ...
It means an expected init system that it provides established and expected  
environment (void provides runit (it runs just fine, quietly and peacefully  
doing the job that was designed to be)) ... and which provides mainly freedom.  
So there are guys that believe that systemd is out (imho, completely out to  
be precise) of these requirenments. It happens just to be one of them who think  
that systems with systemd can not be considered UNIX like.
 
It also means a vt100 compatible terminal (i personally use urxvt (this is  
historical) but of course st, the terminal emulator from the guys from suckless).     
I suppose xterm is acceptable just because of his author, who everyone appreciates  
him for his dedication and his huge contributions to the open source ecosystem.

That also means to provide a choise of an X window managment (i believe because  
there are so cheap and many, nothing prevents from a system to provides as many  
it can accept), but at least a fullscreen window manager implementation. This  
system implements its own window manager, but musca is a great choise (in mho)
(though I do not know if it still compiles). And the most customized of all that  
can emulate every window manager and do all this crazy stuff, which at the same  
time are so cheap: fvwm2

#### Portability
That means that the system should work out of the box to the underline system,  
with as few modifications possibly.

This should be also means that is not obligated to obey the above means to  
closed source operating systems.

This also means that it can be carried in a usb stick and should work on any  
such system, which provides easily the chance for an initialization.

#### Code Implementation
That simply means an implementation that treats the machine's processors  
with respect.
 
That could be also means respect to the memory reserved space and it does  
mean it that way, and wishes for an inner realization by the implementors  
about the importance of the memory, but the application between efficiency  
and respect, should respect the efficiency and use it generously and pleasantly  
without penalty.
 
This also means at least two ways to express in code.  
A dynamical and a static system level one with direct access to the memory.  
The static is easy, should be C or should be Rust or both.  
Dynamical means anything else than shell.

But even the static language should provide means to just in time interpreting.

It should also provide a way to declare __Constant Type Variables__.

The code should also try hard not to resort on spawned processes that run on  
the background, with easy excuses.

And last but not least...
This also means that whatever the code style is, it should be coded without  
tabs.

#### Prioritization
The system should offer the minimum abstraction by giving priority to the  
local namespace, then to the standard namespace and last to an external  
namespace.

#### UTF8
The system should know how to deal with the sensible UTF8 implementation.

This simply means that the system is not obligated to deal with ... lets say  
Emojis.

#### Standards
The implementation should try to respect established gained standards, 
but is not obligated to follow nonsense like the web madness.

#### Email
This means one, even the most primitive, way to send, receive and display  
email messages.

#### Network
This means the lowest level network stack for wifi management.

And a way to send a http request.

#### Keyboard and Screen
The application should be totally controlled with the keyboard.

LINES and COLUMNS shouldn't be less than 24 and 78, or unless dictated from the  
screen, but no less than 14.

... and mouseless! (oh it has been said that already)

#### Maintainable
Ideally by the user.

####  This
The following is about _this_ specific implementation.

This prototype was developed under a UNIX like system (Linux with __NO systemd__)  
Void-Linux at void-linux.eu

By using mostly S-Lang, a programming language with a C like syntax and with an  
unparalleled array implementation.

C was also used, mostly as a glue with slang, but with a tendency, as I'm getting  
more comfortable, to give in C some more duties. 

The Tinycc compiler is being used for just in time compilation.

Libre SSL (that ships with Void), pcre, libcurl and sudo, have been used for the  
essentials.
 
The system /bin/sh is a symbolic link to dash.

It continuously compile[ds] with gnu-cc, the linker from the gnu-binutils and  
gnu-make.

This system implements the basic system commands, which mimic their gnu-coreutils  
counterparts with some extensions, but which are common to all these utils.
 
This system implements a way to execute those commands by using a shell application.

This system implements a Vi(m) like user interface with many influences from  
the zsh shell and common terminal multiplexers like gnu-screen. 

The drawing interface is common to all the applications and so is the workflow and  
the logic and the keybindings.

This system implements an X window fullscreen manager with support for floating  
view mode, but with a total control over the unmanaged windows with the keyboard.

This system offers an application to manage itself.
 
This system also offers an extensible Vi(m) like editor (though with two main weak  
points, but with some nice features for the author).

This system tracks self development with inner code but also by using git commands  
(though there is a wish to bind libgit2).

This system tries hard to capture and print with a detailed message, system's  
weakness, and offers generous ways to heal itself, as it can execute dynamically  
slang but also C code. 
 
This system implements a primitive high level network management by using common  
network tools like wpa-supplicant, ip, iw and dhcpcd.
 
It has also a quick way to access the filesystem with an ala file manager way  
(but with few capabilities, because seldom is being used)
  
This system as a bonus offers an interesting way to listen music by using the  
mplayer application.

### Installation

#### Install S-Lang

Note that, because this application follows continuously S-Lang development, 
some features might be not available in stable versions that are provided by  
the distribution versions.

To install S-Lang issue:

```sh
git clone git://git.jedsoft.org/git/slang.git && \
cd slang                                      && \
./configure && make && sudo make install      && \
sudo ldconfig -v
```

This will install S-Lang into /usr/local namespace, so it won't (probably)
clash with existing installations (if there are problems to load the right
libraries, try to adjust and point to them by (at least in Linux) using
LD_LIBRARY_PATH).

#### Install tinycc
It's stronly recommended - but not required for the moment - to built and  
install the tinycc compiler.

To install the tinycc compiler issue:
```sh
git clone http://repo.or.cz/tinycc.git && \
cd tinycc                              && \
./configure --disable-static           && \
make && sudo make install
```

#### This installation
 
##### Requirements
Libraries and headers (usually these are the dev[el] packages):
 
###### Required
..- pam, pcre, libcurl, openssl or libressl (works on void-linux)

###### Important
..- hunspell

###### Optional
..- optional: TagLib

Some common programs (most of them come by default on most distributions)

###### Required
..- sudo, git

###### Important
..- diff, patch, cc, ps, ping, groff, col, file, tar, mount,  
..- umount, findmnt, tar, unzip, xz, bzip2, gzip, ip, iw, wpa_supplicant,  
..- dhcpcd, ping, xauth, xinit, rxvt-unicode

###### Optional
..- mplayer, amixer, setxkbmap, xmodmap, mcookie

To install this distribution issue
(the ROOTDIR variable can be any name): 

```sh
ROOTDIR=$HOME/.__
test -d $ROOTDIR || mkdir $ROOTDIR           && \
cd $ROOTDIR                                  && \
git clone https://github.com/chantzos/__.git && \
cd __                                        && \
slsh ___.sl --verbose
```

Applications and commands will be installed in $ROOTDIR/bin, all of them prefixed   
with two underscores.
Those are actually symbolic links to references, which they load, based also in  
the name of the link, the necessary code.

## THANKS
Special thanks to John E. Davis who wrote S-Lang, to Bruce Dubbs and the folks from 
the LFS* projects who maintain this precious document, to Bram Moolenaar who wrote  
and still writes vim, but and to all (uncountable) contributors around this enormous
open source ecosystem (which this model is the reason that produced this tremendous  
amount of code and this super fast code evolution, unbelievable for that short time  
that happened).

#### About the author
He likes to live in the forest, he likes kids (he has four of them), he participated  
on some strange but (he thinks) interesting relations with various animals, he  
thinks  that only __this__ present exists, he is uneducated, and ... probably (by 
probably misinterpretation) he should be regarded as a prominent member of the DaDa.

...

The followings was used as a vehicle to reduce verbosity and impose compactness.
  
However it still serves as a reference to some kind of primitive help, untill some  
basic __doc* functions will be written. It's pretty verbose and written like  
a late afternoon programming discusion.

## Introduction
The two units, human and the computer, share (at least), that both ask and
get, questions and data.
In this primitive level the implementation uses the screen and the keyboard.

#### Screen

The environment during development of this application is fullscreen
sized terminals; this is since the ratpoison era (at 2004 or 05), and
since then, with ala ratpoison setups (like fwvm) or implementations
(like musca).

As such, till recently there was no established handler for SIGWINCH;
though the simple code that introduced to handle the signal (as simplest
can be written based also on the design), though it seems to handle both
the underline code (buffer and window structures) and the drawing/pointer
position, it can't offer warranty that will do the right thing, since the
floating view is never used, it cannot reveal the code mistakes.

This application offers such an X window management, code derived from
__dminiwm__ :  https://github.com/moetunes/dminiwm
 
Its a tiny (written as a S-Lang module) library, which also has floating
windows support with a total control over the focused window with the
keyboard (for resize and move operations)
 
#### Keyboard
The auto completion system is based on the following zsh line:
 
```bash
    zstyle ':completion:*' menu select=4 list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
```

Its based on a readline implementation (code located at \_\_/Rline/\_\_init\_\_.\_\_),  
which its instance, offers support (autocompletion) for commands, history,  
arguments, filesystem access, ..., but also bindings to function references  
and even direct access to generic application logic.

Libraries are free to know some about their existing environment, and  
in some cases (for speed and efficiency) there is a direct communication  
and access, by disregarding the abstraction level (without abusing the  
interface).  This freedom comes from the fact, either (usually) because  
at some point before, a break point (a try statement in this case) has  
already been set, or because the caller can handle all the conditions of the  
called function behavior, or simply because S-Lang really helps on a stable  
interface, because of the function qualifiers, that permit to a function  
to develop logic without changing signature (like the argument number).

In any case the inner code, which anyway has some dependencies to other  
objects, can do in cases some direct calls, which are desired, especially  
from code, like readline, that is good to know quickly, what will do with  
the input. Of course this can be easily get out of control, but as long there  
is a sync with the outer interface (good named symbols (functions and variables)  
can help a bit), there is no harm enough to avoid them.

## Usage

```sh
# starts the shell application
 
$ROOTDIR/bin/__shell
# quit with q (same in every application)

# list directory
$ROOTDIR/bin/__ls
```

All the commands have a --help switch.

All the applications, on the command line mode, can run those commands.  
In the shell application are all easily available through the tab key   
(results can be narrowed with some input), because these are the defaults  
for this application.

On all the others applications, the same behavior is achieved by using "!"  
as the first char on the command line, while the tab key by default, auto  
completes commands that are __specific__ to the application.

Below is a construction that can be used as a man pager.
```sh 
# First build a database for fast operations on the generated
# array of man pages (which it should run this periodically on
# updates or new installations)

$ROOTDIR/bin/__man --buildcache
  
# display the man page of the man itself and then quit the shell

$ROOTDIR/bin/__shell --command=man::man --command=q

# it can also search for a page (like fork) and display it:
 
$ROOTDIR/bin/__shell --command=man::--search=fork --command=q

# The --command=com::arg::arg1... command line switch, can run
# any valid command, just a little bit before entering the main
# loop.
```

For the sake of (at early steps) development, a couple of common  
applications were introduced, like a media player that uses the  
mplayer program (which communicates with it with a fifo) to play media  
files.

```sh
# if mplayer is installed, this application can be invoked:

$ROOTDIR/bin/__media

# The command "audioplay" will play audio files or if an argument
# is a directory, will play all the audio files listed to that
# directory (the order is random, unless the --no-random switch
# is given).
# It can also show and manipulate the tags on audio files, by using
# the S-Lang bindings (located at: $ROOTDIR/__/C/taglib-module.c)
# to the taglib library:

  http://developer.kde.org/~wheeler/taglib.html

# The application can also display lyrics, if the current song
# match a file name minus the extension in the lyrics directory,
# located at: $ROOTDIR/usr/data/media/lyrics

# Note that, the installation hierarchy is an image of the source
# directory.
# The source namespace and execution namespace have interchangeable
# relation to each other. So this application can be carried
# and works the same (with the data synchronized) to other
# machines.

# There is an application dedicated to administrate the
# distribution. The source of this application is located
# at: $ROOTDIR/__/app/__ and can be invoked as:

$ROOTDIR/bin/____

# The __ application, it can re-install the distribution,
# build a class, bytecompile a library, compile a module,
# sync the distribution on or by an external media (like
# a usb stick)

# But this system can start a set of applications, like:

$ROOTDIR/bin/__shell --app=__ --app=git

# This will also starts a simple git application, created and
# used mostly to administrate this distribution, and which is
% a wrapper around git commands (hopefully i will find time 
# this year to bind libgit2). This by default starts git on the
# source directory off the distribution itself.

# You can cycle through applications using F2 or F1 for
# a next/prev motion.

# On an empty command line, keys can be defined to trigger
# a call to function references. Though the interface is
# not complete, practice stabilized some actions:
 
# The "~" triggers auto completion for personal commands that
# are located under: $ROOTDIR/__/local/com
# those are accessible on __all__ the applications and usually are
# common used user scripts (hence the ~) 

# The "__" and "@", which for now seems to overlap are usually
# function calls.

# The arrow keys on the command line

# up: triggers history completion - doesn't need to be the first
# char on the command line, which in that case, uses the typed
# text as a pattern to look up to the history entries

# right/left: can scroll the output text to both directions (this
# helps with lines that are longer than screen columns, as
# lines are never wrapped), without the need to edit the output.

# down: edits the output as a normal buffer, by entering first
# in Normal Mode.

# With the page-[up|down] keys can scroll the output 2 lines
# up|down from the command line.

...
```

But, briefly the ideal concept in an ala list sentence:  
  in a unix like operating system,  
  self built-able and controlled,  
  applications with a personalized and uniform interface,  
  with a drawing that doesn't stress the eyes much,  
  and gets as much screen space it deserves,  
  without distracted pop ups (unless its called by us),  
  total controlled with the keyboard,  
  with share bindings,  
  same workflow,  
  and similar interface under X or a virtual console,  
  with an implementation,  
  which is written in a familiar pleasant language,  
    - compact but understandable (like S-Lang)  
  with few dependencies (mostly in libraries),  
  that can be carried (static build),  
  that can load instantly,  
  even at very early boot process as process id 1,  
  fast,  
  with an efficient memory usage,  
  with organized code,  
  easy to understand,  
  compact (shareable code),  
  with enough information when the bug occurs,  
  without bringing down the system,  
  that can be healed at runtime (without restarting)  
  and ...  
  freedom (through knowledge and responsibility to get out of edges)  
  with an evaluation console executing strings  

in a summary the absolute control over every bit (that is, ideally).
 
This system has implemented much of the specification, with notable exceptions  
that it can not be yet the init executable, it cannot be built as static,  
and its not that easy to fix runtime bugs (though possible if there is code  
knowledge, by using eval).

Particularly this application implements a vi(m) like user interface, though the   
interaction is based on tab  completions much like the zsh shell does it.  
 
In fact, the application is an editable shell or an editor with a shell logic,  
because the machine that creates/draws windows and holds the structures, is the  
same that does editing.
As another fact, the underline code is exactly the same for all applications  
(usually only the relative readline code unit is changing and some times the pager  
bindings). The other difference is important (the role that every application   
carries at the invocation) and here is why:

At the invocation an application checks the environment and if it's not derived  
from another instance then becomes the process leader.  
Any application can play that role.  
Applications by default, can have independent images (windows) of themselves (like  
tabs), unless the application forbids it (like the simple network manager which is  
activated with the --devel command line switch and is called as __netm, but which   
makes sense, as there can not be more than one).

The F5 key can display a menu for window related actions.

This master process can start, manage and close unlimited new applications, unless  
again is forbidden (like a very specialized task that needs to reduce the risks).
 
The first four Fn keys are dedicated to those tasks, like the F1 for instance, which   
is binded to bring in the foreground the previously focused application, or if there  
isn't one, to start a default based on the settings.

Applications can also have children of other applications but which they are tied  
only with their callers; those can be detached (using CTRL-j) and later can be  
re-attached, but only through the caller application.

### The drawing interface

The first (top) line is reserved to print generic information and is refreshed at a  
every command invocation or (usually) when changing mode, or when changing focus.

The window can be split in frames and every frame is associated with a buffer, which  
reserves the last line of the frame to print buffer related information. This last  
line can be hided, as it happens with applications other than ved, however when in  
insert mode the buffer status line should be visible.

The last line of the window is reserved for displaying messages which they should be  
disappear at the first keypress action.

The second line from the bottom, is reserved for the command line, but if the  
length from the entered text cannot fit, it grows to the top by borrowing upper  
lines.

#### Design and Interface

This system, it can't also built and maintain yet, that unix like environment, but  
it comes with the most basic commands to administrate a system.

They usually have the same name (prefixed with two underscores), with their counterparts   
and share many established behavior and command line switches.  
This has some unexpected gifts like argument completion.
 
The argument completion is triggered when the pointer is at the second token (after  
the command name) and when "-" is typed and its either the first or second char of  
the token (that means a space before or another "-" respectively).
 
As an example if you issue:

```bash
$ROOTDIR/bin/__shell --command=\!ls
# i had to do the escaping in my zsh shell
```
this will execute the system ls, not our ls which is located at
$ROOTDIR/\_\_/com/ls at the source directory.

But since our cp (for instance) share switches with the system cp, then the  
autocompletion will work by mistaken (hopefully the user will not be mistaken).

The system calls are available when "!" is the first char of the command line in  
the __shell application. On the other applications it needs to be doubled.  
Why? Because on all the other applications except the shell, "!ls" will call our  
ls, as all the system commands are available on all applications and so is ved (the   
editor).

The ved editor is a vi(m) tiny clone, with which most of this codebase was written.  
It's really the first prototype (written in a time with no internet for long,   
faced with challenges that needed design decisions (of which some though workable  
are not wise (some are explained in the source code))), which it rather happened to  
work very early enough good.  
But because of this, the machine is rather fragile and development is considering  
as careful exercise. But, though there are obvious weakness, like the undo operation  
or when editing lines longer than the screen columns, very seldom I lost work.  
But when and if it happens the inevitable, then usually the error message is enough   
descriptive, to guide you to fix the condition.

Actually a self developed and maintainable system, was (even if it was hidden   
somehow, at least at the beginning), one of the rationales that lead to this code.  
This might has to do with the complexity of the modern systems.

For quite too many, a unix environment with a shell and an editor are  all they  
need (to be fully productive). They appreciate the peaceful, expected, sensible,   
tested, standardized, built-ed through experience, conscience and logic system,   
that ends to be very pleasant. At the worst of the cases is always a settler and  
should be easily accessible (as a gained standard) to any of the operating systems   
today. A C library, a compiler, the development tools, a posix shell, some sanity ...

The user has to feel that has the control, its our human being desire.

But Ved is intended to be the underlying system and it is.  
However, the system that works with a text buffer, is based on filetypes,  
which contribute a lot of code, and that code can change significantly  
the behavior (usually the Normal Mode (the pager in other words, which  
in all the other applications other than ved, quits with q, like a pager  
does)). 
 
In Normal mode all the function references associated with keypresses,  
can execute three function calls.  

From the returned value of the first function call (which by default is a  
stub function that returns zero), depends, if control will return to  
the caller (when -1), or continue by executing the default associated  
action with the key (when 0), or execute the third function (which by  
default does nothing).  

As an example the right key in Normal Mode, sets the pointer one cell  
to the right (if there is enough text). However, the media application  
sets in its playlist buffer structure a callback function, that when  
the right arrow key is pressed, it draws a box with information about   
what's currently playing. Then it returns -1, which is interpreted as  
return immediately and do not try to call the other functions. If the  
the returned value was zero, the default action for right key (move one  
cell to right) would be executed.  

On any other value, the function calls the last function, which usually  
is being used to clean up states or for refinement after the default  
action. For instance, again in media and while navigating in the playlist  
frame (reached with "l"), the down arrow key, first goes down to the  
next line (default action), and then in the last call, checks if the  
current filename/song, has embedded tags and if it does, it display  
them. The returned value of the third function is ignored.  

The editor didn't ever have the intention to be a vim clone, but rather  
use the admitable geniously captured and implemented (in vim perfectly)  
model of modes - besides the intuitive interface which is based on  
mnemonic keys that are connected with actions and keywords, like  
[cd][i][Ww] for [cd]\(hange|delete\) [[i]nner] [Ww]ord.  

In this application this model (of modes), has been already extended.  

The truth is however, that this editor is not and is never going to  
handle satisfactory external data (at least not any kind of external  
data), but rather to handle later the product that creates itself and  
to this is very good now. That means it handles the usual workflow from   
his author and when the author needs something, then it gives the tools  
to do so.

Like in this case, in this warm February day, ved code introduces digraphs,  
accessible (through a usual menu) with CTRL-k in insert mode. Here is a  
note:  ♪   
now: this is a first workable draft with more than enough digraphs to  
use. But this can evolve later to handle other conditions and perhaps  
to end up as a library, which is very natural path in development.   
If nothing change in this regard, this code will still work forever.   

But, this is a selfish!!! Exactly. This is all about. The interaction  
with the computer is unique and the code should be prioritize that,  
and give the user happiness.  
 
But, can such applications share code with other unique/tailored  
made applications? Absolutely!!! That is all about.  

For instance: This application (which it should be called this, with  
so many this), is trying (and when it doesn't succeed its a bug), to  
load all the requested libraries/applications/commands based on priority  
rules.  For now, the namespaces have this priority:  
```C
$ROOTDIR/local
$ROOTDIR/std
$ROOTDIR/usr
```
so without changing the standard way to do things, someone can modify  
the code to bring the desired behavior without touching mainline code at  
all. Of course this needs basic programming but basic programming with  
intensive care on the concepts, as everybody knows, can be fast and   
should be fast (if myths could be demystified quickly)  

But, this is not the case for C.

### C
I do not have any control in my C, and I do not have any kind of futile thoughts  
to ever have, in its entirely. I also know that it's a long way to learn proper  
and most importantly safe C.  
Though the language is small, because of its nature (the close relationship with  
the machine), it needs extensive studies to many levels and even then, it needs  
to be in an endless care about ... almost every little detail, and yet even then,  
it needs support from debugging tools, but even then, noone can be ever sure.

So at least, code productivity and development cycle, is probably the worst  
against (almost) any language.

However, is the most powerful tool and it will ever be. And yes, like everybody  
else, I realized this warm feeling you get when you using it and that time  
you just don't want anything else.
 
But why someone that starts programming today, will going to learn C that needs  
a lifetime to master?  
When today (at the spring of 2018), already there is one (safe) language (Rust), 
that:
  - is by its definition safe
  - with a much less learning curve 
  - with (almost) the same performance
  - with a decent fast development process
  - and most importantly is expressional
  
We are humans and humans have a need for expressionism.  
Not all programmers have to think about the implementation details, they just  
need to express thoughts and logic and construct algorithms, that is what   
they make them happy and productive.  
 
But C is flexible and it can even be quite expressive:  
https://github.com/stevedonovan/llib

However, there are so many interfaces, that hide implementation details,  
so it can be safe, like (say) string operations.

But there is nothing standardized.  
If standards (like say the respectful POSIX), represents conscience (like the  
general consensus about C strings), then something should be done or Rust, it  
will take the world, as everybody realized by now. Not even a chance for C.
 
### Menus
Many operations depend on small menus, that work with uniformity, as far it  
concerns:
  - the drawing style  
  - the selection style (the space bar (for instance) (and very natural)  
    accepts a match on all those menus, the arrow keys can be used to  
    navigate to all the directions of the printed matches, the escape  
    (in this case) aborts, the carriage return accepts and executes  
    the command line)  
  - but also the underlying code which is trying to be consistent  

### Editor Usage
Now this is easy, because most of ved capabilities are vim compatible.

And this is not because of the compatibility but because they make sense and  
being used - except the hjkl keys, which are implemented but never being used,  
as usually is much easier for me to use the arrow keys ... but these keys are  
historical so there are present and this is the only exception to the "implement  
what you use" essential rule.

So it's sorter to describe the differences.

First, the search mechanism is different.
It doesn't jump to the first found match.  Instead  a message, with the line  
number and the line itself, is displayed in the message line (the last one on  
the screen). Enter accepts the match and then jump to that line. Ctrl-p|n can  
be used to search forward or backwards, depending from the usage. For instance:
When # pressed on a word, Ctrl-p will search downwards.

substitution is a command

Normal mode: 
Ctrl-a|x acts like vim and in|decrements the number, but if a number is typed
before someone can use then  * or / for multiplication or division.
(also it works for letters when it make sense, so a becomes b with Ctrl-a)

~ on a char acts like vim but it can also look in the code for a matching  
pair, so : becomes ; and vice versa

space is a "a [space] [escape]" sequence.

W on a word, displays a menu for operations on current word.

The expression register gets its input from the eval function.

Ctrl-k, displays only the registered on the code digraphs.

$ goes to end of the line, even if its beyond screen columns, and  
- goes to the last cell (but generally do not use this editor to edit
text longer than screen columns)
 
F[1-8] are binded to specific to this application functions
F[12] pastes X-selections
F[10] changes the input language
(those are generic bindings,they work in normal and insert mode)

Backspace (and if it's allowed, e.g., when editing source code) removes any  
trailing whitespace, even if it's in another column (doesn't change columns)

escape displays a menu for operations on current line.

Visual mode:
On linewise mode almost the same operations with above can be done for the  
selected lines.

Command mode:
  :e without arguments, ask for confirmation to reload current buffer, while
  :e! does it unconditionally
 
		:enew fname 
opens the given filename in a new window.

(windows (like tabs in vim) have their own associated buffers and don't interfere  
with other windows buffers, it's like an independent instance, but without the
need to fork another process)

:w (without arguments acts like vim, but additionally, it can get another buffer  
name to write  the contents, using the --bufname= switch (buffer auto completion  
is possible)
 
Insert mode:

Ctrl-n searches for a word only in the current buffer

Ctrl-x allows only for line and filename completions
...
and do not trust un|redo, rarely is working, the design doesn't allow
reliable operations and since my workflow doesn't depend on this feature,  
it's not a priority to fix it

other than that is a v

### Inner Code

Most of the libraries are written with such (inner) syntax, that needs  
pre-parsing and compiling to S-Lang. This is being used to create,  
either new or static instances, of either mini or more complex function  
environments (by adding a lot of boilerplate code). This is to  
create an abstraction level, a structure and an associated static  
namespace (with a group of functions and variables part of this  
same object), and an inaccessible private namespace with the  
implementation details. instantiation is done with the first loading.  

Those structures allows for code consistency and organization.  
But the main reason is that every method of those structures, is  
actually running through an interpreted function, which catches  
any error and calls an error handler.

The default error handler it prints a detailed error and then gives  
control to the main application loop.

It also allows profiling, by just changing the interpreted  
function. Any application accepts a "--profile" command line  
switch, which turns on profiling. It can also be enabled at  
runtime by issuing in the evaluation console (which it can  
be started by calling the __eval function):

```C
_-> enable.profile (;set);
```

For now, to see the results, is again possible through the eval  
console. By issuing Profile. (and hit tab) it will present a  
couple of options to select and see the results in the scratch  
buffer - the scratch buffer can be opened with the __scratch  
function, while the __messages function is opening the stderr  
buffer.

This syntax is not compatible with S-Lang. Files with an "__"  
extension are such objects that needs parsing. Most of these  
files are precompiled and then bytecompiled (as all of the  
file units ought to do), during initial installation or later  
on runtime.  
But some of those objects are actually compiled at the runtime.  
Some of them can contain an #if[not] directive, where depending  
of a condition, can load a subclass or specific version[s], of  
the __same__ (by name but also with the signature) method[s].  

#### Functional Code Interface
Normally the following is not valid (because "if" is a statement):
```C 
  variable cond = 1;
  variable v = if (cond) 1; else 2;
```
 
But by using the function interface, we can get the desired result:
```C
  variable v = frun (cond, `(arg) if (arg) 1; else 0;`);
```
The string inside the backquote characters is evaluated at runtime.  
It's like an unnamed function syntax without the braces:

```C
 (arg)
{
  if (arg)
    return 1;
  else
    return 2;
}
```
This function can be stored in a variable and can be used it as a normal  
function reference. The code inside the body of those strings, can be  
regular S-Lang code.

Functions can have environment, delimited by the "envbeg" and "envend"  
keywords.  
This fact alone, can make the things interesting, because that way such  
function can really control the environment. But, it can also create a  
closure:
```C 
variable counter = function (`envbeg variable _i = 0; envend _i++; _i;`);
counter.call (); -> 1
counter.call (); -> 2
``` 
One such function can be the whole program and could be (almost) perfect,  
if it wasn't for the backquotes. Such multiline strings allows to write  
full compatible S-Lang code without further parsing, but the backquotes  
needs to be doubled, everytime there is a need; like when using a nested  
function, or simply when real multiline strings are needed in the code.  
Such nested levels can end up, quickly, in unreadable code.  

### Invocation
Every application can have its own command line switches, but there are  
share also some:  
  --profile    turn on profiler  
  --devel      turn on development features  
  --debug      turn on debuging  
  --basedir=   sets the base directory of the application  
  --datadir=   sets the data directory of the application  
  --tmpdir=    sets the temp directory of the application  
  --histfile=  sets the  history file  of the application  
  --command=   executes a command prior to main loop  
  --execute=   executes a string  prior to main loop  
  --execute-from-file=  executes a file prior to main loop  

       
The development features are functions that either are new or  
hasn't been developed enough, but which should be functional,  
like the __netm and __fm functions.

The first one offers the minimum code, for wifi managment  
(uses wpa-supplicant, dhcpcd, iw, ip). It works for me.

fm (for file manager) its a couple of hours work, and is being  
used mainly to collect (tag) files (with space) for removal from  
a messy directory (like mutt, execute the tagged files with ";")  

But it can also display pdfs (using apvlv), images (using feh),  
edit files (using ved) and extract archives.  
It can even play video and music and it understands for navigation  
~ or // (double slash, as / searchs the buffer), or right-left arrows  
(i think the navigation within the filesystem is pretty fast), but  
the principal applies. If something is not being used, it can not  
reveal code !correctness.  

### X Window Manager

As it has been written, this application offers an X Window management.  
It can be started from a virtual console on any application,  with the   
command :Xstart  
or through a Linux console with startx.  
But, in the latter case the following line should be placed in ~/.xinitrc

```bash
# replace the ROOTDIR to the actual path
exec $ROOTDIR/bin/__xstart
# and the following change to /usr/bin/startx

enable_xauth=0

# i cannot find a way (i think there is not) to disable this with the invocation,  
as we do the xauth stuff in the code ourselves.  
```

### As an Interpreter
This code can execute (almost from everywhere :-) shell code and slang  
code. But, at the time of writing is ready to execute dynamically C code.  
This because of the tinycc C compiler, see:  
	 http://bellard.org/tcc/
and upstream's repository at   
  http://repo.or.cz/tinycc.git

I will try to integrate soon the code that is already written.

### As a spelling tool using hunspell

Simply in Visual linewise mode press h (h for hunspell)  
or by using :__spell  
or while the pointer in on this word that nees spelling, press W (W for word)  
for a menu which, except this specific option, it offers and a couple of other  
operations, like to send something to XA_CLIPBOARD, using the xsel without (i think)  
a single change,

http://www.vergenet.net/~conrad/software/xsel/

just enough to pack it a slang module and just to make it work for the  
XA_CLIPBOARD, which it seems that is the only X selection mechanism that the   
coders of chrome browser seems to be aware…

### Many other operations ...
... that left to be documented and documentation is much harder   
than the code itself. Its hard, hard, hard. (I would pay for it (<:),    
who said that? A guy that doesn't own one! penny to buy a meat-ball¹.  
how sad, sad, sad, to be mad, mad, mad..., but we'r gonna have those  
balls (and they don't have to be meat), no need for pennies) and we'll    
be glad, glad, glad, dad a dad a dad a...  

### Principals.

The caller always knows better.

The user has the responsibility.

Be brave (stolen from the git logs of the edbrowse² repository - a brave  
man indeed - when he wrote blindly (i think they call it css :) something  
that usually is written in js if IRC anyway), that thing in C).  
He is one of our today's super heroes and I bow my hat kindly.
...

### For S-Lang programmers
Any of the classes can be compiled from the \_\_\_\_ application with the   
"--dont-remove" switch, which in that case a file with the same name with the  
class, plus the ".sl" extension, is created to the same directory with the  
class.  They are self explainable, except the variable at the very top.  
But generally very little things need to be done for adoption.  

Most of the modules were written with little or no knowledge at all in C.  
But most, with one or two exceptions, are functional, even if this function is  
just one. They have been tested. (But didn't check with valgrind them all,  
though).

The main scripts leave a copy of them in the tmp/ directory which is created   
during installation. They are rather big but are self containable. Possibly   
with no expectations, except realpath(3), which is an intrinsic function that  
is declared at the inner interpreter or in \_\_-module.c

### Qualifiers
This is reserved for a small introduction to slang qualifiers.

### For C programmers
Likewise

### Status
It is in an endless development. As there is no responsibility to satisfy  
some external needs, there is a freedom to experiment on the implementation.  

However, there is tendency for dynamical expressionism, but controllable.

That means:
 
Yes to private environments and static abstraction.
 
No mix-ins but (and) direct communication.

No to dependencies, yes to expected functions.

Yes to feel free inside my private environment, respect to the  
outer environment and to the expectations from us.

No to of: how to write this code, but how to declare and express my logic.

### Style
```C
/* 
	* indentation: two spaces
 * 
 *  Function definitions 
 *  define name (args)
 *  {
 *    ...
 *  }

 *  function calls: always a space after the function name
 *     func (...)
 *  
 *  clear separation of tokens except array indexing
 *     ar[1:i1];
 *
 *  an empty line between blocks and in most other cases,
 *  except when declaring variables
 *
 *  declaring multiply variables:
 *  variable
	*				vname= ...,
 *    oname= ...; 

 *  structs:
 *  struct
 *    {
 *    m,
 *    ...
 *    }

 *  unnecessary braces to conditional blocks is _strictly_ forbidden
 *  if (expr)
 *    if (other_expr)
 *      statement;
 *    else
 *      statement;
 *  else
 *    statement;

 *  but if necessary:
 *  if (expr)
 *    {
 *    statement;
 *    ...
 *    }
 *  else
 *    ...
 *    
 *  ternary expression indentation
 *		(expr)
 *    ? (expr)
 *      ? (expr)
 *        ? do this
 *        : do that
 *      : use the second expression
 *    : otherwise use the first conditional branch

 *  avoid "else if" as it blinds the interpretion, but the best found is:
 *  if (cond)
 *    ...
 *  else
 *    if (cond)
 *      ...
 *    else
 *      ...

 *  same names for common variables; by doing that you can 
 *  copy code blocks and understand the semantics
 *  some of them:
 *  st = stat_file)
 *  ar []
 *  a  = Assoc  % this came late, many arrays are named a
 *  s  = struct
 *  l  = list
 *  fnane, dir, path 
 *  i or ii for nested loops
 *  or idx when the index is the important to notice

 *  (generally) common names and code, and change only when
 *  there is a subtly difference that makes it important to notice,
 *  then use the appropriate naming, but not far from the usual

 *  guilty: i dont type 
	* 			return val;
 *  when its the last statement, but simply
 *    val;
 *  unless val comes as a result from deep function calls

 *  idiom to avoid nested conditional blocks
 *  loop (1) {
 *  if (condition)
 *    break;
 * 
 *  if (other_condition)
 *    ...
 *  }

 *  this (almost C) idiom:
 *  if (NULL == (var = expr, var)
 *    ...
	
 *  No to:
 *  		if (expession == NULL)
 *  but to:
 *  		if (NULL == expression)

 *  I dont pollute the code with comments (for distraction reasons),   
 *  unless is a historical story and a general comment about the code,  
 *  and maybe have some fun.

 *  "Try to read the code and understand the programmer intentions, is  
 *  crusial for the minds and finally really helps in development"
 
 * Generally its the semantics that matters like in the brace thing.  
 * (you dont have to care if the compiler will be confused with code without  
 * braces; because if you do then the mind lost its crusial mlsecond chance  
 * while she is walking to the thought path, like a dog that follows a smell.  
 * If you loose that tic then you have to go back.
 
  The DO is not repeatable. After the expression is only accessible through  
  emulation. But do not worry.
  As this might be a new chance to produce new DO's, as the consience that  
  is created when you make the travel to go back in time in a time that worthed  
  the time, creates entirely new chains like spider strings, that by default  
  will produce those new DO's that maybe you will be ready to live them on  
  time.

  That's why even our inner stupidity can be used artistically to create new  
  complex environments.  
		As all of our "φάσμα" (the greek word for wide-ty) (if such word exists) can  
  be used the same. We've been programmed to be like this way because this is   
  the way that is producing something valuable. If we find what is this energy?
  
  Personally I believe is the energy that you're getting it when you are excited,  
  or very close to that.  So if this is true then we've to find ways to produce  
  more of this kind of energy, without resorting  to our stupidity or to our    
  uncontrollable will, to find excuses to fight each other.  Then the life becomes  
  art, like it never imagined that it will ever happened. But it happened.
  
  This is the DaDa.
 
 * And last one thing about this brace story.

 * Kudos to John Davis for his parser.  So much code, sometimes quite complex  
 * conditional branches without even a single mistake i can remember.  
 * And he is a _physician_ not a programmer.

 * In wikipedia article about array implementations slang has a good share.
 * And deserves more and it will take it, if you think that established  
 * and respectful languages like Lua, hasn't been yet, after so many years,  
 * settled for a stable table interface without confusion.

 * I believe that slang's array manipulation is unparrarel and it would be  
 * wise for others to copy the functionality.
 
 * This is personal, but i couldn't live in other languages without slang arrays,

 * so, and this is the reason, I wrote all this, because John just (yesterday
 * night for us here) has released slang-2.3.2. I even wrote, with a terrible  
 * mistake however, to the mailing list, after years (eight i think) of absense
 * on mailing list discussions.
 
 *  ### programming style
 *  use arrays (where* and friends),
 *  use qualifiers,
 *  use ifnot,
 *  use _for,
 *  use forever
 *  live forever (whoops! sorry)
 * 
 *  I can't think recursively (this is weakness) so I avoid functions 
 *  that call themselves

 *  on function development:
 *  catch as soon as possible false conditions one by one, and if 
 *  it's possible with a _single_ conditional branch
 
 *  break the logic to single pieces

 *  avoid function with more than one returned value
 *  avoid switch except when it feels natural
 ...

```
 
## EPILOGUE
As it has been said, still it can't built and maintain, that unix  
like environment. But this knowledge exists, developed by the   
fellows at linuxfromscratch.org and it feels like as a duty (though  
a pleasant one) to re-initialize the code, but (right now):  

As I feel that I did the best I could, though I could do more and  
better, it looks that my mission is completed (at this point of time;  
anything that it will happen (even a single line of code) (declared  
at 30 of December at 2017) it would be considered as a gift.  

As for the quality of the code, this is the result of a self educated  
(at 40's) human being with zero educational background, with four kids,  
animals, ... while he was building a home and pressed to obey the existing  
practices that he doesn't finds too much logic on them. 

This programming project, as and because, it includes so many sub projects   
which are more than enough to keep someone busy (for as long he can (or has the  
desire) to code), its natural to say that this is the project of my life's ... and  
for my lifetime.  
And for this I'm grateful and I feel lucky.  

# WARNINGS
This system cannot be used for complex communications or specialized tasks,  
as hasn't been checked on (not so) corner cases. It is mainly serves  
(besides the author) as a prototype.  

The editor is ignoring tabs by decision and this wont change³. I'm thinking  
seriously to use tab in Normal|Insert mode for completions. Anyway currently  
there is no way to insert tab and probably this wont change.   

The editor hardcodes two languages, Hellenic and English (that change with F10).  
Its easy to initialize other keymaps, see: \_\_/Input/\_\_init\_\_.\_\_  
and to init_keymap_el(). But the input doesn't depend on system mechanism  
to change language mappings, see el_getch(), which map's the english  
letters and combinations of them to corespond to hellenic letters.  That way  
its possible to have support on other languages in any environment, without  
dependency to the underlying system.

And ... lack of fundamental knowledge, especially for low level stuff,  
like fork's and select() (which still is not being used even once, chicken :-)  
(what's wrong with chickens?).

p.s., ideal, nobody really wants to write any code to handle an exchangeable  
bad file format that doesn't obey conformation with established standards,  
but the last one can do is to notify the sender/creator to get attention,  
as every body deserves that treatment and so do i.  

## THANKS
Special thanks to John E. Davis who wrote S-Lang, but and to all (uncountable)  
contributors around this enormous open source ecosystem (which this model  
is the reason that produced this tremendous amount of code and this super  
fast code evolution, unbelievable for that short time that happened).

### FOOTNOTES
¹. Josh White - one meat ball  

². git://github.com/CMB/edbrowse.git  

³. https://github.com/hellerve/e.git

(today at 02 of Feb, i came across this project (an ala vim editor but inspired  
by kilo⁵, so it has a similar warning at the end of its README.)

The author is super and he participates in Carp⁴, a modern Lisp dialect that is 
really amazing.

⁴. https://github.com/carp-lang/Carp.git (it compiles in C and is written  
in Haskell but wants to be Rust :-) (no garbage collector, just references  
and borrowing (but not boring)), pretty amazing!!)  

⁵. (https://github.com/antirez/kilo)
He seems to inspired many. I've developed its   
```C
		int editorReadKey(int fd)
```
to cover more cases, but its a very naive code, but I should publish it anyway.  
