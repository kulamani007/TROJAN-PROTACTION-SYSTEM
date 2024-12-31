`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2024 21:14:01
// Design Name: 
// Module Name: Trojan_Protection_System
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


module Trojan_Protection_System (
    input [3:0] a, b,
    input [1:0] opcode,
    output [3:0] result,
    output mitigation_active
);
    wire trojan_detected, detection_flag;

    ALU alu_instance (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .trojan_detected(trojan_detected)
    );

    Trojan_Detector detector_instance (
        .result(result),
        .trojan_detected(trojan_detected),
        .detection_flag(detection_flag)
    );

    Trojan_Mitigator mitigator_instance (
        .detection_flag(detection_flag),
        .mitigation_active(mitigation_active)
    );
endmodule


module ALU (
    input [3:0] a, b,
    input [1:0] opcode,
    output reg [3:0] result,
    output reg trojan_detected
);

    always @(*) begin
        trojan_detected = 0; // Initialize Trojan detection flag
        case (opcode)
            2'b00: result = a + b;   // Addition
            2'b01: result = a - b;   // Subtraction
            2'b10: result = a & b;   // AND operation
            2'b11: begin
                result = a ^ b;       // XOR operation
                // Trojan behavior: Malicious XOR activation
                if (a == 4'b1010 && b == 4'b0101) begin
                    result = 4'b0000; // Unusual output
                    trojan_detected = 1; // Raise detection flag
                end
            end
            default: result = 4'b0000;
        endcase
    end
endmodule


module Trojan_Detector (
    input [3:0] result,
    input trojan_detected,
    output reg detection_flag
);

    always @(*) begin
        if (trojan_detected || result == 4'b0000) begin
            detection_flag = 1; // Trojan detected
        end else begin
            detection_flag = 0; // No Trojan detected
        end
    end
endmodule


module Trojan_Mitigator (
    input detection_flag,
    output reg mitigation_active
);

    always @(*) begin
        if (detection_flag) begin
            mitigation_active = 1; // Activate mitigation
        end else begin
            mitigation_active = 0; // Normal operation
        end
    end
endmodule
