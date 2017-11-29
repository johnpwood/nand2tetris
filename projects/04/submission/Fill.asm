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

    (MAIN)
	@KBD
	D=M
	@PRESSED
	D;JGT
	@color
	M=0
	@STARTCOLORING
	0;JMP
	(PRESSED)
	@color
	M=-1
    (STARTCOLORING)
	@8192
	D=A
	@SCREEN
	D=D+A
	@endscreen
	M=D
	@SCREEN
	D=A
	@i
	M=D
    (INNER)
	@color
	D=M
	@i
	A=M
	M=D
	@i
	M=M+1
	D=M
	@endscreen
	D=D-M
	@INNER
	D;JNE
	@MAIN
	0;JMP
