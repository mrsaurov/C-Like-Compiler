# Compiler for *C*-like language

**Source Language**: *C*-like

**Destination Language**: MIPS Assembly

  

# Features

* Expression evaluation

* If, If-Else conditional statements

*  `while`, `for`, `do-while` loops

*  `print` function

* Error checking such as type mismatch, undeclared variable.

This compiler still doesn't support mutiltple if-else, loops, floating point operations. ``print`` can be only used to print `int` type data.
  

# Syntax Example

```c
int i = 0;
print i;
int b = 6;

for (i = 0; i < 12; i++;)
{
	b++;
}
print b;
```

  

# Getting Started

  

## Prerequisites

* A Unix-like operating system: macOS, Linux, BSD. Windows users can use WSL or manually install necessary softwares.

*  `bison`, `flex`, `gcc` should be installed

* MIPS simultar- [QtSpim](http://spimsimulator.sourceforge.net/) (GUI) or `spim` (CLI). 

*  **Optional**: `git` should be installed if you want to clone this repository. Otherwise download and extract zip file.

*  **Optional**: `make` for automating the build and run process.

  

## Installation Guide

  

* Clone this repository and change directory

	```bash
	git clone
	cd ./ClikeCompiler
	```

* Generate parser (``parser.tab.c``) and header file (``parser.tab.h``)

	```bash
	bison -d parser.y
	```

* Generate lexical anaylzer ``lex.yy.c``
	```bash
	flex lexer.l
	```

* Build the compiler

	```bash
	gcc -o compiler.out parser.tab.c lex.yy.c
	```

## Using the compiler

  

* Write your source code in a text file. For example- ``code.txt``

* Get the MIPS assembly code using

	```bash
	compiler.out <code.txt> output.txt
	```

*  ``output.txt`` contains Stack Machine Instructions

*  ``assembly.s`` is the corresponding MIPS assembly instruction of ``code.txt``

  

## Automate this process

To automate this build and run process you can use the supplied ``Makefile`` . Make changes as necessary.

  

Build and run using-

```bash
make main
```

  

## Running the MIPS assembly code

### Via `spim` comand line tool (Recommended)
* Install `spim` command line tool
	* **macOS**: Install `spim` using **Homebrew** `brew install spim`.
	* **Ubuntu\Debian**: ``sudo apt-get upgrade && sudo apt-get install spim``
	* **Windows**: Use **Windows Sub-System for Linux (WSL)** or [QtSpim](http://spimsimulator.sourceforge.net/).
* 	Change your working directory to the folder containing `assembly.s` and use the following commands to run-
	```bash
	spim
	read "assembly.s"
	run
	```
### Via `QtSpim` GUI Application
* Download QtSpim for your OS from this link - [https://sourceforge.net/projects/spimsimulator/files/](https://sourceforge.net/projects/spimsimulator/files/)
* Open QtSpim and Go to *File  > Load File* and select the `assembly.s` file.
* Run the file using *Simulator > Run*.
  
**Thanks!!**