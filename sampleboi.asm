.ORIG x3000
AND R0, R0, #0
ADD R0, R0, #1
STI R0, IsPrimeLoc

IsPrimeLoc .FILL x5000

TRAP x25

.END