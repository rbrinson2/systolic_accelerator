#include <iostream>
#include <memory>
#include "VMAC.h"
#include "verilated.h"

#define OFF 0

int main(int argc, char const *argv[])
{
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext}; 

    contextp->debug(OFF);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);


    const std::unique_ptr<VMAC> mac{new VMAC{contextp.get(), "TOP"}};

    int i =0;
    while(i < 20){
        mac->eval();

        i++;

    }

    mac->final();


    
    return 0;
}
