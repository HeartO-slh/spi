`timescale 1ns/1ns
////////////////////
// Date    : 2025.7.9
// Coder   : HeartO
// Version : V1.0
// Software: Vivado2021.1
////////////////////

module tb_test_spi_master_tx_mode2;

/////变量/////

    reg      In_clk    ;
    reg      In_rst_n  ;

    wire Out_spi_cs_n;
    wire Out_spi_sclk;
    wire Out_spi_mosi;

/////变量/////

/////initial/////

    // 时钟
    initial In_clk = 1;
    initial begin
        In_rst_n = 1'b0;
        #201;

        In_rst_n = 1'b1;
        #20;

    end

/////initial/////

/////always/////
    always #10 In_clk = ~In_clk;
/////always/////

/////例化/////

    test_spi_master_tx_mode2#(

        // SPI时钟
        .REF_CLK  (50_000_000),
        .SPI_SCLK (50_000    )
    )u1_test_spi_master_tx_mode2(

        .In_clk    (In_clk  ),
        .In_rst_n  (In_rst_n),

        .Out_spi_cs_n (Out_spi_cs_n),
        .Out_spi_sclk (Out_spi_sclk),
        .Out_spi_mosi (Out_spi_mosi)

    );

/////例化/////

endmodule