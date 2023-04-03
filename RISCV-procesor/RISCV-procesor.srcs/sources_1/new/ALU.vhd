----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 09:49:07 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.MATH_REAL.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
Generic(
    WIDTH: natural := 32
);
Port (
    a_i: in std_logic_vector(WIDTH-1 downto 0);
    b_i: in std_logic_vector(WIDTH-1 downto 0);
    op_i: in std_logic_vector(3 downto 0);
    res_o: out std_logic_vector(WIDTH-1 downto 0)
    --zero_o: out std_logic;
    --of_o: out std_logic
 );
end ALU;

architecture Behavioral of ALU is
constant var : integer := TO_INTEGER(unsigned(a_i));
signal res_s: std_logic_vector(WIDTH-1 downto 0);
--signal pom0, pom1 : std_logic_vector(var -1 downto 0);
begin

alu_process: process(a_i, b_i, op_i)
begin
--pom0 <= (others => '0');
--pom1 <= (others => '1');
    case op_i is 
        when "0000" =>
            res_s <= std_logic_vector(signed(a_i) + signed(b_i));
        when "0001" => 
            res_s <= std_logic_vector(signed(a_i) - signed(b_i));
        when "0010" =>           
           res_s <=std_logic_vector(signed(b_i) sll var);
        when "0100" =>
            if signed(a_i) > signed(b_i) then
                res_s <= (others => '1');    
            else
                res_s <= (others => '0'); 
            end if;
        when "0110" =>
            if unsigned(a_i) > unsigned(b_i) then
                res_s <= (others => '1');    
            else
                res_s <= (others => '0'); 
            end if;
        when "1000" =>
            res_s <= std_logic_vector(signed(a_i) xor signed(b_i));
        when "1010" =>
            res_s <= std_logic_vector(signed(b_i) srl var);
        when "1011" =>
            res_s <= std_logic_vector(unsigned(b_i) srl var);
        when "1110" =>
            res_s <= std_logic_vector(signed(a_i) and signed(b_i));
        when "1100" =>
            res_s <= std_logic_vector(signed(a_i) or signed(b_i));
        when others =>
            res_s <= not(a_i);      
    end case; 
end process;
res_o <= res_s;
end Behavioral;
