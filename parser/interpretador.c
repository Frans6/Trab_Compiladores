#include "interpretador.h"
#include "types.h"
#include "tabela.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

extern void yyerror(const char* s);

// --- Declarações Antecipadas ---
static Resultado interpretar_no(NoAst* no, TabelaSimbolos* tabela);
static Resultado avaliar_expressao(NoAst* no, TabelaSimbolos* tabela);
static Resultado interpretar_bloco(BlocoDeclaracoes* bloco, TabelaSimbolos* tabela);

// --- Funções Auxiliares ---
static Resultado criar_resultado_vazio() {
    Resultado res;
    res.tipo = TIPO_NULO;
    res.is_break = false;
    res.is_continue = false;
    return res;
}

static bool verificar_verdade(Resultado res) {
    switch(res.tipo) {
        case TIPO_INT: return res.valor.int_val != 0;
        case TIPO_FLOAT: return res.valor.float_val != 0.0;
        case TIPO_BOOL: return res.valor.bool_val;
        case TIPO_STRING: return strlen(res.valor.string_val) > 0;
        default: return false;
    }
}

// --- Lógica Principal ---
static Resultado avaliar_expressao(NoAst* no, TabelaSimbolos* tabela) {
    if (no == NULL) return criar_resultado_vazio();
    
    switch (no->tipo) {
        case NODO_VALOR: {
            Resultado res = criar_resultado_vazio();
            res.tipo = no->dados.literal.tipo;
            switch (res.tipo) {
                case TIPO_INT: res.valor.int_val = no->dados.literal.valor.int_val; break;
                case TIPO_FLOAT: res.valor.float_val = no->dados.literal.valor.float_val; break;
                case TIPO_BOOL: res.valor.bool_val = no->dados.literal.valor.bool_val; break;
                case TIPO_STRING: res.valor.string_val = no->dados.literal.valor.string_val; break;
                default: break;
            }
            return res;
        }
        
        case NODO_IDENTIFICADOR: {
            Simbolo* s = buscar_simbolo(tabela, no->dados.identificador);
            if (!s) {
                fprintf(stderr, "[ERRO] (linha %d): Variável '%s' não definida\n", no->linha, no->dados.identificador);
                exit(1);
            }
            Resultado resultado = criar_resultado_vazio();
            resultado.tipo = s->tipo;
            if(s->valor) {
                switch(resultado.tipo) {
                    case TIPO_INT: resultado.valor.int_val = *(int*)s->valor; break;
                    case TIPO_FLOAT: resultado.valor.float_val = *(double*)s->valor; break;
                    case TIPO_BOOL: resultado.valor.bool_val = *(bool*)s->valor; break;
                    case TIPO_STRING: resultado.valor.string_val = *(char**)s->valor; break;
                    default: break;
                }
            }
            return resultado;
        }
        
        case NODO_OPERACAO: {
            Resultado esq = avaliar_expressao(no->dados.operacao.esquerda, tabela);
            
            // operador NOT
            if (no->dados.operacao.operador == NAO_LOGICO) {
                Resultado res = criar_resultado_vazio(); 
                res.tipo = TIPO_BOOL;
                res.valor.bool_val = !verificar_verdade(esq); 
                return res;
            }
            
            Resultado dir = avaliar_expressao(no->dados.operacao.direita, tabela);
            Resultado res = criar_resultado_vazio();
            
            // Operadores lógicos
            if (no->dados.operacao.operador == E_LOGICO) {
                res.tipo = TIPO_BOOL; 
                res.valor.bool_val = verificar_verdade(esq) && verificar_verdade(dir);
                return res;
            } else if (no->dados.operacao.operador == OU_LOGICO) {
                res.tipo = TIPO_BOOL; 
                res.valor.bool_val = verificar_verdade(esq) || verificar_verdade(dir);
                return res;
            }
            
            // Operadores de comparação
            if (no->dados.operacao.operador == IGUAL || 
                no->dados.operacao.operador == DIFERENTE ||
                no->dados.operacao.operador == MAIOR ||
                no->dados.operacao.operador == MENOR ||
                no->dados.operacao.operador == MAIOR_IGUAL ||
                no->dados.operacao.operador == MENOR_IGUAL) {
                
                res.tipo = TIPO_BOOL;
                double val_esq, val_dir;
                
                // Converter para double para comparação
                if (esq.tipo == TIPO_INT) val_esq = (double)esq.valor.int_val;
                else if (esq.tipo == TIPO_FLOAT) val_esq = esq.valor.float_val;
                else if (esq.tipo == TIPO_BOOL) val_esq = esq.valor.bool_val ? 1.0 : 0.0;
                else val_esq = 0.0;
                
                if (dir.tipo == TIPO_INT) val_dir = (double)dir.valor.int_val;
                else if (dir.tipo == TIPO_FLOAT) val_dir = dir.valor.float_val;
                else if (dir.tipo == TIPO_BOOL) val_dir = dir.valor.bool_val ? 1.0 : 0.0;
                else val_dir = 0.0;
                
                switch(no->dados.operacao.operador) {
                    case IGUAL: res.valor.bool_val = val_esq == val_dir; break;
                    case DIFERENTE: res.valor.bool_val = val_esq != val_dir; break;
                    case MAIOR: res.valor.bool_val = val_esq > val_dir; break;
                    case MENOR: res.valor.bool_val = val_esq < val_dir; break;
                    case MAIOR_IGUAL: res.valor.bool_val = val_esq >= val_dir; break;
                    case MENOR_IGUAL: res.valor.bool_val = val_esq <= val_dir; break;
                    default: break;
                }
                return res;
            }
            
            // Operadores aritméticos
            double val_esq, val_dir;
            
            // Converter para double para operações aritméticas
            if (esq.tipo == TIPO_INT) val_esq = (double)esq.valor.int_val;
            else if (esq.tipo == TIPO_FLOAT) val_esq = esq.valor.float_val;
            else if (esq.tipo == TIPO_BOOL) val_esq = esq.valor.bool_val ? 1.0 : 0.0;
            else val_esq = 0.0;
            
            if (dir.tipo == TIPO_INT) val_dir = (double)dir.valor.int_val;
            else if (dir.tipo == TIPO_FLOAT) val_dir = dir.valor.float_val;
            else if (dir.tipo == TIPO_BOOL) val_dir = dir.valor.bool_val ? 1.0 : 0.0;
            else val_dir = 0.0;
            
            // Determinar tipo de resultado
            if (esq.tipo == TIPO_FLOAT || dir.tipo == TIPO_FLOAT) {
                res.tipo = TIPO_FLOAT;
            } else {
                res.tipo = TIPO_INT;
            }
            
            switch(no->dados.operacao.operador) {
                case ADICAO: 
                    if (res.tipo == TIPO_FLOAT) res.valor.float_val = val_esq + val_dir;
                    else res.valor.int_val = (int)(val_esq + val_dir);
                    break;
                case SUBTRACAO: 
                    if (res.tipo == TIPO_FLOAT) res.valor.float_val = val_esq - val_dir;
                    else res.valor.int_val = (int)(val_esq - val_dir);
                    break;
                case MULTIPLICACAO: 
                    if (res.tipo == TIPO_FLOAT) res.valor.float_val = val_esq * val_dir;
                    else res.valor.int_val = (int)(val_esq * val_dir);
                    break;
                case DIVISAO: 
                    if (val_dir == 0.0) {
                        fprintf(stderr, "[ERRO] (linha %d): Divisão por zero\n", no->linha);
                        exit(1);
                    }
                    if (res.tipo == TIPO_FLOAT) res.valor.float_val = val_esq / val_dir;
                    else res.valor.int_val = (int)(val_esq / val_dir);
                    break;
                case MODULO: 
                    if (val_dir == 0.0) {
                        fprintf(stderr, "[ERRO] (linha %d): Módulo por zero\n", no->linha);
                        exit(1);
                    }
                    if (res.tipo == TIPO_FLOAT) res.valor.float_val = fmod(val_esq, val_dir);
                    else res.valor.int_val = (int)val_esq % (int)val_dir;
                    break;
                case POTENCIA: 
                    if (res.tipo == TIPO_FLOAT) res.valor.float_val = pow(val_esq, val_dir);
                    else res.valor.int_val = (int)pow(val_esq, val_dir);
                    break;
                default: break;
            }
            return res;
        }
        
        case NODO_CHAMADA_FUNCAO: {
            // para chamadas de função, retornamos um resultado vazio, o valor é calculado em interpretar_no
            return criar_resultado_vazio();
        }
        
        default: 
            return criar_resultado_vazio();
    }
}

