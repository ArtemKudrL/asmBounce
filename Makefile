all:
	nasm -felf64 game.s -o game.o -g
	ld game.o -o game
	./game
