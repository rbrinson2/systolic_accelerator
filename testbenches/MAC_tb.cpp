#include <iostream>
#include <memory>
#include "VMAC.h"
#include "verilated.h"

#define OFF 0

int main(int argc, char const *argv[])
{
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext}; 

    contextp->debug(OFF);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);


    const std::unique_ptr<VMAC> mac{new VMAC{contextp.get(), "TOP"}};


    mac->rst = 1;
    mac->clk = 0;
    mac->A_in = 0x00000000;
    mac->B_in = 0x00000000;

    int i =0;
    while(i < 20){
        contextp->timeInc(1);
        mac->clk = !mac->clk;

        if(i > 3){
            mac->rst = 0;
        }

        mac->A_in += i;
        mac->B_in += i;

        mac->eval();

        VL_PRINTF("clk=%x, rst=%x, A_in=%x, B_in=%x, C_out=%x \n", mac->clk, mac->rst, mac->A_in, mac->B_in, mac->C_out);

        i++;

    }

    mac->final();


    
    return 0;
}
