
#include <iostream>
#include <memory>
#include <vector>
#include "verilated.h"
#include "VTest.h"

int main(int argc, char const *argv[])
{

    std::vector<uint32_t> A = {1,2, 3, 4, 5, 6, 7, 8, 9, 10};
    std::vector<uint32_t> B = {1,2, 3, 4, 5, 6, 7, 8, 9, 10};
    std::vector<uint32_t> C_1;
    std::vector<uint32_t> C_2;
    std::vector<uint32_t> C_3;

    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext}; 

    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    std::unique_ptr<VTest> top{new VTest{contextp.get(), "TOP"}};
    
    top->clk = 0;
    top->rst = 1;
    
    while (contextp->time() < 40) {
        contextp->timeInc(1);

        top->clk = !top->clk;

        if (top->clk ) {
            if (contextp->time() >= 0 && contextp->time() < 4)
                top->rst = 1;
            else {
                top->rst = 0;
                top->A_in = A.front();
                top->B_in = B.front();

                A.erase(A.begin());
                B.erase(B.begin());

                C_1.push_back(top->C_out[0]);
                C_2.push_back(top->C_out[1]);
                C_3.push_back(top->C_out[2]);

            }
        }

        top->eval();
    }


    top->final();
    return 0;
}

