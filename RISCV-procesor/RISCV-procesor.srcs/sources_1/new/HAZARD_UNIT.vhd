----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 09:09:13 PM
-- Design Name: 
-- Module Name: HAZARD_UNIT - Behavioral
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

entity HAZARD_UNIT is
Port (
    rs1_address_id_i: in std_logic_vector(4 downto 0);
    rs2_address_id_i: in std_logic_vector(4 downto 0);
    rs1_in_use_i: in std_logic;
    rs2_in_use_i: in std_logic;
    branch_id_i: in std_logic;
    rd_address_ex_i: in std_logic_vector(4 downto 0);
    mem_to_reg_ex_i: in std_logic;
    rd_we_ex_i: in std_logic;
    rd_address_mem_i: in std_logic_vector(4 downto 0);
    mem_to_reg_mem_i: in std_logic;
    
    pc_en_o: out std_logic;
    
    if_id_en_o: out std_logic;
    
    control_pass_o: out std_logic
 );
end HAZARD_UNIT;

architecture Behavioral of HAZARD_UNIT is
begin
hazard_process: process(rs1_address_id_i, rs2_address_id_i, rs1_in_use_i, rs2_in_use_i, branch_id_i, rd_address_ex_i, mem_to_reg_ex_i, mem_to_reg_mem_i, rd_we_ex_i, rd_address_mem_i)
begin
    if (branch_id_i = '0') then--instrukcija u ID fazi nije skok
        if(((rs1_address_id_i = rd_address_ex_i and rs1_in_use_i = '1') or
        (rs2_address_id_i = rd_address_ex_i and rs2_in_use_i = '1')) and
        mem_to_reg_ex_i = '1' and rd_we_ex_i = '1') then--load instrukcija u EX fazi
            if_id_en_o <= '0';
            pc_en_o <= '0';
            control_pass_o <= '0';
        else
           if_id_en_o <= '1'; 
           pc_en_o <= '1';
           control_pass_o <= '1';
        end if;  
    elsif(branch_id_i = '1') then--instrukcija u ID fazi je uslovni skok 
       if((rs1_address_id_i = rd_address_ex_i or rs2_address_id_i = rd_address_ex_i)
            and rd_we_ex_i = '1') then --load ili R tip u EX fazi
            if_id_en_o <= '0';
            pc_en_o <= '0';
            control_pass_o <= '0';
       elsif((rs1_address_id_i = rd_address_mem_i or rs2_address_id_i = rd_address_mem_i)
            and mem_to_reg_mem_i = '1')then --load u MEM fazi
            if_id_en_o <= '0';
            pc_en_o <= '0';
            control_pass_o <= '0';
       else
            if_id_en_o <= '1';
            pc_en_o <= '1';
            control_pass_o <= '1';
       end if;
    else
        if_id_en_o <= '1';
        pc_en_o <= '1';
        control_pass_o <= '1';
    end if; 
            
end process;
end Behavioral;
