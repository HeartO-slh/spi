`timescale 1ns/1ns
////////////////////
// Date    : 2025.7.9
// Coder   : HeartO
// Version : V1.0
// Software: Vivado2021.1
////////////////////

module tb_spi_master_tx_mode2;

/////变量/////

    reg      In_clk    ;
    reg      In_rst_n  ;
    reg      In_tx_req ;
    reg [7:0]In_tx_data;

    wire Out_tx_busy ;
    wire Out_spi_cs_n;
    wire Out_spi_sclk;
    wire Out_spi_mosi;

/////变量/////

/////initial/////

    // 时钟
    initial In_clk = 1;
    initial begin
        In_rst_n = 1'b0;
        In_tx_req = 1'b0;
        In_tx_data = 8'h12;
        #201;

        In_rst_n = 1'b1;
        In_tx_req = 1'b1;
        In_tx_data = 8'h12;
        #20;
        @(negedge Out_tx_busy);
        In_tx_req = 1'b0;
        #20;

        In_tx_req = 1'b1;
        In_tx_data = 8'h55;
        #20;
        @(negedge Out_tx_busy);
        In_tx_req = 1'b0;
        #20;

    end

/////initial/////

/////always/////
    always #10 In_clk = ~In_clk;
/////always/////

/////例化/////

    spi_master_tx_mode2#(

        // SPI时钟
        .REF_CLK  (50_000_000),
        .SPI_SCLK (50_000   )

    )u1_spi_master_tx_mode2(

        .In_clk          (In_clk    ),
        .In_rst_n        (In_rst_n  ),
        .In_tx_req       (In_tx_req ),
        .In_tx_data      (In_tx_data),

        .Out_tx_busy     (Out_tx_busy ),
        .Out_spi_cs_n    (Out_spi_cs_n),
        .Out_spi_sclk    (Out_spi_sclk),
        .Out_spi_mosi    (Out_spi_mosi)

    );

/////例化/////

endmodule