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
 First in a suite of rexx execs to process SDSF operlog output in ISPF
 Edit.
 It builds a single line out of multi line messages
 It extracts interesting data.

 There are no parameters
*/
/* rexx */
ADDRESS ISPEXEC
'ISREDIT MACRO'
"ISREDIT (r   ) = LINENUM .ZLAST"  /* size of the file    */
data. = ''
append = ""
do i = r to 1 by -1
 "ISREDIT LOCATE     "i
 if rc ^= 0 then leave
 "ISREDIT (ltrace) = LINE "  i
 parse var ltrace  pre 42 b 43  n 46  x 57  rest
 if ( b= ' ' &datatype(n,'NUM')) then
 do
   data.n = data.n || ' '|| strip(rest)
   "ISREDIT delete  "i
 end
 else
 do
   parse var ltrace  what 2  . 26 t 34 . 38 j 46. 57  rest
   if (what="S") then
   do
     append = rest
     "ISREDIT delete  "i
     iterate
   end
   rest = rest ||  append
   append = ""
   l = strip(rest)
   ll = length(l)
   if ( ll > 5) then
   do
   n = substr(l,1+ll-3,3) /* 3 digit number */
   b = substr(l,1+ll-4,1) /* blank */
   if (b  = ' ' &,
      datatype(n)  = "NUM" ) then
      do
      if (data.n <> "" ) then
        do
           rest  = substr(rest,1,ll-4) || data.n
           data.n = ''
            "ISREDIT LINE " i "= (ltrace)"
        end
      end
  end
  ltrace = t ||' ' ||substr(j,1,10) ||' ' || rest
  "ISREDIT LINE " i "= (ltrace)"
 end
end
