#include <iostream>
#include <memory>
#include <vector>
#include "verilated.h"
#include "VMACV2.h"


int main(int argc, char const *argv[])
{
    std::vector<uint32_t> A_vec = {1,2,3,4,5,6,7,8,9,10};
    std::vector<uint32_t> B_vec = {10,9,8,7,6,5,4,3,2,1};
    uint32_t C_golden = 0;
    uint32_t C = 0;

    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext}; 

    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<VMACV2> mac{new VMACV2{contextp.get(), "TOP"}};

    mac->clk = 0;
    mac->rst = 1;
    mac->A_in = 0x00000000;
    mac->B_in = 0x00000000;
    mac->A_in_finished = 0;
    mac->B_in_finished = 0;

    while (contextp->time() < 100){
        contextp->timeInc(1);
        mac->clk = !mac->clk;

        if (mac->clk){
            if (contextp->time() >= 0 && contextp->time() < 4){
                mac->rst = 1;
            }
            else {
                mac->rst = 0;
                if (!A_vec.empty() && !mac->rst){
                    mac->A_in_waiting = 1;
                    mac->B_in_waiting = 1;
                    if (mac->A_in_ready && mac->B_in_ready){
                        mac->A_in = A_vec.front();
                        mac->B_in = B_vec.front();
                        C_golden += A_vec.front() * B_vec.front();

                        A_vec.erase(A_vec.begin());
                        B_vec.erase(B_vec.begin());
                    }

                }
                else if(A_vec.empty()) {
                    mac->A_in_finished = 1;
                    mac->B_in_finished = 1;
                }
            }
        }
        C = mac->C_out;
        mac->eval();

    }

    mac->final();

    std::cout << C << std::endl << C_golden << std::endl;
    for (auto num : A_vec){
        std::cout << num << std::endl;
    }
    return 0;
}
