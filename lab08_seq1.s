/*
** Dan Hauer 2020
** ECE 483 - Advanced Digital Systems Engineering
** Southern Illinois University at Edwardsville
*/

.text
.set noat
.set noreorder
	
	sub	$2, $3, $1 8-6=2
	and	$7, $2, $5 = 2
	or	$8, $6, $2 = 0xb(forward $2 value from memwb)
	add	$9, $2, $2 =4
	sw	$10, 4($2)
