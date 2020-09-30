https://web.archive.org/web/20160412174753/http://www.jamesmolloy.co.uk/tutorial_html/index.html
https://web.archive.org/web/20160330040433/http://www.osdever.net/bkerndev/index.php

# 🕳️ voidos

Welcome to the void - the operating system for nothing.

## ✔️ Supported Platforms

- Linux

## 🚀 Prerequisites

The following applications need to be installed for development:

- GCC
- Binutils
- Make
- NASM
- QEMU

```
$ sudo apt install build-essential nasm qemu qemu-system
```

To successfully compile and run the system, a cross-compiler needs to be set up.
Why? [See here](https://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F). \
To build your own cross-compiler, execute the following commands (taken from [https://wiki.osdev.org/GCC_Cross-Compiler](https://wiki.osdev.org/GCC_Cross-Compiler)):

- Install the needed dependencies for building the cross-compiler
```
$ sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
```

- Download and extract the source code of Binutils and GCC. For compatible versions [see here](https://wiki.osdev.org/Cross-Compiler_Successful_Builds).
```
$ mkdir ~/code
$ cd ~/code
$ mkdir binutils-build
$ mkdir gcc-build
$ curl -O https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz
$ tar xf binutils-2.34.tar.xz
$ curl -O https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.xz
$ tar xf gcc-9.3.0.tar.xz
```

- Export variables needed for building Binutils and GCC
```
$ export PREFIX="$HOME/opt/cross"
$ export TARGET=i386-elf
$ export PATH="$PREFIX/bin:$PATH"
```


- Build and install Binutils
```
$ cd binutils-build
$ ../binutils-2.34/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
$ make
$ make install
```

- Build and install GCC 
```
$ cd ../gcc-build
$ ../gcc-9.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
$ make all-gcc
$ make all-target-libgcc
$ make install-gcc
$ make install-target-libgcc
```

## 👨‍💻 Getting up and running

- Execute `make run` to build and run

Further instructions

- `make` to execute a build
- `make clean` to remove all built files

## 🔗 Dependencies

*none*
