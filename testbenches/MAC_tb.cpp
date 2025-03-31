#include <iostream>
#include <memory>
#include "VMAC.h"
#include "verilated.h"

#define OFF 0

uint32_t array_mul(uint32_t a[], uint32_t b[], int size){
    int sum = 0;
    for (int i = 0; i < size; i++){
        sum += a[i] * b[i];
    }

    return sum;
}

int main(int argc, char const *argv[])
{

    uint32_t A[9], B[9], C, C_dut;

    for (int i = 0; i < 9; i++){
        A[i] = i;
        B[i] = sizeof(B) - i;
    }

    C = array_mul(A, B, 9); 


    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext}; 

    contextp->debug(OFF);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);


    const std::unique_ptr<VMAC> mac{new VMAC{contextp.get(), "TOP"}};
    mac->clk = 0;
    mac->rst = 1;
    mac->A_in_waiting = 1;
    mac->B_in_waiting = 1;

    mac->A_in = A[0];
    mac->B_in = B[0];

    int i = 1, j = 0;
    while (contextp->time() < 200){
        contextp->timeInc(1);
        mac->clk = !mac->clk;

        if (contextp->time() > 3){mac->rst = 0;}
        else {
            if (mac->A_in_ready == 1 && mac->B_in_ready == 1) {
                mac->A_in = A[i];
                mac->B_in = B[i];
                i++;
            }
        }

        if (i >= 9){
            mac->A_in_finished = 1;
            mac->B_in_finished = 1;

            C_dut = mac->C_out;
        }

        mac->eval();
    }

    mac->final();


    std::cout << C << std::endl << C_dut << std::endl;

    return 0;
}
