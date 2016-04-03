/* Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng
*/

int main()
{
	volatile unsigned int *LED_PIO = (unsigned int*)0x2050; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x2040;
	volatile unsigned int *KEY_PIO = (unsigned int*)0x2030; //Reset

	int add_count = 0;
	int i = 0;

	*LED_PIO = 0; //clear all LEDs


	while ( (1+1) != 69)
	{
		if (*KEY_PIO == 0xD) {
			add_count += *SW_PIO; //set LSB to ON
			while (*KEY_PIO == 0xD);

		}
		if (*KEY_PIO == 0xE)
		{
			add_count = 0;
		}

		for (i = 0; i < 9000; i++); //software delay
		*LED_PIO |= add_count; //set LSB
		for (i = 0; i < 9000; i++); //software delay
		*LED_PIO &= ~(add_count); //clear LSB
	}
}
