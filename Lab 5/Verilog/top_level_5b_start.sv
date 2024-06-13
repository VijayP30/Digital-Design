// ECE260C -- lab 5 alternative DUT
// Applies done flag when cycle_ct = 255
module top_level_5b(
    input          clk, init, 
    output logic   done
);

// Memory interface
logic          wr_en;
logic    [7:0] raddr, waddr, data_in;
logic    [7:0] data_out;

// Program counter
logic[15:0] cycle_ct = 0;

// LFSR interface
logic load_LFSR, LFSR_en;
logic[5:0] LFSR_ptrn [5:0] = '{6'h21, 6'h2D, 6'h30, 6'h33, 6'h36, 6'h39};
logic[5:0] start, LFSR_state [5:0], match;
logic[2:0] foundit;
int i;
logic[4:0] preamble_ctr = 0;
logic preamble_done = 0;

// Instantiate submodules
dat_mem dm1(
    .clk(clk),
    .write_en(wr_en),
    .raddr(raddr),
    .waddr(waddr),
    .data_in(data_in),
    .data_out(data_out)
);

genvar idx;
generate
    for (idx = 0; idx < 6; idx++) begin : lfsr_gen
        lfsr6b lfsr_inst (
            .clk(clk),
            .en(LFSR_en),
            .init(load_LFSR),
            .taps(LFSR_ptrn[idx]),
            .start(start),
            .state(LFSR_state[idx])
        );
    end
endgenerate

// Priority encoder
always_comb begin
    case (match)
        6'b10_0000: foundit = 5;
        6'b01_0000: foundit = 4;
        6'b00_1000: foundit = 3;
        6'b00_0100: foundit = 2;
        6'b00_0010: foundit = 1;
        default: foundit = 0;
    endcase
end

// Program counter
always @(posedge clk) begin
    if (init) begin
        cycle_ct <= 0;
        match <= 0;
        preamble_ctr <= 0;
        preamble_done <= 0;
    end else begin
        cycle_ct <= cycle_ct + 1;
        if (cycle_ct == 7) begin
            for (i = 0; i < 6; i++) begin
                if (LFSR_state[i] == (6'h1f ^ data_out[5:0])) match[i] <= 1;
            end
        end
        if (cycle_ct > 8 && cycle_ct < 14) begin
            if (!preamble_done && data_in[5:0] == 6'h5f)
                preamble_ctr <= preamble_ctr + 1;
            else if (!preamble_done && data_in[5:0] != 6'h5f)
                preamble_done <= 1;
        end
    end
end

always_comb begin
    // Defaults
    load_LFSR = 0; 
    LFSR_en   = 0;   
    wr_en     = 0;
    case (cycle_ct)
        0: begin 
            raddr = 64;   
            waddr = 0;   
            start = 6'h1f ^ data_out[5:0];
        end
        1: begin 
            load_LFSR = 1;
            raddr = 64;
            waddr = 0;
        end
        2: begin
            LFSR_en = 1;     
            raddr = 64;
            waddr = 0;
        end
        3: begin
            LFSR_en = 1;
            raddr = 65;
            waddr = 0;
        end
        72: begin
            done = 1;
            raddr = 65;
            waddr = 0; 
        end
        default: begin
            LFSR_en = 1;
            raddr = cycle_ct + 62;
            if (cycle_ct > 8) begin
                wr_en = 1;
                waddr = cycle_ct - preamble_ctr - 9; 
            end else begin
                waddr = 0;
                wr_en = 0;
            end
            data_in = data_out ^ LFSR_state[foundit];
        end
    endcase
end

endmodule
