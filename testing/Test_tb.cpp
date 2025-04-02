
#include <iostream>
#include <memory>
#include "verilated.h"
#include "VTest.h"

int main(int argc, char const *argv[])
{
    std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

    std::unique_ptr<VTest> top{new VTest{contextp.get(), "TOP"}};
    return 0;
}

