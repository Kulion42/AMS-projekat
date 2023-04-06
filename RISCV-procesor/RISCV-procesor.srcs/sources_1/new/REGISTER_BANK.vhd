----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 09:49:07 PM
-- Design Name: 
-- Module Name: REGISTER_BANK - Behavioral
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

entity REGISTER_BANK is
 Generic(
    WIDTH: natural := 32
 );
 Port ( 
    clk: in std_logic;
    reset: in std_logic;
    
    rs1_address_i: in std_logic_vector(4 downto 0);
    rs1_data_o: out std_logic_vector(WIDTH-1 downto 0);
    
    rs2_address_i: in std_logic_vector(4 downto 0);
    rs2_data_o: out std_logic_vector(WIDTH-1 downto 0);
    
    rd_we_i: in std_logic;
    rd_address_i: in std_logic_vector(4 downto 0);
    rd_data_i: in std_logic_vector(WIDTH-1 downto 0)
 );
end REGISTER_BANK;

architecture Behavioral of REGISTER_BANK is
     type reg_file_t is array(0 to 31) of std_logic_vector(WIDTH-1 downto 0);
     signal reg_file_s : reg_file_t;
begin
 write_reg_file: process(clk)
    begin
        if falling_edge(clk) then
            if reset = '0' then
                reg_file_s <= (others => (others => '0')); 
            else
                if rd_we_i ='1' then
                    reg_file_s(TO_INTEGER(unsigned(rd_address_i))) <= rd_data_i;
                end if;
            end if;  
        end if;
    end process;
    
    rs1_data_o <= reg_file_s(TO_INTEGER(unsigned(rs1_address_i)));
    rs2_data_o <= reg_file_s(TO_INTEGER(unsigned(rs2_address_i)));

end Behavioral;
