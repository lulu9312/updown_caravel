// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	
  `endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
 
    /*input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,*/
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    /*input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq*/
);
    reg [3:0] count1;
    reg [31:0] wbs_dat_o;
 always @(posedge wb_clk_i or posedge wb_rst_i)
begin
if(wb_rst_i)
count1<=0;
else begin
if(wb_stb_i)
count1<=count1+1;
else
count1<=count1-1;
end
end

always @(count1)
begin
case(count1)
    4'b0000:wbs_dat_o = 32'b0000001;
	 4'b0001:wbs_dat_o = 32'b1001111;
	 4'b0010:wbs_dat_o = 32'b0010010;
	 4'b0011:wbs_dat_o = 32'b0000110;
	 4'b0100:wbs_dat_o = 32'b1001100;
	 4'b0101:wbs_dat_o = 32'b0100100;
	 4'b0110:wbs_dat_o = 32'b0100000;
	 4'b0111:wbs_dat_o = 32'b0001111;
	 4'b1000:wbs_dat_o = 32'b0000000;
	 4'b1001:wbs_dat_o = 32'b0000100;
	 4'b1010:wbs_dat_o = 32'b0001001;
	 4'b1011:wbs_dat_o = 32'b1100000;
	 4'b1100:wbs_dat_o = 32'b0110001;
	 4'b1101:wbs_dat_o = 32'b0000001;
	 4'b1110:wbs_dat_o = 32'b0110000;
	 4'b1111:wbs_dat_o = 32'b0111000;
	 default:wbs_dat_o = 32'b1111111;
	 endcase
end
endmodule
`default_nettype wire
