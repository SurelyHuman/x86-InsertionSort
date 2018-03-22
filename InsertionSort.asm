;-------------------------------------------------------------------------------
;Seth Lewis
;CIS 330-2F/330L-7F Program 4
;3-6-2018
;
;Program to sort an integer array of n length
;
;Revision History:
;3-6-18 initialization of array, user input, and printing
;3-8-18 sort completed insertion sort as chosen algorithm
;
;-------------------------------------------------------------------------------

global main

extern printf
extern scanf

SECTION .data ; for initialized data

arr: times 20 dd 0 ; in

section .bss ; uninitialized data

a: resd 1 ; input value
key: resd 1 ; key
counter: resd 1 ; counter

section .rodata ; read only data

prompt: db "Enter any nonzero integer, enter 0 to sort and exit:", 0xA, 0x0
error_no_data: db "ERROR: No data entered.", 0x0
print_counter: db "Number of entries: %d", 0xA, 0x0
sorted: db "Sorted Array: ", 0x0
you_entered: db "You entered: %d", 0xA, 0x0
terminate: db 0xA, "Program Terminated.", 0xA, 0x0
array_print: db "%d ", 0x0
verify_print: db "value at myArray index %d: %d ", 0xA, 0x0

fmt: db "%d", 0x0

section .text ; executable code

main:

.start_loop: ; first loop to initialize array and for program routing
  mov edi, prompt
  mov eax, 0 ; no xmm registers
  call printf

  mov rdi, fmt ; user enters an integer program ends if a = 0
  mov rsi, a
  mov rax, 0
  call scanf

  mov edi, you_entered ; print to verify correctness
  mov esi, [a]
  mov eax, 0
  call printf

  mov eax, [a]
  cmp eax, 0 ; check for entry of zero by user
  je .test_for_data ; jump to data check if user enters a 0

  mov eax, [counter] ; move counter value to eax
  inc eax ; increment eax 1 from last counter value
  mov ecx, eax
  dec ecx ; eax - 1 for correct array index
  mov ebx, [a]
  mov dword[arr + ecx*4], ebx ; store input into array
  mov [counter], eax ; move value back to counter variable for storage

  mov edi, verify_print
  mov esi, ecx
  mov edx, dword[arr + ecx*4]
  mov eax, 0
  call printf

  mov edi, print_counter ; print to verify correctness
  mov esi, [counter]
  mov eax, 0
  call printf

  mov eax, [counter]
  cmp eax, 20 ; compare counter value
  je .test_for_data ; jump to sorting once max length reached

  jmp .start_loop ; return to start of loop an repeat above while [a] != 0

.test_for_data: ; check for no data entered before 0
  mov eax, [counter]
  cmp eax, 0 ; compare counter value
  je .no_data ; if counter is zero jump to no_data
  jmp .sort_setup ; else jump to sort setup

.no_data: ; jump here if zero is entered before data
  mov edi, error_no_data
  mov eax, 0
  call printf
  jmp .continue

.sort_setup: ; setup sort loop
  mov ecx, 1 ; j = 1 insertion sort loop index

.sort_for: ; first part of insertion sort for loop
  cmp ecx, [counter] ; check for j < length end loop when = to array length
  je .sorted ; end of loop jump to printing
  mov ebx, dword[arr + ecx*4] ; array[j]
  mov [key], ebx ; key = array[j]
  mov eax, ecx ; esi = i
  dec eax ; i = j - 1


.sort_while: ; insertion sort while loop
  cmp eax, 0 ;
  jnge .sort_next ; if i < 0 jump to end of for loop
  mov esi, dword[arr + eax*4] ; array[i]
  cmp esi, [key]
  jng .sort_next ; if key >= array[i] jump to end of for loop
  mov dword[arr + eax*4 + 4], esi ; array[i+1] = array[i]
  dec eax ; i = i - 1
  jmp .sort_while ; jump back to loop conditional

.sort_next:
  mov ebx, [key]
  mov dword[arr + eax*4 + 4], ebx ; array[i+1] = key
  inc ecx ; j++
  jmp .sort_for ; jump to for loop conditional

.sorted:
  mov edi, sorted ; print sort message
  mov eax, 0
  call printf

  mov ebx, 0 ; set start index of print loop

.print_loop: ; print array in ascending order to length of counter - 1

  mov edi, array_print
  mov esi, dword[arr + ebx*4]
  mov eax, 0
  call printf

  inc ebx
  cmp ebx, [counter]
  je .continue ; if ebx = counter jump to end
  jmp .print_loop ; else return to start of print loop

.continue:
  mov edi, terminate ; print program termination message
  mov eax, 0
  call printf
  ret
