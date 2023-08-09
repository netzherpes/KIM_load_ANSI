;***********************
;* How to Load an ANSI *
;* Picture on a KIM-1  *
;* with an attatched   *
;* ANSI terminal       *
;* just a test......   *
;* assemble with 64tass*
;***********************

;most of the code is stolen from Jim

xOutch     = $1EA0
; A routine to get a byte from the console...
xGetch     = $1E5A
; ...and the reset vector to restart the system.
xStart     = $1C4F

; Define the Page Zero Locations we will use...
;
; We avoide the KIM's monitor, but other than that this probably
; isn't critical since whatever we load will likely initialize
; most of Page Zero for its own use.
;
SADDR      = $E0             ; Start Address
EADDR      = SADDR + 2       ; End Address
DADDR      = EADDR + 2       ; Destination Address

;
; Define any constants we want to use...
;
CR         = $0D
LF         = $0A

;
; PAL-1/KIM Hardware addresses used
;
SBD        = $1742           ; PAL-1 RIOT B Data Register

;
; We will be entering from the monitor, so we can assume that the stack
; and other items have been initialized as needed.
;
; Can test at other locations, but eventually ends up in ROM at $A000.
; The upper 16K of the RAM card starts at $6000 and can be used for
; testing.
;
*          = $2000
           CLD
           LDX #$FF	; Set up stack
	       TXS



LOAD_W:    LDA #<MSG1        ; If so, print message
           STA SADDR+0
           LDA #>MSG1
           STA SADDR+1
           JSR SHWMSG

           JMP LOAD_P

MSG1:      .null CR,LF,"roger rabbit",CR,LF

 
LOAD_P:
           LDA #<pic_start ; Point to start in ROM
           STA SADDR+0
           LDA #>pic_start
           STA SADDR+1

           LDA #<pic_finish ; Point to end in ROM
           STA EADDR+0
           LDA #>pic_finish
           STA EADDR+1
 
           JSR COPY  ; Move source to destination
		   JMP xStart
		   
		   
; COPY will copy non-overlapping memory down from the ROM
; and into RAM.
;
COPY:      LDY #0
_COPY2:    LDA (SADDR),Y     ; copy from source
           JSR xOutch        ; to screen
;
; Check to see if the Start address (which is incremented as we
; go) equals the End address.
;
           LDA SADDR+1       ; reached end yet?
           CMP EADDR+1
           BNE _NotFin
           LDA SADDR+0
           CMP EADDR+0
           BNE _NotFin
           RTS               ; Return when were done

_NotFin:   INC SADDR+0       ; Not finished, then increment Source (16 bits)
           BNE _NoInc1       ; Do we need to increment upper byte?
           INC SADDR+1

_NoInc1:   JMP _COPY2


;
; SHWMSG will display a null delimited string to the console.
;
SHWMSG:    LDY #0            ; Show message subroutine
           LDA (SADDR),Y     ; Load a character
   	       BEQ DONE          ; Did we just load a $00 end-of-string?
           JSR xOutch        ; If not, print it
           INC SADDR+0       ; increment the character pointer
           BNE SHWMSG
           INC SADDR+1
           BNE SHWMSG
        
DONE:	   RTS               ; Jump here to return at end-of-string

.include "rabbit.s"