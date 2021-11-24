// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// LOOP
  // if KEYBOARD == 0 GOTO WHITE
  // if KEYBOARD > 0 GOTO BLACK

  // WHITE
    // addr = SCREEN
    // rows = 256
    // blacken row
    // for each row
      // whiten each word
      // for i < 256; i++; i=0

    //
  // BLACK

@256
D=A
@rows
M=D

@32
D=A
@words
M=D

(LOOP)
  @SCREEN
  D=A
  @addr
  M=D

  // if KEYBOARD == 0 GOTO WHITE
  @KBD
  D=M
  @WHITE
  D;JEQ
  @BLACK
  D;JGT

  (WHITE)
    // i = 0
    D=0
    @i
    M=D

    // for each row
    (ITERW)
      // finish when we reach max row
      @i
      D=M
      @rows
      D=D-M
      @LOOP
      D;JEQ

      D=0
      @j
      M=D

      // whiten each word in row (32)
      (ITERWROW)
        @j
        D=M
        @words
        D=D-M
        @NEXTWROW
        D;JEQ

        @addr
        D=M
        @j
        A=D+M
        M=0

        @j
        M=M+1

        @ITERWROW
        0;JEQ

      (NEXTWROW)
        @i
        M=M+1
        @32
        D=A
        @addr
        M=M+D

        @ITERW
        0;JEQ

  (BLACK)
    // i = 0
    D=0
    @i
    M=D

    // for each row
    (ITERB)
      // finish when we reach max row
      @i
      D=M
      @rows
      D=D-M
      @LOOP
      D;JEQ

      D=0
      @j
      M=D

      (ITERBROW)
        @j
        D=M
        @words
        D=D-M
        @NEXTBROW
        D;JEQ

        @addr
        D=M
        @j
        A=D+M
        M=-1

        @j
        M=M+1

        @ITERBROW
        0;JEQ

      (NEXTBROW)
        @i
        M=M+1
        @32
        D=A
        @addr
        M=M+D
        @ITERB
        0;JEQ
