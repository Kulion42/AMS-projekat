----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 09:09:13 PM
-- Design Name: 
-- Module Name: CTRL_DECODER - Behavioral
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

entity CTRL_DECODER is
 Port ( 
    opcode_i: in std_logic_vector(6 downto 0);
    
    branch_o: out std_logic;
    mem_to_reg_o: out std_logic;
    data_mem_we_o: out std_logic;
    alu_src_b_o: out std_logic;
    rd_we_o: out std_logic;
    rs1_in_use_o: out std_logic;
    rs2_in_use_o: out std_logic;
    alu_2bit_op_o: out std_logic_vector(1 downto 0)
 );
end CTRL_DECODER;

architecture Behavioral of CTRL_DECODER is

begin
ctrl_decode: process(opcode_i)
begin
    case (opcode_i) is
        when "0110011" =>--R tip instrukcija
            alu_src_b_o <= '0';
            mem_to_reg_o <= '0';
            rd_we_o <= '1';
            data_mem_we_o <= '0';
            branch_o <= '0';
            alu_2bit_op_o <= "10";
            rs1_in_use_o <= '1';
            rs2_in_use_o <= '1';      
        when "0000011" =>--Load instrukcije
            alu_src_b_o <= '1';
            mem_to_reg_o <= '1';
            rd_we_o <= '1';
            data_mem_we_o <= '0';
            branch_o <= '0';
            alu_2bit_op_o <= "00";
            rs1_in_use_o <= '1';
            rs2_in_use_o <= '0'; 
        when "0100011" =>--S tip instrukcija
            alu_src_b_o <= '1';
            mem_to_reg_o <= '0';
            rd_we_o <= '0';
            data_mem_we_o <= '1';
            branch_o <= '0';
            alu_2bit_op_o <= "00";
            rs1_in_use_o <= '1';
            rs2_in_use_o <= '1';  
        when "1100011" =>--B tip instrukcija
            alu_src_b_o <= '0';
            mem_to_reg_o <= '0';
            rd_we_o <= '0';
            data_mem_we_o <= '0';
            branch_o <= '1';
            alu_2bit_op_o <= "01";
            rs1_in_use_o <= '1';
            rs2_in_use_o <= '1'; 
        when "0010011" =>--I tip instrukcija
            alu_src_b_o <= '1';
            mem_to_reg_o <= '0';
            rd_we_o <= '1';
            data_mem_we_o <= '0';
            branch_o <= '0';
            alu_2bit_op_o <= "11";
            rs1_in_use_o <= '1';
            rs2_in_use_o <= '0';
        when others =>
            alu_src_b_o <= '0';
            mem_to_reg_o <= '0';
            rd_we_o <= '0';
            data_mem_we_o <= '0';
            branch_o <= '0';
            alu_2bit_op_o <= "11";
            rs1_in_use_o <= '0';
            rs2_in_use_o <= '0';
    end case;   
end process;  

end Behavioral;
