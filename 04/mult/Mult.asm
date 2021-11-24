// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
//
// This program only needs to handle arguments that satisfy
// R0 >= 0, R1 >= 0, and R0*R1 < 32768.

// Put your code here.

// i = 0
// n = R1
// sum = 0
// R2 = 0

// (LOOP)
  // if i == n GOTO END

  // sum = sum + R0
  // i++
  // GOTO LOOP
// (END)
  // R2 = sum

// i = 0
@0
D=A
@i
M=D

// n = R1
@R1
D=M
@n
M=D

// sum = 0
@0
D=A
@sum
M=D

// R2 = 0
@0
D=A
@2
M=D

(LOOP)
  // if i == n GOTO SUM
  @i
  D=M
  @n
  D=D-M
  @SUM
  D;JEQ

  // sum + R0
  @R0
  D=M
  @sum
  D=D+M
  M=D

  // i++
  @i
  M=M+1

  // GOTO LOOP
  @LOOP
  0;JEQ

(SUM)
  // store sum in R2
  @sum
  D=M
  @2
  M=D
  @END
  0;JEQ
(END)
  @END
  0;JEQ