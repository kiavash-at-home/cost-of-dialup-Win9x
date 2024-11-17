CLS
PRINT "This program read modem log that created with Win9x and calculate price of tel."

REM **************Initialing values***************
        pulse = 0
        musage = 0
        flag = 0
        n = 0
        puldur = 3                                      'pulse duration
        logfile% = FREEFILE                             'Cearte free no. for file

REM **************Input values********************
        INPUT "Enter log. file: <modem.log>"; n$                 'Input name of file
        IF n$ = "" THEN n$ = "modem.log"
       
        INPUT "Output file: <modem.txt>"; o$                     'Out put file
        IF o$ = "" THEN o$ = "modem.txt"

        INPUT "Pice of each pulse: <3.2 unit>"; pulprc            'Input price of each tel pulse
        IF pulprc = 0 THEN pulprc = 3.2

REM ******************Begin***********************
OPEN n$ FOR INPUT AS #logfile%                  'open log. file
outfile% = FREEFILE
OPEN o$ FOR OUTPUT AS #outfile%
PRINT #outfile%, "Modem Usage"

PRINT "+-no.-+--------Start--------+---------End---------+-Dur-+"
PRINT #outfile%, "+-no.-+--------Start--------+---------End---------+-Dur-+"
DO WHILE NOT EOF(logfile%)                      'check end of file
        LINE INPUT #logfile%, OneLine$          'read one line
        txt$ = RTRIM$(LTRIM$(OneLine$))         'delete spaces
        FOR j% = 1 TO LEN(txt$)
                bb$ = MID$(txt$, j%, 1)         'each character in line
                IF bb$ = "C" THEN
                        b$ = MID$(txt$, j%, 8)
                        IF b$ = "CARRIER " THEN                 'Carrier detect
                                sdate$ = LEFT$(txt$, 10)                'Start date
                                stime$ = MID$(txt$, 12, 8)              'Start time
                                sday = VAL(MID$(sdate$, 4, 2))          'Start day
                                shour = VAL(LEFT$(stime$, 2))           'Start hour
                                smin = VAL(MID$(stime$, 4, 2))          'Start min
                                ssec = VAL(RIGHT$(stime$, 2))           'Start second
                                flag = 1                                'set dial flag
                                n = n + 1
                                PRINT "|"; n; TAB(7); "| "; TAB(9); sdate$; TAB(20); stime$; " |";
                                PRINT #outfile%, "|"; n; TAB(7); "| "; TAB(9); sdate$; TAB(20); stime$; " |";
                        END IF
                ELSEIF bb$ = "H" THEN
                        b$ = MID$(txt$, j%, 7)
                        IF b$ = "Hanging" THEN  'Hang up detect
                            IF flag = 1 THEN
                                flag = 0                                'reset dial flag
                                edate$ = LEFT$(txt$, 10)                'End date
                                etime$ = MID$(txt$, 12, 8)              'End time
                                eday = VAL(MID$(edate$, 4, 2))          'End day
                                ehour = VAL(LEFT$(etime$, 2))           'End hour
                                emin = VAL(MID$(etime$, 4, 2))          'End min
                                esec = VAL(RIGHT$(etime$, 2))           'End second
                                mtot = (eday - sday) * 1440 + (ehour - shour) * 60 + (emin - smin) + (esec - ssec) / 60
                                musage = musage + mtot
                                pulse = CINT(mtot / puldur + .5) + pulse
                                PRINT TAB(31); edate$; TAB(42); etime$; " |"; TAB(52); CINT(mtot + .5); TAB(57); "|"
                                PRINT #outfile%, TAB(31); edate$; TAB(42); etime$; " |"; TAB(52); CINT(mtot + .5); TAB(57); "|"
                            ELSE pulse = pulse + 1
                            END IF
                        END IF
                END IF
        NEXT
LOOP
CLOSE #logfile%
price = pulse * pulprc
PRINT "+-----+---------------------+---------------------+-Min-+": PRINT
PRINT #outfile%, "+-----+---------------------+---------------------+-Min-+": PRINT #outfile%,
PRINT "Total telephone usage is "; CINT(musage + .5); " min."
PRINT #outfile%, "Total telephone usage is "; CINT(musage + .5); " min."
PRINT "Total telephone pulse is "; pulse; " pulse"
PRINT #outfile%, "Total telephone pulse is "; pulse; " pulse"
PRINT "Each pulse is "; pulprc; " unit": PRINT
PRINT #outfile%, "Each pulse is "; pulprc; " unit": PRINT
PRINT "Total price of telephone that used for modem is "; price; " unit"
PRINT #outfile%, "Total price of telephone that used for modem is "; price; " unit"
CLOSE #outfile%
