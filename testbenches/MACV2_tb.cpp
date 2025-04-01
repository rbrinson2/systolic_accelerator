#include <iostream>
#include <memory>
#include <vector>
#include "verilated.h"
#include "VMACV2.h"

#define BUFFER_SIZE 4

int main(int argc, char const *argv[])
{
    std::vector<uint32_t> A_vec = {7,8,9,10};
    std::vector<uint32_t> B_vec = {10,9,8,7};
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

    int i = 0;
    while (contextp->time() < 20){
        contextp->timeInc(1);
        mac->clk = !mac->clk;

        if (mac->clk){
            if (contextp->time() >= 0 && contextp->time() < 4){
                mac->rst = 1;
                i = 0;
            }
            else {
                mac->rst = 0;
                if (i < A_vec.size() && !mac->rst){
                    mac->A_in = A_vec.at(i);
                    mac->B_in = B_vec.at(i);

                    C_golden += A_vec.at(i) * B_vec.at(i);
                }
                else if (i >= A_vec.size()){
                    mac->A_in_finished = 1;
                    mac->B_in_finished = 1;
                }
                i++;
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
