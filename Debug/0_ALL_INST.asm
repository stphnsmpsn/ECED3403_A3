; ------------------------------------------------
;				 STEPHEN SAMPSON
;			MSP-430 EMULATOR TEST FILE
;				 ALL INSTRUCTIONS
; ------------------------------------------------
; For this test file, registers were initialized
; as shown below. This was done because at this
; stage I was not 100% sure the MOV instruction 
; worked as it should and wanted to isolate 
; possible causes of error.
;
; Jump instructions had the line:
; 	registers[PC] += offset10to16(offset)
; commented out so only the conditions were
; checked from the same state each time. 
; ------------------------------------------------
;uint16_t registers[16] = {							
;	0,      0xFFC0, 0x0008, 0,						 
;	4094,   0xFF00, 0x8AAB, 0x0080,					
;	0,      0xF000, 0x0F00, 0x00F0,					
;	0x000F, 0x000F, 0x000F, 0x000F					
;};		
; ------------------------------------------------


; ------------------------------------------------
; 		    DEVICES IN LOW MEMORY (0-32)
; ------------------------------------------------


; ------------------------------------------------
;		    DATA IN LOW MEMORY (>32)
; ------------------------------------------------

ORG $FFC
DATA WORD $1357
DATA2 WORD $1234

; ------------------------------------------------
; 		SET ADDRESS OF FIRST INSTRUCTION
; ------------------------------------------------

ORG $1000

; ------------------------------------------------
;		    ONE OPERAND INSTRUCTIONS
; ------------------------------------------------

rrc		@R4+		; LOC: 4094	 			= 	0x1234 (0001 0010 0011 0100) --> 0x091A (0000 1001 0001 1010)
					; SREG {V, N, Z, C}		=	{0, 0, 0, 0}
					
swpb	R5			; LOC: R5  				= 	0xFF00 (1111 1111 0000 0000) --> 0x00FF (0000 0000 1111 1111)
					; SREG {V, N, Z, C}		=	{0, 0, 0, 0}				
					
rra		R6			; LOC: R6 				=	0x8AAB (1000 1010 1010 1011) --> 0xC555 (1100 0101 0101 0101)
					; SREG {V, N, Z, C}		=	{0, 1, 0, 1}					
					
sxt		R7			; Loc: R7 				= 	0x0080 (0000 0000 1000 0000) --> 0xFF80 (1111 1111 1000 0000)
					; SREG {V, N, Z, C}		=	{0, 1, 0, 1}					
					
push	R7			; Loc: 65470 			=	0xFF80 (1111 1111 1000 0000)
					; SREG {V, N, Z, C}		=	{0, 1, 0, 1}
					
;call	R4			;
					;
					;
					
;reti				 
					;
					;
					;
					
; ------------------------------------------------				
; 			TWO OPERAND INSTRUCTIONS
; ------------------------------------------------

mov		#$1234,R8	
; Loc: R8				=	$1234 (0001 0010 0011 0100)
; SREG {V, N, Z, C}		=	{0, 1, 0, 1}			

add		R6,R9
; Loc: R9					0xF000 (1111 0000 0000 0000)	61440	
; Loc: R6				+   0xC555 (1100 0101 0101 0101)	50517
;						___________________________________________
; Loc: R9				=   0xB555 (1011 0101 0101 0101)	46421(119,957)
; SREG {V, N, Z, C}		=	{0, 1, 0, 1}
					
addc	R6,R10		
; Loc: R10					0x0F00	(0000 1111 0000 0000)	3840
; Loc: R6				+	0xC555	(1100 0101 0101 0101)	50517
; SREG_CARRY			+	0x0001	(0000 0000 0000 0001)   1
;						___________________________________________
; Loc: R10				=	0xD456	(1101 0100 0101 0110)	54358
; SREG {V, N, Z, C}		=	{0, 1, 0, 0}
					
					
subc	R6,R11		
; Loc: R11				 	0x00F0 	(0000 0000 1111 0000)	 240				
; Loc: R6				+ 	~0xC555 (0011 1010 1010 1010)	 15018			
; SREG_CARRY			+ 	0x0000	(0000 0000 0000 0000)	 0 				
;						___________________________________________			 
; Loc: R11				=	0x3B9A	(0011 1011 1001 1010)	 15258
; SREG {V, N, Z, C}		=	{0, 0, 0, 0}
					
					
sub		R6,R12		
; Loc: R12					0x000F 	(0000 0000 0000 1111)	15				     	
; Loc: R6				+ 	~0xC555 (0011 1010 1010 1010)	15018			
;						+ 	0x0001	(0000 0000 0000 0001)	1				
;						__________________________________________			
; Loc: R12				=	0x3ABA	(0011 1010 1011	1010)	15034 				 
; SREG {V, N, Z, C}		=	{0, 0, 0, 0}

					
cmp		R5,R12		
; Loc: R12					0x3ABA	(0011 1010 1011 1010)	15034			  
; Loc: R5				+	~0x00FF	(1111 1111 0000 0000)	65280			
;						+	0x0001	(0000 0000 0000 0001)	1				
;						___________________________________________			  
; Loc: R12				=   0x39BB	1(0011 1001 1011 1011)	14779(80315) 				 
; SREG {V, N, Z, C}		=	{0, 0, 0, 1}
					
					
;dadc	R5,R12		; TA_Not_Imp


bit		R5,R12		
; Loc: R12					0x3ABA	(0011 1010 1011	1010)	
; Loc: R5				&	0x00FF	(0000 0000 1111 1111)
;						_________________________________
; Loc: R12 				= 	0x00BA	(0000 0000 1011 1010)	
; SREG {V, N, Z, C}		=	{0, 0, 0, 1}

					
bic		R5,R13		
; Loc: R13					0x000F 	(0000 0000 0000 1111)	
; Loc: R5				&	~0x00FF	(1111 1111 0000 0000)		
;						_________________________________
; Loc: R13				= 	0x0000	(0000 0000 0000 0000)
; SREG {V, N, Z, C}		=	{0, 0, 0, 1}

					
bis		R5,R14		
; Loc: 14					0x000F 	(0000 0000 0000 1111)		
; Loc: R5				|	0x00FF	(0000 0000 1111 1111)
;						_________________________________
; Loc: R14				= 	0000 0000 1111 1111 
; SREG {V, N, Z, C}		=	{0, 0, 0, 1}

					
xor		R5,R15		
; Loc: R15					0x000F	(0000 0000 0000 1111)
; Loc: R5				^	0x00FF	(0000 0000 1111 1111)
;						_________________________________
; Loc: R15				=	0x0000	(0000 0000 1111 0000)
; SREG {V, N, Z, C}		=	{0, 0, 0, 1}


and	#$F0F0,&DATA		
; Loc: 4092					0x1357	(0001 0011 0101 0111) 	
; Loc: PC+2				&	0xF0F0	(1111 0000 1111 0000)
;						_________________________________
; Loc: 4092				=	0x1050	(0001 0000 0101 0000)
; SREG {V, N, Z, C}		=	{0, 0, 0, 1}

; ------------------------------------------------	
;				END OF TEST FILE
; ------------------------------------------------	

END
