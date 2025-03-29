cmake_minimum_required(VERSION 3.20)
cmake_policy(SET CMP0144 NEW)
project(MAC_testbench)

find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if(NOT verilator_FOUND)
    message(
        FATAL_ERROR
        "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable"
    )
endif()


add_executable(MAC ./testbenches/MAC_tb.cpp)
target_compile_features(MAC PUBLIC cxx_std_14)


verilate(MAC 
    INCLUDE_DIRS ./src/
    VERILATOR_ARGS -f ./src/MAC.sv -x-assign fast
    SOURCES MAC.sv
)