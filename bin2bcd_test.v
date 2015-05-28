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
//          bin2bcd_test.v: Test  circuit for  the binary to BCD circuit          //
//                          Using DE2-115 Development board / Cyclone IV          //
//                                                                                //
// Ameer M.S. Abdelhadi (ameer@ece.ubc.ca; ameer.abdelhadi@gmail.com), Sept. 2012 //
////////////////////////////////////////////////////////////////////////////////////

module bin2bcd_test(
  input  [17:0] SW  , // switches
  output [6 :0] HEX0, // 7-segment #0
  output [6 :0] HEX1, // 7-segment #1
  output [6 :0] HEX2, // 7-segment #2
  output [6 :0] HEX3, // 7-segment #3
  output [6 :0] HEX4, // 7-segment #4
  output [6 :0] HEX5, // 7-segment #5
  output [6 :0] HEX6, // 7-segment #6
  output [6 :0] HEX7  // 7-segment #7
);

  wire [22:0] bcd;
  bin2bcd #(18) bin2bcd_00 (SW,bcd);
  bcd7seg bcd7seg_00 (      bcd[3 :0 ] ,HEX0);
  bcd7seg bcd7seg_01 (      bcd[7 :4 ] ,HEX1);
  bcd7seg bcd7seg_02 (      bcd[11:8 ] ,HEX2); 
  bcd7seg bcd7seg_03 (      bcd[15:12] ,HEX3);
  bcd7seg bcd7seg_04 (      bcd[19:16] ,HEX4);
  bcd7seg bcd7seg_05 ({1'b0,bcd[22:20]},HEX5);
  assign {HEX6,HEX7}={14{1'bz}};

endmodule
