////////////////////
// Date    : 2025.7.13
// Coder   : HeartO
// Version : V1.1
// Software: Vivado2021.1
////////////////////
module spi_master_tx_mode1#(

    // SPI时钟
    parameter  REF_CLK   = 50_000_000          ,
    parameter  SPI_SCLK  = 50_000              ,
    parameter  DIV_SCLK  = REF_CLK/SPI_SCLK    , // 除的结果为偶数最好，负责sclk会有误差
    parameter  CNT_SCLK  = DIV_SCLK/2          

)(

    input    wire         In_clk    ,
    input    wire         In_rst_n  ,
    input    wire         In_tx_req ,
    input    wire    [7:0]In_tx_data,

    output   reg          Out_tx_busy ,
    output   reg          Out_spi_cs_n,
    output   reg          Out_spi_sclk,
    output   reg          Out_spi_mosi

);

/////变量/////

    // 开始信号
    reg start;

    // 计时
    reg [31:0]cnt_sclk1;
    reg [31:0]cnt_sclk2;

    // num_bit
    reg [3:0]num_bit;

/////变量/////

/////always/////

    // 开始信号
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            start <= 1'b0;
        else if((num_bit == 7)&&(cnt_sclk1 == DIV_SCLK - 1))
            start <= 1'b0;
        else if(In_tx_req == 1'b1)
            start <= 1'b1;
        else
            start <= start;
    end

    // busy
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            Out_tx_busy <= 1'b0;
        else if((num_bit == 7)&&(cnt_sclk1 == DIV_SCLK - 1))
            Out_tx_busy <= 1'b0;
        else if(In_tx_req == 1'b1)
            Out_tx_busy <= 1'b1;
        else
            Out_tx_busy <= Out_tx_busy;
    end

    // CS_N
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            Out_spi_cs_n <= 1'b1;
        else if((num_bit == 7)&&(cnt_sclk1 == DIV_SCLK - 1))
            Out_spi_cs_n <= 1'b1;
        else if(In_tx_req == 1'b1)
            Out_spi_cs_n <= 1'b0;
        else
            Out_spi_cs_n <= Out_spi_cs_n;
    end

    // 计时
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            cnt_sclk1 <= 'd0;
        else if(start == 1'b1)begin
            if(cnt_sclk1 == DIV_SCLK - 1)
                cnt_sclk1 <= 'd0;
            else
                cnt_sclk1 <= cnt_sclk1 + 1'b1;
        end
        else
            cnt_sclk1 <= 'd0;
    end

    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            cnt_sclk2 <= 'd0;
        else if(start == 1'b1)begin
            if(cnt_sclk2 == CNT_SCLK - 1)
                cnt_sclk2 <= 'd0;
            else
                cnt_sclk2 <= cnt_sclk2 + 1'b1;
        end
        else
            cnt_sclk2 <= 'd0;
    end

    // sclk
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            Out_spi_sclk <= 1'b0;
        else if((start == 1'b1))begin
            if((cnt_sclk2 == 0)&&(num_bit<=7))
                Out_spi_sclk <= ~Out_spi_sclk;
            else
                Out_spi_sclk <= Out_spi_sclk;
        end
        else
            Out_spi_sclk <= 1'b0;
    end

    // num_bit
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            num_bit <= 'd0;
        else if(start == 1'b1)begin
            if((num_bit == 7)&&(cnt_sclk1 == DIV_SCLK - 1))
                num_bit <= 'd0;
            else if(cnt_sclk1 == DIV_SCLK - 1)
                num_bit <= num_bit + 1'b1;
            else
                num_bit <= num_bit;
        end
        else
            num_bit <= num_bit;
    end

    // mosi
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            Out_spi_mosi <= 1'bx;
        else if(start==1'b1)begin
            if(cnt_sclk2 == 0)begin
                case(num_bit)
                    0:Out_spi_mosi <= In_tx_data[7];
                    1:Out_spi_mosi <= In_tx_data[6];
                    2:Out_spi_mosi <= In_tx_data[5];
                    3:Out_spi_mosi <= In_tx_data[4];
                    4:Out_spi_mosi <= In_tx_data[3];
                    5:Out_spi_mosi <= In_tx_data[2];
                    6:Out_spi_mosi <= In_tx_data[1];
                    7:Out_spi_mosi <= In_tx_data[0];
                endcase
            end
            else
                Out_spi_mosi <= Out_spi_mosi;
        end
        else
            Out_spi_mosi <= 1'bx;
    end

/////always/////

/////assign/////

/////assign/////

/////例化/////

/////例化/////

endmodule