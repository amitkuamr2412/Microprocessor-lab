#include <AT89C5131.h> // All SFR declarations for AT89C5131

sbit led = P1^7; //assigning label to P1^4 as "led"
sbit Parity = PSW^0;


void ISR_Serial(void) interrupt 4 {
	TI = 0;
	led = ~led; 
	SBUF = 0x41;  
}
	
void init_serial() {
	TMOD = 0x20;       // mode 2 00010000B
	TH1 = 0xCC;     // 204 needed for 1200 baud rate 
	SCON = SCON || 0xC0 ; // Enables SM0 and SM1

	// setting interrupts
	ES = 1;       // controls serial port interupt
	ET1 = 0;       // cleared to disable timer 1 overflow interupt

	ACC =  0x41;   // 
	ACC += 0x00;
	TB8 = Parity;   
	EA = 1;        // Enable any interupt
	SBUF = 0x41;

	TR1 = 1; // Start timer 1
}

void main (void) {
	led = 0;
	init_serial();
	while(1);
}

