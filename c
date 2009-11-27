#!/bin/sh

nasm -f elf $1.asm && ld $1.o -o $1.bin && ./$1.bin
