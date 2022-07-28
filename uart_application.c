/*Copyright Tishya Sarma Sarkar, Bappaditya Sinha. All Rights Reserved.
This is a simple UART application program developed in Xilinx SDK.*/

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xuartps.h"
#include "xuartlite.h"
#include "xparameters.h"
#include "xgpio.h"
#include "xil_types.h"

#define NUM_OF_BYTE 1

XUartPs_Config *Config_0;
XUartPs Uart_PS_0;
XUartLite_Config *Config_1;
XUartLite UartLite_0;
XGpio Gpio_0;

int main()
{
    init_platform();
    int Status;
	u32 switch_data;
	u8 BufferPtr_tx[1024];
	u8 BufferPtr_rx[1024];
	
	//UARTPS initialization
	Config_0 = XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID);
	if (NULL == Config_0) {
		return XST_FAILURE;
	}
	Status = XUartPs_CfgInitialize(&Uart_PS_0, Config_0, Config_0->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	
	//UARTLite initialization
	Status = XUartLite_Initialize(&UartLite_0, XPAR_UARTLITE_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	
	//GPIO initialization
	Status = XGpio_Initialize(&Gpio_0, XPAR_GPIO_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XGpio_SetDataDirection(&Gpio_0, 1, 0xF);

	while(1){
		switch_data = XGpio_DiscreteRead(&Gpio_0, 1);
		if(switch_data == 0b01){                            //System configured as Transmitter
			Status = 0;
			while (Status<NUM_OF_BYTE) {
				Status +=	XUartPs_Recv(&Uart_PS_0, BufferPtr_tx, (NUM_OF_BYTE-Status));
			}
			XUartLite_Send(&UartLite_0, BufferPtr_tx, Status);
			xil_printf("%s",BufferPtr_tx);
		}
		else if(switch_data == 0b10){                       //System configured as Receiver
			Status = 0;
			while (Status<NUM_OF_BYTE) {
				Status +=	XUartLite_Recv(&UartLite_0, BufferPtr_rx, (NUM_OF_BYTE - Status));
			}
			XUartPs_Send(&Uart_PS_0, BufferPtr_rx, Status);
		}
	}
    cleanup_platform();
    return 0;
}
