/* REXX */
/**************************************************************
MIT License

Copyright (c) 2021 Stromness Software Solutions.

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
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

* Contributors:
*   Colin Paice - Initial Contribution

************************************************************/
/*
 Rexx exec to process the output of a Java TLS(SSL) trace for example
 from Liberty web server and remove boring information, and put
 some html tags in it to make it easier to display
 It has no parameters.
*/
/* rexx */                                                              00010000
ADDRESS ISPEXEC
'ISREDIT MACRO'
"ISREDIT hex on"
"ISREDIT change x'0d' x'40' all"
"ISREDIT hex off "
"ISREDIT (ss  ) = LINENUM .ZLAST"  /* size of the file    */
"ISREDIT (r,c)  = CURSOR" /* get the row and column number */
"ISREDIT cursor =  "  1
do i = ss    to 1       by -1
  "ISREDIT (ltrace) = LINE "  i
  if (rc <> 0) then leave
  parse var ltrace w1 w2 .
  /* remove line with just commas in it */
  if (w2 = "" & w1 = ",") then
      "ISREDIT delete       "i
  /* remove a line with just a number in it */
  else if (w2 = "" & datatype(w1) ="NUM")  then
      "ISREDIT delete   "i
  else ,
  do
    /* remove trailing blanks */
    ltrace = "'"strip(ltrace,'t')"'"
    "ISREDIT LINE " i "=" ltrace
  end
end
/* do change < to &lt; and > to &gt; for HTML */
"ISREDIT change '>' x'5087A35E' all"
"ISREDIT change '<' x'5093A35E' all"

"ISREDIT exclude all"
/* remove boring messages */
"ISREDIT find 'CWWK' ALL "
"ISREDIT find 'DYNA1' ALL"
"ISREDIT find 'IZUG'  ALL"
"ISREDIT find 'SRVE' ALL"
"ISREDIT find 'KSB0' ALL"
"ISREDIT find '[AUD' ALL"
"ISREDIT find 'com.ibm.' ALL"
"ISREDIT find 'SESN0' ALL"
/*        hex data */
"ISREDIT find ':' 5 5 ALL"
/* and delete them all    */
"ISREDIT delete all nx"
"ISREDIT reset  "
 "ISREDIT (lineno) = LINENUM .ZLAST"

certt.1 = "'chain' 1 5 "
certt.2 = "'Found trusted certificate:' 1 27"
/* pretty the certificates */
do jj = 1 to 2
  "ISREDIT LOCATE   1 "
  "ISREDIT find "certt.jj"     first"
  if (rc = 0) then
  do i = 1 to 999999
      "ISREDIT (r,c)  = CURSOR"
       do j = r+1  to r+999
         "ISREDIT (ltrace) = LINE (j)  "
          parse var ltrace  rest
          if (substr(ltrace,1,10)="  Subject:") then
          do
           ltrace = strip(ltrace,'t')
           parse var ltrace x':'subj
           tag = "'<b>Certificate for " subj"</b>" ltrace"'"
           "ISREDIT LINE " j "=" tag
          end;
           "ISREDIT XSTATUS "j" = X"
          if (substr(ltrace,1,12) = "  Signature:")
          then leave
       end
       "ISREDIT XSTATUS "j+1" = X"

       "ISREDIT LOCATE " j+2
      "ISREDIT rfind                 "
      if (rc <> 0) then leave
  end
end
  "ISREDIT find 'Algorithm:' all    "
  "ISREDIT find 'Subject:' all    "
  "ISREDIT find 'Signature Algorithm:' all"
  "ISREDIT find 'key:'               all"
  "ISREDIT find 'Issuer:'         all"
  "ISREDIT delete all x              "

"ISREDIT cursor =  "  1
do forever
  "ISREDIT find 'found key for'     "
  if (rc <>   0 ) then leave
  "ISREDIT (r,c)  = CURSOR" /* get the row and column number */
  "ISREDIT (ltrace) = LINE (r)  "
   ltrace = strip(ltrace,'t')
   /* html it */
   t = "'<details><summary>" ltrace"</summary>'"
   "ISREDIT LINE " r "=" t
  "ISREDIT find '***'     "
  if (rc <>   0 ) then leave
  "ISREDIT delete .zCSR"
  /* pick up the next one */
  "ISREDIT (r,c)  = CURSOR" /* get the row and column number */
  "ISREDIT (ltrace) = LINE (r)  "
  /* pretty it into html */
   t = "'***</details>'"
   "ISREDIT LINE " r "=" t
end
/* stick <pre> around the content */
  "ISREDIT line_before .zfirst = '<PRE>' "
  "ISREDIT line_after  .zlast  = '</PRE>'"
  /* set the cursor on the command line */
  return 1;
exit
