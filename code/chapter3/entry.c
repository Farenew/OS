#include "console.h"

int kern_entry()
{
	console_clear();
	console_write_color("Hello, kernel!\n", rc_white, rc_red);
	return 0;
}