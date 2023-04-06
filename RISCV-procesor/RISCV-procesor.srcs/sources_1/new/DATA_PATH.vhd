----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 09:09:13 PM
-- Design Name: 
-- Module Name: DATA_PATH - Behavioral
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

entity DATA_PATH is
 Port ( 
    clk: in std_logic;
    reset: in std_logic;
 
    instr_mem_address_o: out std_logic_vector(31 downto 0);
    instr_mem_read_i : in std_logic_vector(31 downto 0);
    instruction_o: out std_logic_vector(31 downto 0);
    
    data_mem_address_o: out std_logic_vector(31 downto 0);
    data_mem_write_o: out std_logic_vector(31 downto 0);
    data_mem_read_i: in std_logic_vector(31 downto 0);
    
    mem_to_reg_i: in std_logic;
    alu_op_i: in std_logic_vector(3 downto 0);
    alu_src_b_i: in std_logic;
    pc_next_sel_i: in std_logic;
    rd_we_i: in std_logic;
    branch_condition_o: out std_logic;
    
    alu_forward_a_i: in std_logic_vector(1 downto 0);
    alu_forward_b_i: in std_logic_vector(1 downto 0);
    branch_forward_a_i: in std_logic;
    branch_forward_b_i: in std_logic;
    
    if_id_flush_i: in std_logic;
    
    pc_en_i: in std_logic;
    if_id_en_i: in std_logic
 );
end DATA_PATH;

architecture Behavioral of DATA_PATH is
signal pc_mux_o: std_logic_vector(31 downto 0);
signal pc_out, instr_mem_address_s: std_logic_vector(31 downto 0);
signal pc_out_id, rs1_data_id, rs2_data_id, immediate_extended_id, instr_mem_read_id, instr_mem_address_id, mux_ida_o, mux_idb_o: std_logic_vector(31 downto 0);
signal rs1_data_ex, rs2_data_ex, immediate_extended_ex, instr_mem_read_ex, res_o_ex, mux_exa_o, mux_exb_o, mux_src_o: std_logic_vector(31 downto 0);
signal res_o_mem, instr_mem_read_mem: std_logic_vector(31 downto 0);
signal instr_mem_read_wb, res_o_wb, data_mem_read_wb, mux_wb_o: std_logic_vector(31 downto 0);
begin                                            --REGISTRI PROTOCNE OBRADE
--IF/ID REGISTAR                                               
if_id_reg: process(clk)
begin
    if rising_edge(clk) then
      if reset = '0' then
           instr_mem_read_id <= (others => '0');
           pc_out_id <= (others => '0'); 
           --instr_mem_address_s <=  (others => '0');
      else
            if if_id_flush_i = '1' then
                instr_mem_read_id <= (others => '0');
                pc_out_id <= (others => '0');
                --instr_mem_address_s <= instr_mem_address_id; 
            else
                if if_id_en_i = '1' then
                    instr_mem_read_id <= instr_mem_read_i;
                    pc_out_id <= pc_out; 
                    --instr_mem_address_s <= instr_mem_address_id; 
                end if;   
            end if;      
      end if;
    end if; 
end process;

instr_mem_address_s <= instr_mem_address_id;
--ID/EX REGISTAR
id_ex_reg: process(clk)
begin
    if rising_edge(clk) then
        if reset = '0' then
            rs1_data_ex <= (others => '0');
            rs2_data_ex <= (others => '0');
            immediate_extended_ex <= (others => '0');
            instr_mem_read_ex <= (others => '0');
        else
            rs1_data_ex <= rs1_data_id;
            rs2_data_ex <= rs2_data_id;
            immediate_extended_ex <= immediate_extended_id;
            instr_mem_read_ex <= instr_mem_read_id;
        end if; 
   end if;
end process;

 
 --EX/MEM REGISTAR
