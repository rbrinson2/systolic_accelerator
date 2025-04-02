
#include <iostream>
#include <memory>
#include <vector>
#include "verilated.h"
#include "VTop.h"


int main(int argc, char const *argv[])
{
    std::vector<uint32_t> A_vec = {1,2,3,4,5,6,7,8,9,10};
    std::vector<uint32_t> B_vec_1 = {10,9,8,7,6,5,4,3,2,1};
    std::vector<uint32_t> B_vec_2 = {10,9,8,7,6,5,4,3,2,1};
    uint32_t C_golden = 0;
    uint32_t C_1 = 0;
    uint32_t C_2 = 0;

    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext}; 

    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<VTop> top{new VTop{contextp.get(), "TOP"}};

    // -- Initilize Inputs -- //
    top->clk = 0;
    top->rst = 1;
    top->A_in = 0x00000000;
    top->B_in_11 = 0x00000000;
    top->B_in_12 = 0x00000000;
    top->A_in_waiting = 0;
    top->B_in_waiting_11 = 0;
    top->B_in_waiting_12 = 0;
    top->A_in_finished = 0;
    top->B_in_finished_11 = 0;
    top->B_in_finished_12 = 0;
    top->A_out_ready = 0;
    top->B_out_ready_11 = 0;
    top->B_out_ready_12 = 0;

    // -- TESTBENCH -- //
    while (contextp->time() < 100){
        contextp->timeInc(1);
        top->clk = !top->clk;

        if (top->clk){
            if (contextp->time() >= 0 && contextp->time() < 4)
                top->rst = 1;
            else {
                top->rst = 0;
                top->A_out_ready = 1;
                top->B_out_ready_11 = 1;
                top->B_out_ready_12 = 1;

                if (!A_vec.empty() && !B_vec_1.empty()){
                    top->A_in_waiting = 1;
                    top->B_in_waiting_11 = 1;

                    if (top->A_in_ready && top->B_in_ready_11) {
                        top->A_in = A_vec.front();
                        top->B_in_11 = B_vec_1.front();

                        A_vec.erase(A_vec.begin());
                        B_vec_1.erase(B_vec_1.begin());

                    }

                }
                if (!B_vec_2.empty()) {
                    top->B_in_waiting_12 = 1;

                    if (top->B_in_ready_12) {
                        top->B_in_12 = B_vec_2.front();

                        B_vec_2.erase(B_vec_2.begin());
                    }
                }
            }




            if (A_vec.empty()) top->A_in_finished = 1;
            if (B_vec_1.empty()) top->B_in_finished_11 = 1;
            if (B_vec_2.empty()) top->B_in_finished_12 = 1;


            C_1 = top->C_out_11;
            C_2 = top->C_out_12;
        }

        top->eval();

    }

    top->final();

    std::cout << C_1 << std::endl << C_2 << std::endl << C_golden << std::endl;

    return 0;
}
