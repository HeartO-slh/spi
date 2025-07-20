////////////////////
// Date    : 2025.7.9
// Coder   : HeartO
// Version : V1.0
// Software: Vivado2021.1
////////////////////
module test_spi_master_tx_mode3#(

    // SPI时钟
    parameter  REF_CLK   = 50_000_000          ,
    parameter  SPI_SCLK  = 500_000              

)(

    input    wire    In_clk    ,
    input    wire    In_rst_n  ,

    output   wire    Out_spi_cs_n ,
    output   wire    Out_spi_sclk ,
    output   wire    Out_spi_mosi 

);

/////变量/////

    // 状态跳转
    reg [1:0]fsm_spi;
    localparam  state1 = 0,
                state2 = 1,
                state3 = 2;
    reg tx_req;

    // 发送数据
    reg [7:0]tx_data;

    // spi_tx
    wire tx_busy;

/////变量/////

/////initial/////

/////initial/////

/////always/////

    // 状态跳转
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            fsm_spi <= state1;
        else begin
            case(fsm_spi)
                state1:begin
                    tx_req <= 1'b1;
                    if((tx_busy == 1'b0)&&(tx_req==1'b1))
                        fsm_spi <= state2;
                    else
                        fsm_spi <= state1;
                end
                state2:begin
                    tx_req <= 1'b0;
                    fsm_spi <= state3;
                end
                state3:begin
                    if(tx_busy == 1'b0)
                        fsm_spi <= state1;
                    else
                        fsm_spi <= state3;
                end
            endcase
        end
    end

    // 发送数据
    always@(posedge In_clk or negedge In_rst_n)begin
        if(In_rst_n == 1'b0)
            tx_data <= 'd0;
        else if((fsm_spi == state3)&&(tx_busy == 1'b0))
            tx_data <= tx_data + 1'b1;
        else
            tx_data <= tx_data;
    end

/////always/////

/////assign/////

/////assign/////

/////例化/////

    // spi_tx
    spi_master_tx_mode3#(

        // SPI时钟
        .REF_CLK (REF_CLK ),
        .SPI_SCLK(SPI_SCLK)

    )u1_spi_master_tx_mode3(

        .In_clk          (In_clk  ),
        .In_rst_n        (In_rst_n),
        .In_tx_req       (tx_req  ),
        .In_tx_data      (tx_data ),

        .Out_tx_busy     (tx_busy     ),
        .Out_spi_cs_n    (Out_spi_cs_n),
        .Out_spi_sclk    (Out_spi_sclk),
        .Out_spi_mosi    (Out_spi_mosi)

    );

/////例化/////

endmodule