/*
** Dan Hauer 2020
** ECE 483 - Advanced Digital Systems Engineering
** Southern Illinois University at Edwardsville
*/

.text
.set noat
.set noreorder

start:
	sub $1, $8, $1
	sw $1, 0($3)
	lw $4, 8($0)
	beq $4, $2, start
	and $2, $0, $0

