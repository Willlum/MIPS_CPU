.text
.set noat
.set noreorder

1	nor $8, $26, $0 		# $8 = FFFF_FFE0
2	sub $1, $3, $2 			# $1 = 1
3	add $2, $0, $0 			# sorted = false (0)
4	add $9, $0, $0 			# sorting

whileloop:
5	beq $2, $1, done 		# if sorted==true, goto done
6	add $2, $1, $0 			# sorted = true (1)

7	add $3, $0, $0 			# i = 0
	
forloop:
8	add $3, $3, $1 			# i=i+1
9	beq $3, $11, whileloop 	# if i==16, goto whileloop
10	sub $4, $3, $1 			# i_prev = i-1
11	lw  $6, 0($3) 			# load mem[i]
12	lw  $5, 0($4) 			# load mem[i_prev]
	sub $7, $6, $5 			# temp = mem[i] - mem[i_prev]
	and $7, $7, $8 			# apply mask
	beq $7, $0, forloop 	# if temp==0 (arr[i] > arr[i_prev], goto forloop
		
	sw  $5, 0($3) 			# store mem[i]
	sw  $6, 0($4) 			# store mem[i_prev]
	add $2, $0, $0 			# sorted = false (0)
	beq $0, $0, forloop		# unconditional branch

done:
	add $9, $1, $0 			# sorting done
	beq $0, $0, done

/*
$0 = 0: constant to represent false
$1 = 1: constant to represent true
$2: sorted
$3: i
$4: i_prev
$5: arr[i-1]
$6: arr[i]
$7: temp
$8 = FFFF_FFE0: constant mask to check if number is negative (only works up to 31!!)
$9: 0->sorting, 1-> sort complete
*/

