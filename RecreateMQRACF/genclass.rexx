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
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

* Contributors:
*   Colin Paice - Initial Contribution

************************************************************/
/*
 Rexx exec to extract data from RACF classes and produce the commands
 This example is to extract the MQ classes

 Parameters queue manager name.  It defaults to all profile
*/
/* do for each class in the list */
parse source p1 p2 p3 p4 p5 p6 p7 env p9
if env = "ISPF" then
do
  ADDRESS ISPEXEC
  "ISREDIT MACRO (profin,REST)"
end
else
  parse arg   profin .
list = "MQCMDS MXCMDS MQQUEUE MXQUEUE MXTOPIC MQADMIN MXADMIN",
        "MQCONN "
if profin = "" then profin = " "
say   " /* Profile used:"profin"."
do k = 1 to words(list)
   prof = profin
   class = word(list,k)
   x=doit()
end
exit

doit:
save_prof = prof
do j = 1 by 1 to 9999
  myrc=IRRXUTIL("EXTRACTN",class , prof, "RACF","","FALSE"       )
  /* the following is needed for a generic profile such as CSQ9.** */
  if myrc = "12 12 8 8 4" then /* invalid parameter  */
  do
    /* redo it with generic                          */
    myrc=IRRXUTIL("EXTRACTN",class , prof, "RACF","","TRUE"       )
  end

  if substr(myrc,1,1) ^= 0 then
  do
     if myrc = "12 12 4 4 4" then myrc = "profile not found"
     else
     if myrc = "12 12 4 4 12" then myrc = "class not found"
     else
     if myrc = "12 12 8 8 4" then myrc = " bad parm list "
    z=out( "                        ")
     z=out(" /* class:"class "profile:"prof myrc)
     z=out("                       ")
     return " "
  end
  /* check profile matches the one requested     */
  if   save_prof <> ' ' &,
     substr(RACF.Profile,1,length(save_prof)) <> save_prof then
     return ' '
 omit.        = ''  /* dont process these */
 skip.        ='' /* skip - for alternative processing */
 skip.ACLCNT  = 'skip'
 skip.ACLACNT = 'skip'
 skip.ACLACS  = 'skip'
 skip.ACLID   = 'skip'
 skip.RAUDIT  = 'skip'
 skip.WARNING = 'skip'

 comment.     ='' /* make these into comments */
 comment.LCHGDATE="Last Change Date"
 comment.ACSALTR ="Alter count     "
 comment.ACSCNTL ="Control count   "
 comment.ACSUPDT ="Update  count   "
 comment.ACSREAD ="Read    count   "
 comment.CREATDAT="Create date     "
 comment.LREFDAT = "Last reference Date "
 comment.LCHGDAT = "Last changed date "
 comment.RGAUDIT = "Global audit      "

 prof = RACF.Profile /* for next time round */
 z=out("RDEFINE "RACF.CLASS "-")
 z=out("      "RACF.Profile "- ")
 do j = 1 to RACF.BASE.0
     name = RACF.BASE.j
     if skip.name <> "" then
     do;
       /* handled later */
     end;
     else
     if comment.name <> "" then
     do
       z=out("- /* "comment.name RACF.BASE.name.1)
       iterate
     end
     else
     if omit.name != '' then
     do
       iterate
     end
     else
     if name = "RGAUDIT" then
     z=out("      "GLOBALAUDIT"("RACF.BASE.name.1") -")
     else
     if name = "RAUDIT" then
       z=out("      "AUDIT"("RACF.BASE.name.1") -")
     else
     if name = "WARNING" & RACF.BASE.WARNING.1 = "TRUE" then
       z=out("       WARNING  -")
     else
     /* just output it with no other processing  */
     z=out("      "name"("RACF.BASE.name.1") -")
   end
   z=out("      "   /* blank line to the the hanging -  */)

   /* now the accesses  */
   o=  "CLASS("RACF.CLASS" ) "
   z=out(" /* Permit "RACF.Profile o "RESET ")
   z=out(" ")
   if RACF.BASE.ACLID.0 >0 then
   do i = 1 to  RACF.BASE.ACLID.0
     if( length(RACF.Profile)> 20 ) then
     do
       o=  "CLASS("RACF.CLASS" ) "
       z=out("Permit "RACF.Profile" -")
       z=out(" "o " ID("RACF.BASE.ACLID.i ") ACCESS("RACF.BASE.ACLACS.i ")")
    end
    else
     z=out("Permit "RACF.Profile "CLASS("RACF.CLASS" )",
               " ID("RACF.BASE.ACLID.i ") ACCESS("RACF.BASE.ACLACS.i ")")
     z=out(" ")
   end /* the access definitions */
end
return " "
out:
parse arg in
     "ISREDIT LINE_AFTER .zlast  = '"in"'"
     /*
say in
*/
return ""
