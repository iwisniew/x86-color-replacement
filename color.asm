section .text

global sepia

%define img [ebp+8]
%define dist [ebp+12]
%define Rsel [ebp+16]
%define Gsel [ebp+20]
%define Bsel [ebp+24]
%define inputBlue [ebp-4]
%define inputGreen [ebp-8]
%define inputRed [ebp-12]
%define width 230400 ;340*240*3(RGB)=230400

sepia:
;create stack
push ebp
mov ebp, esp
sub esp, 0

;push registers onto stack
push esi
push ecx ; pixel counter
push edi
mov esi, img
xor ecx, ecx
xor edi, edi
;get input colors and store them in local variables
get_red:
xor eax, eax
inc ecx
mov al, BYTE[esi]
mov inputRed, eax
get_green:
xor eax, eax
inc ecx
mov al, BYTE[esi+1]
mov inputGreen, eax
get_blue:
xor eax, eax
inc ecx
mov al, BYTE[esi+2]
mov inputBlue, eax

check_dist:
xor eax, eax

mov eax, inputRed
sub eax, Rsel
imul eax, eax
mov edi, eax

mov eax, inputGreen
sub eax, Gsel
imul eax, eax
add edi, eax

mov eax, inputBlue
sub eax, Bsel
imul eax, eax
add eax, edi

cmp eax, dist       ; if inequalty (1) from PDF is satisfied replacement takes place
jg check_position   ; else we move to the next pixel

;calculate output colors and replace the original ones
outputBlue:
xor edi, edi
xor eax, eax
mov eax, inputBlue
imul eax, 131
mov edi, eax
mov eax, inputGreen
imul eax, 534
add edi, eax
mov eax, inputRed
imul eax, 272
add eax, edi
sar eax, 10

cmp eax, 255
jl load_blue    ;if outputBlue > 255 
mov eax, 255    ;set it to 255
load_blue:
mov BYTE[esi], al
;;;;;;;;;;;;;;;;;;;
outputGreen:
xor edi, edi
xor eax, eax
mov eax, inputBlue
imul eax, 168
mov edi, eax
mov eax, inputGreen
imul eax, 686
add edi, eax
mov eax, inputRed
imul eax, 349
add eax, edi
sar eax, 10

cmp eax, 255
jl load_green    ;if outputGreen > 255
mov eax, 255     ;set it to 255
load_green:
mov BYTE[esi+1], al
;;;;;;;;;;;;;;;;;;;;;
outputRed:
xor edi, edi
mov eax, inputBlue
imul eax, 189
mov edi, eax
mov eax, inputGreen
imul eax, 769
add edi, eax
mov eax, inputRed
imul eax, 393
add eax, edi
sar eax, 10

cmp eax, 255
jl load_red     ;if outputRed > 255
mov eax, 255    ;set it to 255
load_red:
mov BYTE[esi+2], al
;;;;;;;;;;;;;;;;;;;;;
check_position:
cmp ecx, width ;check if the pixel counter is on the last pxel
je exit        ;if it is then exit the program

next_pixel:
add esi, 3
jmp get_red

exit:
pop esi
pop ecx
pop edi
mov esp, ebp
pop ebp
ret

