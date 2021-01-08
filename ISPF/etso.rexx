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
 Rexx exec to issue a TSO command and insert the retured data at the 
bottom of the current file

Syntax

   etso command 
   
for example 
   etso LU
 
*/ 

parse source p1 p2 p3 p4 p5 p6 p7 env p9 
if env = "ISPF" then 
do 
  ADDRESS ISPEXEC 
  "ISREDIT MACRO (cmd ,REST)" 
end 
else 
do 
  Say "This has to run from an ISPF edit session " 
  return 8; 
end 
/* prevent auto save ... user has to explicitly save or cancel*/ 
"ISREDIT autoSave off prompt" 
if (length(cmd) = 0) then 
do 
  "VGET  tempargs " PROFILE 
  cmd = tempargs 
  Say " temp args are " cmd 
end 

x = OUTTRAP('VAR.') 
address tso   cmd rest 
y = OUTTRAP('OFF') 
/* insert each record at the top of the file */ 
do i = var.0 to 1 by -1 
  "ISREDIT LINE_AFTER 0  = '"var.i"'" 
end 
EXIT 
