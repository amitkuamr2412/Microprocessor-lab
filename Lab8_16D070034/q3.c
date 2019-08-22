#include <at89c5131.h>
#include <Keypad_Updated.c>

void keypad_init(void);
void transmit_data(unsigned char str);

sbit parity = PSW^0;
bit enable = 0;
bit stop = 0;
unsigned char R = 0x00;
unsigned char read_keypad(void);
void ISR_keypad(void) interrupt 7
{
	P1 = ~P1;
	R = read_keypad();
	if (enable ==1){
		transmit_data(R);
	}
}


void ISR_serial(void) interrupt 4
{
	if(RI == 1){
		RI = 0;
		R = SBUF;
		P1=~P1;
		if (enable == 1){
			if (R == 'N'){
				enable=0;
				return;
			}
		}
		else {
			if (R == 'Y'){
				enable = 1;
			}
		}	
	}
	if(TI == 1) {
		TI = 0;
	}
}
void init_serial()
{
//Initialize serial communication and interrupts
	SCON = 0xD0;
	TH1 = 204;
	TMOD = 0x20;
	TR1 = 1;
	EA = 1;
	ES = 1;
}
unsigned char receive_data(void)
{
//function to receive data over RxD pin.
	return;
}
void transmit_data(unsigned char str)
{
	//function to transmit data over TxD pin.

	ACC = str;
	ACC = ACC + 0;
	TB8 = parity;
	SBUF = ACC;
	//msdelay(500);
}
void transmit_string(char* str, n)
{
	int i;
	for(i=0; i<n; i++){
		transmit_data(&str);
		str++;
	}
//function to transmit string of size n over TxD pin.
}
void main(){
	keypad_init();
	init_serial();
	while(1);
}