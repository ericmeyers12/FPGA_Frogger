//io_handler.c
#include "io_handler.h"
#include <stdio.h>
#include "alt_types.h"
#include "system.h"

#define otg_hpi_address		(volatile int*) 	0x50
#define otg_hpi_data		(volatile int*)	    0x40
#define otg_hpi_r			(volatile char*)	0x30
#define otg_hpi_cs			(volatile char*)	0x60 //FOR SOME REASON CS BASE BEHAVES WEIRDLY MIGHT HAVE TO SET MANUALLY
#define otg_hpi_w			(volatile char*)	0x20


void IO_init(void)
{
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	*otg_hpi_address = Address;
	*otg_hpi_cs = 0;
	*otg_hpi_w = 0;
	*otg_hpi_data = Data;
	*otg_hpi_w = 1;
	*otg_hpi_cs = 1;


	//printf("writing to %x\n", (int) otg_hpi_address+Address);
}

alt_u16 IO_read(alt_u8 Address)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	//printf("%x\n",temp);
	//printf("reading from %x\n", (int) otg_hpi_address+Address);
	*otg_hpi_address = Address;
	*otg_hpi_cs = 0;
	*otg_hpi_r = 0;
	alt_u16 temp = *otg_hpi_data;
	*otg_hpi_r = 1;
	*otg_hpi_cs = 1;

	return temp;
}
