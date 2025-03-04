; Target assembler: cc65 v2.18.0 [--target none -C asciidump.bin_cc65.cfg]
; 6502bench SourceGen v1.8.0-beta1
         .setcpu "6502"
lostart  =       $0a
hiStart  =       $0b
xOutch   =       $1EA0
crlf     =       $1E2F

         .org    $0080
		 jsr     crlf
         ldy     #$00
print:   lda     (lostart),y ;read a char
         cmp     #$40       ;stopcharacter
         beq     Reset      ;goodbye if @
		 jsr     xOutch
nextch:  clc
         lda     lostart    ;where to start
         adc     #$01
         sta     lostart
         lda     hiStart    ;where to start
         adc     #$00       ;add carry to histart 
         sta     hiStart
         lda     #$00
         beq     print
Reset:   jmp     $1c4f

