----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2023 02:35:42 PM
-- Design Name: 
-- Module Name: Testbench_RISCV - Behavioral
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
use std.textio.all;
use work.txt_util.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Testbench_RISCV is
--  Port ( );
end Testbench_RISCV;

architecture Behavioral of Testbench_RISCV is
    --Operand za pristup asemblerskom kodu
    file RISCV_instructions : text open read_mode is "C:\Users\ThinkPad T14 Gen3\RISCV-procesor\assembly_code.txt";
    --Globalni signali
    signal clk : std_logic := '0';
    signal reset: std_logic;
    --Signali memorije za instrukcije
    signal ena_instr_s, enb_instr_s : std_logic;
    signal wea_instr_s, web_instr_s: std_logic_vector(3 downto 0);
    signal addra_instr_s, addrb_instr_s: std_logic_vector(9 downto 0);
    signal dina_instr_s, dinb_instr_s: std_logic_vector(31 downto 0);
    signal douta_instr_s, doutb_instr_s: std_logic_vector(31 downto 0);
    signal addrb_instr_32_s : std_logic_vector(31 downto 0);
    --Signali memorije za podatke
    signal ena_data_s, enb_data_s : std_logic;
    signal wea_data_s: std_logic_vector(3 downto 0);
    signal addra_data_s, addrb_data_s: std_logic_vector(9 downto 0);
    signal dina_data_s, dinb_data_s: std_logic_vector(31 downto 0);
    signal douta_data_s, doutb_data_s: std_logic_vector(31 downto 0);
    signal addra_data_32_s : std_logic_vector(31 downto 0);

begin

    --Memorija za instrukcije
    --Pristup A : Koristi se za inicijalizaciju meorije za instrukcije
    --Pristup b : Koristi se za citanje instrukcija od strane procesora
    --Konstante :
    ena_instr_s <= '1';
    enb_instr_s <= '1';
    addrb_instr_s <= addrb_instr_32_s(9 downto 0);
    web_instr_s <= (others => '0');
    dinb_instr_s <= (others => '0');
    --Instanca :
    instruction_mem: entity work.BRAM
    generic map(WADDR => 10)
    port map(
        clk => clk,
        --Pristup A
        en_a_i => ena_instr_s,      
        addr_a_i => addra_instr_s,       
        we_a_i => wea_instr_s,  
        data_a_i => dina_instr_s ,
        data_a_o => douta_instr_s,
        --Pristup B        
        en_b_i => enb_instr_s,
        addr_b_i => addrb_instr_s,
        we_b_i => web_instr_s,
        data_b_i => dinb_instr_s,
        data_b_o => doutb_instr_s       
    );  
    
    --Memorija za podtke
    --Pristup A : Koristi procesor kako bi upisivao i citao podatke
    --Pristup B : Ne koristi se
    --Konstante :
    addra_data_s <= addra_data_32_s(9 downto 0);
    addrb_data_s <= (others => '0');
    dinb_data_s <= (others => '0');
    ena_data_s <= '1';
    enb_data_s <= '1';
    --Instanca :
    data_mem: entity work.BRAM
    generic map(WADDR => 10)
    port map(
        clk => clk,
        --Pristup A
        en_a_i => ena_data_s,      
        addr_a_i => addra_data_s,       
        we_a_i => wea_data_s,  
        data_a_i => dina_data_s ,
        data_a_o => douta_data_s,
        --Pristup B        
        en_b_i => enb_data_s,
        addr_b_i => addrb_data_s,
        we_b_i => (others => '0'),
        data_b_i => dinb_data_s,
        data_b_o => doutb_data_s       
    ); 
-- TOP MODUL -RISCV procesor jezgro
TOP_RISCV_1 : entity work.TOP_RISCV
    port map(
        clk => clk,
        reset => reset,
        
        instr_mem_read_i => doutb_instr_s,
        instr_mem_address_o => addrb_instr_32_s,
        
        data_mem_we_o => wea_data_s,
        data_mem_address_o => addra_data_32_s,
        data_mem_read_i => douta_data_s,
        data_mem_write_o => dina_data_s
    ); 
    
--Inicijalizacija memorije za instrukcije
--Program koji ce procesor izvrsavati se ucitava u memoriju
read_file_proc: process
variable row : line;
variable i : integer := 0;
begin

    reset <= '1';
    wea_instr_s <= (others => '1');
    while (not endfile(RISCV_instructions)) loop
        readline(RISCV_instructions, row);
        addra_instr_s <= std_logic_vector(TO_UNSIGNED(i, 10));
        dina_instr_s <= to_std_logic_vector(string(row));
        i            := i + 4;
        wait until rising_edge(clk);
    end loop;
    wea_instr_s <= (others => '0');
    reset       <= '0' after 20 ns;
    wait;
end process;

--klok signal generator
clk_proc: process
begin
    clk <= '1', '0' after 100ns;
    wait for 200 ns;
end process;

end Behavioral;