ex_mem_reg: process(clk)
begin
    if rising_edge(clk) then
        if reset = '0' then
            res_o_mem <= (others => '0');
            data_mem_write_o <= (others => '0');
            instr_mem_read_mem <= (others => '0');       
        else
            res_o_mem <= res_o_ex;
            data_mem_write_o <= rs2_data_ex;
            instr_mem_read_mem <= instr_mem_read_ex;
        end if; 
     end if;
end process;


--MEM/WB REGISTAR
mem_wb_reg: process(clk)
begin
    if rising_edge(clk) then
        if reset = '0' then        
            res_o_wb <= (others => '0');        --mux wb 0
            data_mem_read_wb <= (others => '0');--mux wb 1
            instr_mem_read_wb <= (others => '0');       
        else
            res_o_wb <= res_o_mem ;        --mux wb 0
            data_mem_read_wb <= data_mem_read_i ;--mux wb 1
            instr_mem_read_wb <= instr_mem_read_mem;
        end if;
    end if; 
end process;


                                                  --STRUKTURALNI DIO DATAPHATA
--IF DIO PROTOCNE OBRADE
pc_count: process(clk)
begin  
    if rising_edge(clk) then
        if reset = '0' then
            pc_out <= (others => '0');
        else
          if pc_en_i = '1' then
            pc_out <= pc_mux_o;
          end if;
        end if;  
    end if; 
end process;
mux_pc:
    pc_mux_o <= std_logic_vector(unsigned(pc_out) + 4) when pc_next_sel_i = '0'
    else instr_mem_address_s;
    
    instr_mem_address_id <= std_logic_vector(unsigned((immediate_extended_id) sll 1) + unsigned(pc_out_id));

--ID DIO PROTOCNE OBRADE
reg_bank: entity work.REGISTER_BANK 
    port map(
        clk => clk,
        reset => reset,
        rs1_address_i => instr_mem_read_id(19 downto 15),--
        rs2_address_i => instr_mem_read_id(24 downto 20),--
        rd_we_i => rd_we_i,
        rd_address_i => instr_mem_read_wb(11 downto 7),--
        rd_data_i => mux_wb_o,--
        rs1_data_o => rs1_data_id,-- 
        rs2_data_o => rs2_data_id-- 
    );

immediate: entity work.IMMEDIATE
    port map(
        instruction_i => instr_mem_read_id,
        immidiate_extended_o => immediate_extended_id
    );

muxa_id_a: 
    mux_ida_o <=
        rs1_data_id when branch_forward_a_i ='0' else
        res_o_mem;

muxa_id_b: 
    mux_idb_o <=
        rs2_data_id when branch_forward_b_i ='0' else
        res_o_mem;
comparator: 
    branch_condition_o <= 
        '1' when mux_ida_o = mux_idb_o else
        '0';

--EX DIO PROTOCNE OBRADE

alu_mux_a: 
        mux_exa_o <= rs1_data_ex when alu_forward_a_i = "00" else
        mux_wb_o when alu_forward_a_i = "01" else
        res_o_mem when alu_forward_a_i = "10" else 
        (others => '0');   

alu_mux_b: 
        mux_exb_o <= rs2_data_ex when alu_forward_b_i = "00" else
        mux_wb_o when alu_forward_b_i = "01" else
        res_o_mem when alu_forward_b_i = "10" else 
        (others => '0');
        
mux_src:
    mux_src_o <= mux_exb_o when alu_src_b_i='0' else
                immediate_extended_ex;
--MODELOVANJE ALU
alu: entity work.ALU
    generic map(
        WIDTH => 32
    )
    port map(
        a_i => mux_exa_o,
        b_i => mux_src_o,
        op_i => alu_op_i,
        res_o => res_o_ex
    );

--WB DIO PROTOCNE OBRADE
mux_wb:
    mux_wb_o <= 
        res_o_wb when mem_to_reg_i = '0' else
        data_mem_read_wb;
        
data_mem_address_o <= res_o_mem;        
instr_mem_address_o <= pc_out;
instruction_o <= instr_mem_read_id;
end Behavioral;
