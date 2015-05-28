////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012, Ameer M. Abdelhadi; ameer@ece.ubc.ca. All rights reserved. //
//                                                                                //
// Redistribution  and  use  in  source   and  binary  forms,   with  or  without //
// modification,  are permitted  provided that  the following conditions are met: //
//   * Redistributions   of  source   code  must  retain   the   above  copyright //
//     notice,  this   list   of   conditions   and   the  following  disclaimer. //
//   * Redistributions  in  binary  form  must  reproduce  the  above   copyright //
//     notice, this  list  of  conditions  and the  following  disclaimer in  the //
//     documentation and/or  other  materials  provided  with  the  distribution. //
//   * Neither the name of the University of British Columbia (UBC) nor the names //
//     of   its   contributors  may  be  used  to  endorse  or   promote products //
//     derived from  this  software without  specific  prior  written permission. //
//                                                                                //
// THIS  SOFTWARE IS  PROVIDED  BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" //
// AND  ANY EXPRESS  OR IMPLIED WARRANTIES,  INCLUDING,  BUT NOT LIMITED TO,  THE //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE //
// DISCLAIMED.  IN NO  EVENT SHALL University of British Columbia (UBC) BE LIABLE //
// FOR ANY DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL //
// DAMAGES  (INCLUDING,  BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR //
// SERVICES;  LOSS OF USE,  DATA,  OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER //
// CAUSED AND ON ANY THEORY OF LIABILITY,  WHETHER IN CONTRACT, STRICT LIABILITY, //
// OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE //
// OF  THIS SOFTWARE,  EVEN  IF  ADVISED  OF  THE  POSSIBILITY  OF  SUCH  DAMAGE. //
////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
//                 bin2bcd.v:  Parametric  Binary to BCD Converter                // 
//                 Using Double Dabble / Shift and Add 3 Algorithm                //
//                                                                                //
// Ameer M.S. Abdelhadi (ameer@ece.ubc.ca; ameer.abdelhadi@gmail.com), Sept. 2012 //
////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
//                                 18-bit Example                                 //
//                                                                                //
//                     B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B       //
//                     I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I       //
//                     N  N  N  N  N  N  N  N  N  N  N  N  N  N  N  N  N  N       //
//                     1  1  1  1  1  1  1  1  9  8  7  6  5  4  3  2  1  0       //
//     '0 '0 '0 '0 '0  7  6  5  4  3  2  1  0  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  V__V__V__V  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  | /IF>4THEN+3\ |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  | \__________/ |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  V__V__V__V  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  | /IF>4THEN+3\ |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  | \__________/ |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  V__V__V__V  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  | /IF>4THEN+3\ |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  | \__________/ |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  V__V__V__V  V__V__V__V  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  | /IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  | \__________/\__________/ |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  V__V__V__V  V__V__V__V  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  | /IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  | \__________/\__________/ |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  V__V__V__V  V__V__V__V  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  | /IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  | \__________/\__________/ |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  V__V__V__V  V__V__V__V  V__V__V__V  |  |  |  |  |  |  |  |  |       //
//      |  | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |  |  |  |  |       //
//      |  | \__________/\__________/\__________/ |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  V__V__V__V  V__V__V__V  V__V__V__V  |  |  |  |  |  |  |  |       //
//      |  |  | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |  |  |  |       //
//      |  |  | \__________/\__________/\__________/ |  |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  |  V__V__V__V  V__V__V__V  V__V__V__V  |  |  |  |  |  |  |       //
//      |  |  |  | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |  |  |       //
//      |  |  |  | \__________/\__________/\__________/ |  |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  |  |  |  |  |  |       //
//      | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |  |       //
//      | \__________/\__________/\__________/\__________/ |  |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  |  |  |  |  |       //
//      |  | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |       //
//      |  | \__________/\__________/\__________/\__________/ |  |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  |  V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  |  |  |  |       //
//      |  |  | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |  |  |       //
//      |  |  | \__________/\__________/\__________/\__________/ |  |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  |  |  |       //
//     /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |  |       //
//     \__________/\__________/\__________/\__________/\__________/ |  |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  |  |       //
//      | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |       //
//      | \__________/\__________/\__________/\__________/\__________/ |  |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      |  |  V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  V__V__V__V  |       //
//      |  | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |       //
//      |  | \__________/\__________/\__________/\__________/\__________/ |       //
//      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |       //
//      B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B       //
//      C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C       //
//      D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D       //
//      2  2  2  1  1  1  1  1  1  1  1  1  1  9  8  7  6  5  4  3  2  1  0       //
//      2  1  0  9  8  7  6  5  4  3  2  1  0                                     //
//     \_______/\__________/\__________/\__________/\__________/\__________/      //
//     100,000's  10,000's     1000's      100's        10's         1's          //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////

module bin2bcd
 #( parameter                W = 18)  // input width
  ( input      [W-1      :0] bin   ,  // binary
    output reg [W+(W-4)/3:0] bcd   ); // bcd {...,thousands,hundreds,tens,ones}

  integer i,j;

  always @(bin) begin
    for(i = 0; i <= W+(W-4)/3; i = i+1) bcd[i] = 0;     // initialize with zeros
    bcd[W-1:0] = bin;                                   // initialize with input vector
    for(i = 0; i <= W-4; i = i+1)                       // iterate on structure depth
      for(j = 0; j <= i/3; j = j+1)                     // iterate on structure width
        if (bcd[W-i+4*j -: 4] > 4)                      // if > 4
          bcd[W-i+4*j -: 4] = bcd[W-i+4*j -: 4] + 4'd3; // add 3
  end

endmodule
