----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 09:49:07 PM
-- Design Name: 
-- Module Name: IMMEDIATE - Behavioral
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

entity IMMEDIATE is
 Port ( 
    instruction_i: in std_logic_vector(31 downto 0);
    immidiate_extended_o: out std_logic_vector(31 downto 0)
 );
end IMMEDIATE;

architecture Behavioral of IMMEDIATE is
begin
imm_proc: process(instruction_i)
constant pom1: std_logic_vector(26 downto 0) := (others => '0');
constant pom2: std_logic_vector(26 downto 0) := (others => '1'); 
begin
    immidiate_extended_o <= (others => '0');
        if instruction_i(6 downto 0) = "1100011" then
            if instruction_i(31) = '1' then
                immidiate_extended_o <= pom2(19 downto 0) & instruction_i(31) & instruction_i(7) & instruction_i(30 downto 25) & instruction_i(11 downto 8);
            else
                immidiate_extended_o <= pom1(19 downto 0) & instruction_i(31) & instruction_i(7) & instruction_i(30 downto 25) & instruction_i(11 downto 8);     
            end if;
        elsif  instruction_i(6 downto 0) = "0100011" then
            if instruction_i(31) = '1' then
                immidiate_extended_o <= pom2(19 downto 0) & instruction_i(31 downto 25) & instruction_i(11 downto 7);
            else
                immidiate_extended_o <= pom1(19 downto 0) & instruction_i(31 downto 25) & instruction_i(11 downto 7);     
            end if;
        elsif instruction_i(6 downto 0) = "0000011" then
            if instruction_i(31) = '1' then
                immidiate_extended_o <= pom2(19 downto 0) & instruction_i(31 downto 20);
            else
                immidiate_extended_o <= pom1(19 downto 0) & instruction_i(31 downto 20);     
            end if;   
        elsif instruction_i(6 downto 0) = "0010011" then
           if instruction_i(14 downto 12) = "001" or instruction_i(14 downto 12) = "101" then
                if instruction_i(31) = '1' then
                    immidiate_extended_o <= pom2 & instruction_i(24 downto 20);
                else
                    immidiate_extended_o <= pom1 & instruction_i(24 downto 20);     
                end if;    
            else
                if instruction_i(31) = '1' then
                    immidiate_extended_o <= pom2(19 downto 0) & instruction_i(31 downto 20);
                else
                    immidiate_extended_o <= pom1(19 downto 0) & instruction_i(31 downto 20);     
                end if;                   
           end if; 
       end if;  
end process;
end Behavioral;
