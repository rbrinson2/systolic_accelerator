
#include <iostream>
#include <memory>
#include <vector>
#include "verilated.h"
#include "VTest.h"

int main(int argc, char const *argv[])
{
    char finished = 0;

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
                if (A_m.at(0).empty() && B_m.at(0).empty()) top->finished = 1;
                else {

                    switch (top->A_in_en)
                    {
                    case 1:
                        top->A_in = A_m.at(0).front();
                        if (top->load_out) A_m.at(0).erase(A_m.at(0).begin());
                        break;
                    case 3:
                        top->A_in = A_m.at(0).front();
                        top->A_in_1 = A_m.at(1).front();
                        if (top->load_out){
                            A_m.at(0).erase(A_m.at(0).begin());
                            A_m.at(1).erase(A_m.at(1).begin());
                        }
                        break;
                    
                    case 7:
                        top->A_in = A_m.at(0).front();
                        top->A_in_1 = A_m.at(1).front();
                        top->A_in_2 = A_m.at(2).front();
                        if (top->load_out){
                            A_m.at(0).erase(A_m.at(0).begin());
                            A_m.at(1).erase(A_m.at(1).begin());
                            A_m.at(2).erase(A_m.at(2).begin());
                        }
                        break;
                    default:
                        break;
                    }

                    // top->A_in = A_m.at(0).front();
                    top->B_in = B_m.at(0).front();
                    
                    
                    // top->A_in = A.front();
                    // top->B_in = B.front();

                    if (top->load_out){
                        // A_m.at(0).erase(A_m.at(0).begin());
                        B_m.at(0).erase(B_m.at(0).begin());
                    }
                }

            }
        }

        top->eval();
    }


    top->final();
    return 0;
}

