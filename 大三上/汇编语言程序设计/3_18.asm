.486  
DATA SEGMENT USE16  
MESG1 DB 'INPUT USER:$'  
MESG2 DB 'INPUT PWD:$'  
USER  DB 20  
      DB ?  
      DB 20 DUP(?)  
PWD   DB 20 DUP(?)  
PWDLENGTH DB 0  
  
U     DB 'B14040411'  
ULENGTH EQU $-U  
  
P     DB 'B14040411'  
MLENGTH EQU $-P  
  
WELCOME DB 'WELCOME$'  
ERROR DB 'USER ERROR$'  
ERROR1 DB 'PASSWORD ERROR$'  
DATA ENDS  
CODE SEGMENT USE16  
ASSUME CS:CODE,DS:DATA  
BEG:  MOV AX,DATA  
      MOV DS,AX  
        
NEXT0:  
      MOV PWDLENGTH,0  
      MOV AH,9  
      MOV DX,OFFSET MESG1  
      INT 21H  
        
      MOV AH,0AH  
      MOV DX,OFFSET USER  
      INT 21H  
  
      MOV AH,2  
      MOV DL,0AH  
      INT 21H  
        
      MOV AH,9  
      MOV DX,OFFSET MESG2  
      INT 21H  
        
      MOV CX,MLENGTH  
      MOV SI,OFFSET PWD  
NEXT1:MOV AH,07H       ;无回显从键盘读入一个字符  
      INT 21H  
      CMP AL,0DH  
      JE IND  
      MOV [SI],AL  
      MOV AH,2  
      MOV DX,'*'  
      INT 21H  
      INC PWDLENGTH  
      INC SI  
      ;CMP BYTE PTR [SI-1],0DH     
      ;JNZ NEXT1  
      JMP NEXT1  
   
IND:  MOV AH,2  
      MOV DL,0AH  
      INT 21H  
        
  
      ;MOV BX,OFFSET U  
       
      MOV BX,OFFSET USER+1  
      MOV AL,[BX]  
      CMP AL,ULENGTH        ;比较用户名长度  
      JNZ UERR  
        
      MOV BX,OFFSET U  
      MOV SI,OFFSET USER+2  
      MOV CX,ULENGTH  
NEXT2:  
      MOV AL,[BX]  
      CMP [SI],AL  
      JNZ UERR  
      INC SI  
      INC BX  
      LOOP NEXT2  
        
  
      MOV BX,OFFSET P  
      MOV SI,OFFSET PWD      
      MOV CL,PWDLENGTH  
      MOV CH,0  
      CMP CX,MLENGTH      ;比较密码长度  
      JNZ PERR  
      MOV CX,MLENGTH  
NEXT3:  
      MOV AL,[BX]  
      CMP [SI],AL  
      JNZ PERR  
      INC SI  
      INC BX  
      LOOP NEXT3  
      JMP WEL  
        
UERR: MOV AH,9  
      MOV DX,OFFSET ERROR  
      INT 21H  
      MOV AH,2  
      MOV DL,0AH  
      INT 21H  
      JMP NEXT0  
  
PERR: MOV AH,9  
      MOV DX,OFFSET ERROR1  
      INT 21H  
      MOV AH,2  
      MOV DL,0AH  
      INT 21H  
      JMP NEXT0  
        
WEL:  MOV AH,9  
      MOV DX,OFFSET WELCOME  
      INT 21H  
      JMP EXIT  
EXIT: MOV AH,4CH  
      INT 21H  
CODE ENDS  
      END BEG 