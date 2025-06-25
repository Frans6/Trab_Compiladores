#include <stdio.h>
#include <stdlib.h>

// Programa de teste simples que apenas executa o interpretador
int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <arquivo.py>\n", argv[0]);
        return 1;
    }
    
    // Simplesmente executa o interpretador principal
    char comando[512];
    snprintf(comando, sizeof(comando), "./interpretador %s", argv[1]);
    
    int resultado = system(comando);
    
    // Retorna 0 se o interpretador executou com sucesso
    return (resultado == 0) ? 0 : 1;
}