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
 part 5 of the SDSF log macros.   Takes the list of msgids and dispays
 rexx code - suitable for s2 processing.
 S2 deleted boring messgaes

 The exec has no parameters
*/
/* rexx */
ADDRESS ISPEXEC
'ISREDIT MACRO'
"ISREDIT delete all X           "  /* remove the duplicates */
"ISREDIT (r   ) = LINENUM .ZLAST"  /* size of the file    */
prev = ""
out = ""
out = "list = '"
do i = 1 to r
 "ISREDIT (ltrace) = LINE "  i
 parse var ltrace  . 20 msgid .
 out = out || " " ||msgid
 if (length(out) > 60) then
 do
   say out ||"',"
   out = "  '"
 end
end
 say out "'"
