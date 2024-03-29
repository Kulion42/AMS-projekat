----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2023 02:14:14 PM
-- Design Name: 
-- Module Name: BRAM - Behavioral
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

entity BRAM is
Generic (
    WADDR: natural :=10
);
Port ( 
    clk: in std_logic;
    en_a_i: in std_logic;
    en_b_i: in std_logic;
    data_a_i: in std_logic_vector(31 downto 0);
    data_b_i: in std_logic_vector(31 downto 0);
    addr_a_i: in std_logic_vector(WADDR-1 downto 0);
    addr_b_i: in std_logic_vector(WADDR-1 downto 0);
    we_a_i: in std_logic_vector(3 downto 0);
    we_b_i: in std_logic_vector(3 downto 0);
    data_a_o: out std_logic_vector(31 downto 0);
    data_b_o: out std_logic_vector(31 downto 0)
);
end BRAM;

architecture Behavioral of BRAM is
type ram_type is array(0 to 2**WADDR-1) of std_logic_vector(7 downto 0);
signal ram_s: ram_type := (others => (others => '0'));
begin
    --sinhroni upis
    process(clk)
    begin
        if rising_edge(clk) then
            if en_a_i = '1' then
                if we_a_i(3) = '1' then
                    ram_s(TO_INTEGER(unsigned(addr_a_i) +3)) <= data_a_i(31 downto 24);
                end if;
                if we_a_i(2) = '1' then
                    ram_s(TO_INTEGER(unsigned(addr_a_i) +2)) <= data_a_i(23 downto 16);
                end if;
                if we_a_i(1) = '1' then
                    ram_s(TO_INTEGER(unsigned(addr_a_i) +1)) <= data_a_i(15 downto 8);
                end if;
                if we_a_i(0) = '1' then
                    ram_s(TO_INTEGER(unsigned(addr_a_i))) <= data_a_i(7 downto 0);
                end if;
            end if;
            if en_b_i = '1' then
                if we_b_i(3) = '1' then
                    ram_s(TO_INTEGER(unsigned(addr_b_i) +3)) <= data_b_i(31 downto 24);
                end if;
                if we_b_i(2) = '1' then
                    ram_s(TO_INTEGER(unsigned(addr_b_i) +2)) <= data_b_i(23 downto 16);
                end if;
                if we_b_i(1) = '1' then
                    ram_s(TO_INTEGER(unsigned(addr_b_i) +1)) <= data_b_i(15 downto 8);
                end if;
                if we_b_i(0) = '1' then
                    ram_s(TO_INTEGER(unsigned(addr_b_i))) <= data_b_i(7 downto 0);
                end if;
            end if;
        end if;
    end process;
    
    --asinhrono citanje
    process(en_a_i, en_b_i, addr_a_i, addr_b_i, ram_s)
    begin
        if en_a_i = '1' then
            data_a_o(31 downto 24) <= ram_s(TO_INTEGER(unsigned(addr_a_i) + 3));
            data_a_o(23 downto 16) <= ram_s(TO_INTEGER(unsigned(addr_a_i) + 2));
            data_a_o(15 downto 8) <= ram_s(TO_INTEGER(unsigned(addr_a_i) + 1));
            data_a_o(7 downto 0) <= ram_s(TO_INTEGER(unsigned(addr_a_i)));
        end if;
        if en_b_i = '1' then
            data_b_o(31 downto 24) <= ram_s(TO_INTEGER(unsigned(addr_b_i) + 3));
            data_b_o(23 downto 16) <= ram_s(TO_INTEGER(unsigned(addr_b_i) + 2));
            data_b_o(15 downto 8) <= ram_s(TO_INTEGER(unsigned(addr_b_i) + 1));
            data_b_o(7 downto 0) <= ram_s(TO_INTEGER(unsigned(addr_b_i)));
        end if;
    end process;

end Behavioral;
