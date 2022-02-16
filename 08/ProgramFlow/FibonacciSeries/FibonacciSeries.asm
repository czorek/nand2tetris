// push argument 1
@1
D=A
@ARG
A=D+M // address to push
D=M // value to push
@SP
A=M
M=D
@SP
M=M+1

// pop pointer 1
@THAT
D=A // address to pop into
@SP
AM=M-1
D=D+M
A=D-M
M=D-A

// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop that 0
@0
D=A
@THAT
D=D+M // address to pop into
@SP
AM=M-1
D=D+M
A=D-M
M=D-A

// push constant 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop that 1
@1
D=A
@THAT
D=D+M // address to pop into
@SP
AM=M-1
D=D+M
A=D-M
M=D-A

// push argument 0
@0
D=A
@ARG
A=D+M // address to push
D=M // value to push
@SP
A=M
M=D
@SP
M=M+1

// push constant 2
@2
D=A
@SP
A=M
M=D
@SP
M=M+1

// sub
@SP
AM=M-1
D=M // value from top of stack
@SP
A=M-1
M=M-D  // calculation

// pop argument 0
@0
D=A
@ARG
D=D+M // address to pop into
@SP
AM=M-1
D=D+M
A=D-M
M=D-A

// label MAIN_LOOP_START
(MAIN_LOOP_START)
// push argument 0
@0
D=A
@ARG
A=D+M // address to push
D=M // value to push
@SP
A=M
M=D
@SP
M=M+1

// if-goto COMPUTE_ELEMENT
@SP
AM=M-1
D=M
@COMPUTE_ELEMENT
D;JNE

// goto END_PROGRAM
@END_PROGRAM
D;JMP

// label COMPUTE_ELEMENT
(COMPUTE_ELEMENT)
// push that 0
@0
D=A
@THAT
A=D+M // address to push
D=M // value to push
@SP
A=M
M=D
@SP
M=M+1

// push that 1
@1
D=A
@THAT
A=D+M // address to push
D=M // value to push
@SP
A=M
M=D
@SP
M=M+1

// add
@SP
AM=M-1
D=M // value from top of stack
@SP
A=M-1
M=M+D  // calculation

// pop that 2
@2
D=A
@THAT
D=D+M // address to pop into
@SP
AM=M-1
D=D+M
A=D-M
M=D-A

// push pointer 1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1

// push constant 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1

// add
@SP
AM=M-1
D=M // value from top of stack
@SP
A=M-1
M=M+D  // calculation

// pop pointer 1
@THAT
D=A // address to pop into
@SP
AM=M-1
D=D+M
A=D-M
M=D-A

// push argument 0
@0
D=A
@ARG
A=D+M // address to push
D=M // value to push
@SP
A=M
M=D
@SP
M=M+1

// push constant 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1

// sub
@SP
AM=M-1
D=M // value from top of stack
@SP
A=M-1
M=M-D  // calculation

// pop argument 0
@0
D=A
@ARG
D=D+M // address to pop into
@SP
AM=M-1
D=D+M
A=D-M
M=D-A

// goto MAIN_LOOP_START
@MAIN_LOOP_START
D;JMP

// label END_PROGRAM
(END_PROGRAM)
(END)
  @END
  0;JMP
