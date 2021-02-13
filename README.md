# Goodies
Various tools to make z/OS and associated products easier to use

# TLS trace tools
## ztrace process a java TLS trace on z/OS
For z/OS the ztrace exec can be used to take the trace from a java application running on z/OS (for example a Liberty server) and remove
most of the irrelevant data.  Put the macro in a clist library, or rexx library, edit the data set, or use SDSF and the SE line command (to edit the spool)
and type ztrace.
## tls.py python program for processing the tls trace on Linux (may work on windows)

Run a Java program which uses TLS and use 
```
-Djavax.net.debug=all 
or -Djavax.net.debug=ssl:handshake 
```
to produce a trace.
This produces a trace file, pipe this into the python program for example

cat mytls.txt |python tls.py |less



## MQRACF
Files and utilities making it easier to use MQ on z/OS

There are several macros when need to be available to your ISPF session.  If you use the TSO command ISRDDN it will display the datasets you have allocated.  The macros/rexx execs need to be in a dataset in SYSEXEC or SYSPROC.
### RecreateMQRACF 
Genclass recreates the RACF definitions for a queue manager.
If you edit a member and use genclass MQPA it will extract the definitons for MPQA and insert them into the member. For example 

```
RDEFINE MQCMDS   - 
      MQPC.AA3 - 
- /* Create date      07/28/20 
      OWNER(ADCDA) - 
- /* Last reference Date  07/28/20 
- /* Last changed date  07/28/20 
- /* Alter count      0 
- /* Control count    0 
- /* Update  count    0 
- /* Read    count    0 
      UACC(NONE) - 
      LEVEL(0) - 
- /* Global audit       NONE 
                                                                     
 /* Permit MQPC.AA3 CLASS(MQCMDS   )  RESET 
                                                                     
Permit MQPC.AA3 CLASS(MQCMDS   )  ID(ADCDA ) ACCESS(ALTER ) 

```

## ISPF

Two rexx execs are provided to allow you to capture the output from a TSO
command and insert it into a file.

The command 

ETSO command 

executes command and inserts the output into the bottom of the current file.


The command 

tempdsn command 

Allocates a temporary dataset ( userid.temptemp) and then issues the command
and captures the output.

# SDSF Operlog macros

A suite of rexx execs to process the operlog available with SDSF.  It does the followig
1.   S1 convert each multi line message into a single like
1.   S2 contains a list of "boring" message ids.  These get deleted from the file
1.   S3 Sorts the list on message id
1.   S4 Goes through the list and any message ids that have already been processed get excluded.  You can then use ISPF delete all x to remove the duplicates.
1.   You edit the file to leave only boring messages and run S5.   This creates some rexx code you can use in  S2

It shrank a 9000 line operlog down to 500 lines.   When I used the "boring" rexx - it left 10 messages.

### Installation
The the 5 rexx execs in the rexx or clist concatenation in ISPF.   
Type S1 then S2 etc

