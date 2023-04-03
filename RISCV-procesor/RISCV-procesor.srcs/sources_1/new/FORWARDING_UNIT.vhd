----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 09:09:13 PM
-- Design Name: 
-- Module Name: FORWARDING_UNIT - Behavioral
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

entity FORWARDING_UNIT is
 Port ( 
    rs1_address_id_i: in std_logic_vector(4 downto 0);
    rs2_address_id_i: in std_logic_vector(4 downto 0);
    
    rs1_address_ex_i: in std_logic_vector(4 downto 0);
    rs2_address_ex_i: in std_logic_vector(4 downto 0);
    
    rd_we_mem_i: in std_logic;
    rd_address_mem_i: in std_logic_vector(4 downto 0);
    
    rd_we_wb_i: in std_logic;
    rd_address_wb_i: in std_logic_vector(4 downto 0);
    
    alu_forward_a_o: out std_logic_vector(1 downto 0);
    alu_forward_b_o: out std_logic_vector(1 downto 0);
    
    branch_forward_a_o: out std_logic;
    branch_forward_b_o: out std_logic
 );
end FORWARDING_UNIT;

architecture Behavioral of FORWARDING_UNIT is
signal alu_forward_a_s, alu_forward_b_s: std_logic_vector(1 downto 0);
signal branch_forward_a_s, branch_forward_b_s: std_logic;
begin
    --alu_forward_a_s <= "00";
    --alu_forward_b_s <= "00";
    --branch_forward_a_s <= '0';
    --branch_forward_b_s <= '0';

forward_process: process(rs1_address_ex_i, rs2_address_ex_i, rd_we_mem_i, rd_address_mem_i, rd_we_wb_i, rd_address_wb_i)
begin
    if (rd_we_mem_i = '1' and rd_address_mem_i /= "00000") then
        if(rs1_address_ex_i = rd_address_mem_i) then
            alu_forward_a_s <= "10";
        else
            alu_forward_a_s <= "00";
        end if;
        if(rs2_address_ex_i = rd_address_mem_i) then
            alu_forward_b_s <= "10";
        else
            alu_forward_b_s <= "00";
        end if;
    elsif (rd_we_wb_i = '1' and rd_address_wb_i /= "00000") then
        if(rs1_address_ex_i = rd_address_wb_i) then
            alu_forward_a_s <= "01";
        else
            alu_forward_a_s <= "00";
        end if;
        if(rs2_address_ex_i = rd_address_wb_i) then
            alu_forward_b_s <= "01";
        else
            alu_forward_b_s <= "00";
        end if;
    else
        alu_forward_a_s <= "00";  
        alu_forward_b_s <= "00";
    end if;  
end process;

branch_process: process(rs1_address_id_i, rs2_address_id_i, rd_address_mem_i, rd_we_mem_i)
begin
    if (rd_we_mem_i= '1' and rd_address_mem_i /= "00000") then
        if  (rs1_address_id_i = rd_address_mem_i )  then
            branch_forward_a_s <= '1';
        else
            branch_forward_a_s <= '0';
        end if;
        if  (rs2_address_id_i = rd_address_mem_i )  then
            branch_forward_b_s <= '1';
        else
            branch_forward_b_s <= '0';
        end if;
    else
        branch_forward_a_s <= '0';
        branch_forward_b_s <= '0';
    end if;
end process;

    alu_forward_a_o <= alu_forward_a_s;
    alu_forward_b_o <= alu_forward_b_s;
    branch_forward_a_o <= branch_forward_a_s;
    branch_forward_b_o <= branch_forward_b_s;

end Behavioral;
