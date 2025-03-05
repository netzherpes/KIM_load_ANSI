# KIM load ANSI
## How to load colorful ANSI pictures with your KIM
### need to start over again...  next try...

Save a textfile, *ending with an '@'* , rename it to the ending .bin <br>
Convert it with Hans Ottens converter to MOS Papertape, choose the location<br>
Load your ANSI to any given memory location.

IMPORTANT: End the File with an  @ ($40)

Define this location at 0A and 0B (lo, hi)<br>
    for example you store at $0200 - $0A=00 $0B=02<br>
Load the AnsiLoad program to adress $0080 and execute

If you want to start again, redefine 0A and 0B as both increment during the process.

next thing: get this fancy pictures ;), implement a CLS and a WAIT routine.

Viewing ANSI is not possible with Tera Term 5, as the use of codepages is broken (TT4 from 21 is working...)
