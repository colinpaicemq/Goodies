/* REXX */ 

/************************************************************** 
MIT License 
                                                                              
Copyright (c) 2020 Stromness Software Solutions. 
                                                                              
Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions: 
                                                                              
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software. 
                                                                              
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE. 
                                                                              
* Contributors: 
*   Colin Paice - Initial Contribution 
                                                                              
************************************************************/ 
/* 
 Rexx exec to create a temporary data set as part of execting 
TSO commands and capturing the output in an ISPF file
Syntax from TSO 

tempdsn tsocommand              
 
*/ 
parse source p1 p2 p3 p4 p5 p6 p7 env p9 
say "env" env 
if env = "ISPF" then 
do 
  ADDRESS ISPEXEC 
  "ISREDIT MACRO (cmd ,REST)" 
end 
else 
do 
  Say "This has to run from an ISPF session " 
  return 8; 
end 
tempargs = "" 
parse arg args 
if ( length(args) > 0) then 
do 
  tempargs = args 
  "VPUT tempargs  profile" 
end 
say "args "args 
say "command "cmd rest 
u = userid() 
address TSO  "ALLOC DSN('"u".temptemp')  space(1,1) tracks NEW DELETE ", 
  "BLKSIZE(2330) LRECL(233) recfm(v B)  DDNAME(MYDD)" 
if (rc <> 0)  then exit 
address ISPEXEC "EDIT DATASET('"u".temptemp') MACRO(ETSO)" 
address TSO  "FREE DDNAME(MYDD)" 
if ( length(tempargs) > 0) then 
do 
   "VERASE tempargs  profile" 
end 
