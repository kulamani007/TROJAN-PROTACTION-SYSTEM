`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2024 21:18:19
// Design Name: 
// Module Name: Trojan_Protection_System_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Trojan_Protection_System_tb( );
// Inputs
    reg [3:0] a, b;
    reg [1:0] opcode;

    // Outputs
    wire [3:0] result;
    wire mitigation_active;

    // Instantiate the Trojan Protection System
    Trojan_Protection_System uut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .mitigation_active(mitigation_active)
    );

    // Test sequence
    initial begin
        $monitor("Time = %0t | a = %b, b = %b, opcode = %b | result = %b, mitigation_active = %b", 
                 $time, a, b, opcode, result, mitigation_active);

        // Test 1: Normal addition operation
        a = 4'b0011; b = 4'b0101; opcode = 2'b00; // Expected: result = a + b
        #10;

        // Test 2: Normal subtraction operation
        a = 4'b1010; b = 4'b0100; opcode = 2'b01; // Expected: result = a - b
        #10;

        // Test 3: AND operation
        a = 4'b1100; b = 4'b1010; opcode = 2'b10; // Expected: result = a & b
        #10;

        // Test 4: XOR operation without Trojan trigger
        a = 4'b0110; b = 4'b0011; opcode = 2'b11; // Expected: result = a ^ b
        #10;

        // Test 5: XOR operation with Trojan trigger
        a = 4'b1010; b = 4'b0101; opcode = 2'b11; // Expected: result = 4'b0000, Trojan detected
        #10;

        // End simulation
        $finish;
    end
endmodule
