# Goodies
Various tools to make z/OS and associated products easier to use

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

