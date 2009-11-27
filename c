#!/bin/sh

mkdir -p bin
FNAME=`basename $1 .asm`
nasm -f elf $FNAME.asm -o bin/$FNAME.o && ld bin/$FNAME.o -o bin/$FNAME && bin/$FNAME

