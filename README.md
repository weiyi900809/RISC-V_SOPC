# tinyriscv on ZedBoard with CRC32 Peripheral

將開源 RV32IM 軟核移植至 ZedBoard，並整合自訂 CRC32 硬體周邊。

## 1. 專案介紹

本專案以開源 RISC-V 處理器 tinyriscv 為基礎，將其移植至 Avnet ZedBoard（Xilinx Zynq-7020），建立可執行 C 程式的 RV32IM SoC，並透過原生 RIB bus 整合自行設計的 CRC32 peripheral。

專案重點包含 FPGA 平台移植、板級訊號整合、RIB bus 擴充，以及 CRC32 硬體模組與 C driver 的軟硬體整合，串接從 RTL 設計到 firmware 呼叫的完整流程。

本專案為國立中興大學「SoC Design／系統晶片設計」課程期末專題。

## 2. 專案目標

- 將 tinyriscv RV32IM SoC 移植至 ZedBoard 的 Programmable Logic（PL）。
- 設計 board-level wrapper，處理時脈、reset 與板上 I/O 對應。
- 建立 UART firmware 載入與 C 程式執行流程。
- 設計自訂 CRC32 peripheral，並整合至 RIB bus。
- 提供 CRC32 的 C driver，讓 CPU 透過記憶體映射介面操作硬體周邊。
- 比對硬體 CRC32 與軟體參考結果，驗證功能正確性。

## 3. 系統架構

### tinyriscv SoC

CPU 採用 RV32IM 指令集與三級管線架構（IF → ID → EX），透過原生 RIB bus 連接 ROM、RAM、Timer、UART 與 GPIO。

本專案在既有架構上新增 CRC32 peripheral，並擴充對應的位址解碼與周邊連接，使 CPU 能透過記憶體映射暫存器存取 CRC32 模組。

### ZedBoard 平台整合

透過 `zedboard_top.v` 串接 tinyriscv SoC 與 ZedBoard 硬體資源，主要處理：

- 板上時脈與 SoC 時脈整合。
- Reset 極性與訊號連接。
- UART、GPIO 與 LED 等 I/O 對應。
- XDC 腳位設定與時序約束。

### CRC32 Peripheral

CRC32 為本專案新增的自訂硬體周邊，透過 RIB slave 介面接入 SoC。

CPU 端由 C driver 將待運算資料寫入 CRC32 peripheral，並讀回計算結果，再與軟體參考結果進行比對。此設計展示自訂 RTL 模組、bus interconnect 與 firmware 之間的整合流程。

```text
ZedBoard Programmable Logic
│
├── Board-Level Wrapper
│   ├── Clock / Reset
│   └── Board I/O Mapping
│
└── tinyriscv SoC
    ├── RV32IM CPU
    │   └── IF → ID → EX
    │
    └── RIB Bus Interconnect
        ├── ROM
        ├── RAM
        ├── Timer
        ├── UART
        ├── GPIO
        └── CRC32 Peripheral
            ├── RIB Slave Interface
            ├── Memory-Mapped Registers
            └── CRC32 Computation Logic
```

