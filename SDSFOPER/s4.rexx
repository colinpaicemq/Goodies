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
 Fourth rexx exec in a suite to take process SDSF operlog in ISPF edit
 S1 made multi line messages into single line messages
 S2 remove user specified boring messages
 S3 sorted the messages into msgid order

 This rexx iterates over the file and checks the msgid.  If it has
 already been processed then exclude the line.

 You can use the ISPF edit command delete all X to remove duplicates

*/
ADDRESS ISPEXEC
'ISREDIT MACRO'
"ISREDIT (r   ) = LINENUM .ZLAST"  /* size of the file    */
prev = ""
do i = 1 to r
 "ISREDIT (ltrace) = LINE "  i
 parse var ltrace  t 11 jobid 20 msgid rest
 if (msgid = prev ) then
   "ISREDIT xstatus " i "= X"
 prev = msgid
end
