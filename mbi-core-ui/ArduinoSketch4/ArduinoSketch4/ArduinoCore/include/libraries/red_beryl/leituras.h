#ifndef LEITURAS_H
#define LEITURAS_H

typedef struct leituras {
	unsigned long freq;
	double real, imag;
	double arrayR[11], arrayJ[11];
	int hora, minuto, dia, mes, ano;
	//float gain;
	//float arrayG[11]; //array especifico contendo o fator de ganho da leitura.
} leitura;

#endif