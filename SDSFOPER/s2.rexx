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
 Second exec in a suite to process SDSF operlog in ISPF edit.
 Rexx S1 has converted all multi lin messages to single line

 The end user should tailor this by producing a list of boring
 messages.
 This rexx program iterates over a list and deletes all records
 in the operlog with the words in the list

 This boring list can be created by rexx S5 - later.  Cut and paste
 the output here.
*/
ADDRESS ISPEXEC
/* a list of msgids you want to ignore .. they get deleted */
'ISREDIT MACRO'
list = "CSQY1 "
"ISREDIT exclude all"
do i = 1 to words(list)
   w = word(list,i)
   "ISREDIT find '"w"'  ALL "
end
"ISREDIT delete all nx"
"ISREDIT reset  "

