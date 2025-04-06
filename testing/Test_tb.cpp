
#include <iostream>
#include <memory>
#include <vector>
#include "verilated.h"
#include "VTest.h"

int main(int argc, char const *argv[])
{

    std::vector<uint32_t> A = {1,2, 3, 4, 5, 6, 7, 8, 9, 10};
    std::vector<uint32_t> B = {1,2, 3, 4, 5, 6, 7, 8, 9, 10};

    std::vector<std::vector<uint32_t>> A_m(3, A);
    std::vector<std::vector<uint32_t>> B_m(3, B);

    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext}; 

    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    std::unique_ptr<VTest> top{new VTest{contextp.get(), "TOP"}};
    
    top->clk = 0;
    top->rst = 1;
    
    while (contextp->time() < 100) {
        contextp->timeInc(1);

        top->clk = !top->clk;

        if (top->clk ) {
            if (contextp->time() >= 0 && contextp->time() < 4)
                top->rst = 1;
            else {
                top->rst = 0;

                if (top->load_out){
                    top->A_in = A.front();
                    top->B_in = B.front();

                    A.erase(A.begin());
                    B.erase(B.begin());
                }

            }
        }

        top->eval();
    }


    top->final();
    return 0;
}

