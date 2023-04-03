----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 09:49:07 PM
-- Design Name: 
-- Module Name: ALU_DECODER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_DECODER is
 Port ( 
    alu_2bit_op_i: in std_logic_vector(1 downto 0);
    
    funct3_i: in std_logic_vector(2 downto 0);
    funct7_i: in std_logic_vector(6 downto 0);
    
    alu_op_o: out std_logic_vector(3 downto 0)
 );
end ALU_DECODER;

architecture Behavioral of ALU_DECODER is

begin
alu_dec_process: process(alu_2bit_op_i, funct3_i, funct7_i)
begin
    if alu_2bit_op_i = "00" then
        alu_op_o <= "0000";
    elsif alu_2bit_op_i = "01" then
        alu_op_o <= "0001";
    elsif alu_2bit_op_i = "10" then
        case (funct3_i) is
            when "000" =>
                if funct7_i(5)='0' then
                    alu_op_o <= "0000";--ADD
                else
                    alu_op_o <= "0001";--SUB
                end if;
            when "001" =>
                alu_op_o <= "0010";--SLL
            when "010" =>
                alu_op_o <= "0100";--SLT
            when "011" =>
                alu_op_o <= "0110";--SLTU
            when "100" =>
                alu_op_o <= "1000";--XOR
            when "101" =>
                if funct7_i(5)='0' then
                    alu_op_o <= "1010";--SRL
                else
                    alu_op_o <= "1011";--SRA
                end if;
            when "110" =>
                alu_op_o <= "1100";--OR
            when "111" =>
                alu_op_o <= "1110";--AND  
            when others =>  
                alu_op_o <= "1111";   
        end case;
    else
        case (funct3_i) is
            when "000" =>
                    if funct7_i(5)='0' then
                        alu_op_o <= "0000";--ADDI
                    else
                        alu_op_o <= "1111";
                    end if;
             when "001" =>
                alu_op_o <= "0010";--SLLI
             when "010" =>
                alu_op_o <= "0100";--SLTI
             when "011" =>
                alu_op_o <= "0110";--SLTUI
             when "100" =>
                alu_op_o <= "1000";--XOR
             when "101" =>
               if funct7_i(5)='0' then
                    alu_op_o <= "1010";--SRLI
                else
                    alu_op_o <= "1011";--SRAI
                end if;
             when "110" =>
                alu_op_o <= "1100";--ORI
             when "111" =>
                alu_op_o <= "1110";--ANDI
             when others =>
                alu_op_o <= "1111";
       end case;
    end if;
end process;

end Behavioral;
