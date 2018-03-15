#ifndef LEITURAS_H
#define LEITURAS_H

typedef struct leituras {
	unsigned long freq;
	double real, imag, arrayR[11], arrayJ[11];
	int hora, minuto, dia, mes, ano;
} leitura;

#endif