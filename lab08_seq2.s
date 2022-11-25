/*
** Dan Hauer 2020
** ECE 483 - Advanced Digital Systems Engineering
** Southern Illinois University at Edwardsville
*/

.text
.set noat
.set noreorder

start:
	sub $1, $8, $1 // 13 - 6 = 7
	and $3, $4, $1 // 9 and 7 = 
	or  $6, $7, $8
	add $4, $5, $7
	beq $1, $2, start
