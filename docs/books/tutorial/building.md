
Building
=========

#### Building aroop

Aroop compiles the shotodol. So aroop needs to be compiled first. Please refer to aroop project page for compilation procedure.

#### Configure for build

To build shotodol, [Makefiles](https://www.gnu.org/software/make/) are needed. These makefiles are generated from [configure.lua](configure.lua). So to generate the makefiles [lua](http://www.lua.org/) is needed. Configuring will be easy if luafilesystems module is installed. 

After lua is installed it is needed to execute the configure.lua script, like the following,

```
 a/shotodol$ lua configure.lua
```

And it will prompt like the following,

```
Project path /a/shotodol > 
Aroop path /a/aroop > 
enable debug (ggdb3) ?(y/n) > y
```

In the above promts the *project-path* is the current directory. And the aroop-path is the aroop source directory. And `y` is the input from the user. It says to enable debug.

After configuration there will be a _Makefile_ in the current directory. All the build instructions will be there. The variables for build will be in the build/.config.mk file.

Building shotodol
=================

Now, after the _Makefile_ is generated in the shotodol directory things are ready to [_build_](http://en.wikipedia.org/wiki/Software_build). It is only one step compilation. The `make` command is needed to be executed like the following,

```
 a/shotodol$ make
 a/shotodol$ ls
	shotodol.bin
```

The above command will create shotodol.bin as an executable binary. It reads the _autoload/shotodol.ske_ (_shake_ script file) for loading required plugins and execute other command blocks. 

Running
========

It(shotodol.bin) is now ready for execution.

```
 a/shotodol$ ./shotodol.bin
```
