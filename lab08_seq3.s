/*
** Dan Hauer 2020
** ECE 483 - Advanced Digital Systems Engineering
** Southern Illinois University at Edwardsville
*/

.text
.set noat
.set noreorder

start:
	sub $1, $8, $1 // 1 cycle. 13 - 6 = , 2 cycle. 13-7=6
	beq $1, $2, start //1 cycle. branch taken, 2. branch not taken
	and $2, $3, $4 // 2 cycle. $2 = 8
