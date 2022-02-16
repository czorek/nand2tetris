// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 0
@0
D=A
@LCL
D=D+M // address to pop into
@SP
AM=M-1
D=D+M
A=D-M
M=D-A

// label LOOP_START
(LOOP_START)
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

// push local 0
@0
D=A
@LCL
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

// pop local 0
@0
D=A
@LCL
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

// if-goto LOOP_START
@SP
AM=M-1
D=M
@LOOP_START
D;JNE

// push local 0
@0
D=A
@LCL
A=D+M // address to push
D=M // value to push
@SP
A=M
M=D
@SP
M=M+1

(END)
  @END
  0;JMP