static Resultado interpretar_bloco(BlocoDeclaracoes* bloco, TabelaSimbolos* tabela) {
    Resultado res = criar_resultado_vazio();
    if (bloco == NULL) return res;
    
    for (int i = 0; i < bloco->quantidade; i++) {
        res = interpretar_no(bloco->declaracoes[i], tabela);
        if (res.is_break || res.is_continue) return res;
    }
    return res;
}

static Resultado interpretar_no(NoAst* no, TabelaSimbolos* tabela) {
    if (no == NULL) return criar_resultado_vazio();
    
    switch (no->tipo) {
        case NODO_BLOCO:
            return interpretar_bloco(no->dados.bloco, tabela);
            
        case NODO_ATRIBUICAO:
            {
            Resultado res_exp = avaliar_expressao(no->dados.atribuicao.valor, tabela);
                void* valor_ptr = NULL;
                
                switch(res_exp.tipo) {
                    case TIPO_INT: {
                        int *valor_alocado = malloc(sizeof(int));
                        *valor_alocado = res_exp.valor.int_val;
                        valor_ptr = valor_alocado;
                        break;
                    }
                    case TIPO_FLOAT: {
                        double *valor_alocado = malloc(sizeof(double));
                        *valor_alocado = res_exp.valor.float_val;
                        valor_ptr = valor_alocado;
                        break;
                    }
                    case TIPO_BOOL: {
                        bool *valor_alocado = malloc(sizeof(bool));
                        *valor_alocado = res_exp.valor.bool_val;
                        valor_ptr = valor_alocado;
                        break;
                    }
                    case TIPO_STRING: {
                        char **valor_alocado = malloc(sizeof(char*));
                        *valor_alocado = strdup(res_exp.valor.string_val);
                        valor_ptr = valor_alocado;
                        break;
                    }
                    default:
                        valor_ptr = NULL;
                        break;
                }
                inserir_simbolo(tabela, no->dados.atribuicao.nome, res_exp.tipo, valor_ptr);
            return criar_resultado_vazio();
        }
        
        case NODO_CHAMADA_FUNCAO:
            {
            if (strcmp(no->dados.chamada_funcao.nome_funcao, "print") == 0) {
                for (int i = 0; i < no->dados.chamada_funcao.num_argumentos; i++) {
                    Resultado res_arg = avaliar_expressao(no->dados.chamada_funcao.argumentos[i], tabela);
                    switch(res_arg.tipo) {
                        case TIPO_INT: printf("%d", res_arg.valor.int_val); break;
                            case TIPO_FLOAT: printf("%g", res_arg.valor.float_val); break;
                        case TIPO_BOOL: printf("%s", res_arg.valor.bool_val ? "True" : "False"); break;
                        case TIPO_STRING: printf("%s", res_arg.valor.string_val); break;
                            default:
                                fprintf(stderr, "[AVISO] (linha %d): Tipo desconhecido no print\n", no->linha);
                                printf("None");
                                break;
                    }
                    if (i < no->dados.chamada_funcao.num_argumentos - 1) printf(" ");
                }
                printf("\n");
                } else if (strcmp(no->dados.chamada_funcao.nome_funcao, "input") == 0) {
                    // Implementação básica do input
                    char buffer[1024];
                    if (fgets(buffer, sizeof(buffer), stdin) != NULL) {
                        // Remove newline
                        buffer[strcspn(buffer, "\n")] = 0;
                        printf("Input recebido: %s\n", buffer);
                    }
            } else {
                    fprintf(stderr, "[ERRO] (linha %d): Função '%s' não definida\n", no->linha, no->dados.chamada_funcao.nome_funcao);
                    exit(1);
            }
            return criar_resultado_vazio();
        }
        
        case NODO_CONDICIONAL: {
            if (verificar_verdade(avaliar_expressao(no->dados.condicional.condicao, tabela))) {
                return interpretar_bloco(no->dados.condicional.bloco_if, tabela);
            } else if (no->dados.condicional.bloco_else != NULL) {
                return interpretar_bloco(no->dados.condicional.bloco_else, tabela);
            }
            return criar_resultado_vazio();
        }
        
        case NODO_LOOP: {
            while (verificar_verdade(avaliar_expressao(no->dados.loop.condicao, tabela))) {
                Resultado res_bloco = interpretar_bloco(no->dados.loop.bloco, tabela);
                if (res_bloco.is_break) break;
                if (res_bloco.is_continue) continue;
            }
            return criar_resultado_vazio();
        }
        
        case NODO_BREAK: {
            Resultado res = criar_resultado_vazio(); 
            res.is_break = true; 
            return res;
        }
        
        case NODO_CONTINUE: {
            Resultado res = criar_resultado_vazio(); 
            res.is_continue = true; 
            return res;
        }
        
        default:
            return avaliar_expressao(no, tabela);
    }
}

void interpretar(NoAst* raiz) {
    if (raiz == NULL) return;
    TabelaSimbolos* tabela_global = criar_tabela();
    interpretar_no(raiz, tabela_global);
    destruir_tabela(tabela_global);
}