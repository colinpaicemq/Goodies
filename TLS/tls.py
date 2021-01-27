/*
Python script for removing irrelevant information from a tls trace.

run a Java program which uses TLS and use -Djavax.net.debug=all 
or -Djavax.net.debug=ssl:handshake to produce a trace.
This produces a trace file, pipe this into the python program for example

cat mytls.txt |python tls.py |less
 

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
nested = 0
nest=[] 
 
from sys import stdin

print("<pre>")
for line in stdin:
  line = line.rstrip() 
  sline= line.strip()
  out = line
  #  compress a certificate surrount with <detail> </detail> tags
  if nested == 1:
    if line.startswith("    "):
#       print("IN starts with ")
       nest.append(line)
       if line.startswith("    \"subject\""):
          subject= line.strip()   
       continue  
    else:
#     print("doesnt start with ")
     print("<details><summary>" + subject + "</summary>")
     for n in nest:
         print(n)
     print("</details>")
     nested = 0
     nest =[] 
     
      
  elif sline[3:5] == "0:":  
     continue
  elif sline[0:1] == "]":  
     continue
  elif sline[0:1] == ")":  
     continue
  elif sline[0:9] == "ObjectId:":  
     continue
  elif "|Raw read (" in sline:  
     continue
  elif "|Raw write (" in sline:  
     continue
  elif sline.find("Plaintext before") > 0:
     continue
  elif sline.find("Plaintext after") > 0:
     continue
  # strip trace header info from the front
  elif sline.find("GMT|") > 0:
     x = sline.find("GMT|") +4 
     t = sline[x:] 
     t = t.split("|")
     out = t[1] 
     # print("find:"+ out)
  # need to do this outside of else because the nested processing
  if line.startswith("  \"certificate\""): 
    nest = [line]
    nested = 1
    
       
  print(out.rstrip())

print("</pre>")
