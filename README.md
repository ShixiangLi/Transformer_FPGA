### ./verilog/ip_res 是AXI-LITE IP核

# Transformer_FPGA
Transformer FPGA Accelerator

## Introduction
基于Xilinx Vivado实现一个二值化Transformer加速器
目前只是纯实现，卷积操作实现位宽并行化，整体网络计算未实现

## Network Architecture
普通的Transformer去掉Decoder，小BERT

## Document Structure

  |---verilog

    |-ip_repo（AXI-LITE）

    |-param_1（coe权重文件）

    |-sim_1

      |-new（仿真文件）

    |-source_1

      |-new（各模块实现文件）
