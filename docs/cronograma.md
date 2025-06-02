# Cronograma do Projeto 

## Cronograma planejado das sprints

| Sprint  | Período           | Objetivos Principais                                                                                                         | Entregas Principais                                                                                      | Tarefas Principais                                                                                                                                                                                                                      |
|---------|-------------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Sprint 1| 24/03 a 09/04     | Formar equipe, configurar ambiente, definir linguagem e criar gramática inicial                                            | Documento da linguagem, protótipo da gramática, ambiente testado                                         | Definir escopo, configurar repositório, instalar ferramentas, criar gramática inicial (.y) e regras léxicas (.l)                                                                                                                      |
| Sprint 2| 10/04 a 30/04     | Finalizar análise léxica, implementar regras básicas do parser, preparar apresentação P1                                   | Arquivo .l completo, regras sintáticas iniciais, formulário e apresentação P1                            | Finalizar expressões regulares, desenvolver regras sintáticas básicas, testar tokens/parser, preparar apresentação                                                                                                                     |
| Sprint 3| 01/05 a 14/05     | Implementar AST, iniciar análise semântica básica, melhorar mensagens de erro                                              | Estruturas da AST, módulo de análise semântica inicial, parser construindo AST                           | Implementar ações semânticas para AST, criar tabela de símbolos, tratar erros sintáticos/semânticos, testar AST                                                                                                                        |
| Sprint 4| 15/05 a 04/06     | Implementar interpretação da AST, aprimorar análise semântica, preparar apresentação P2                                    | Interpretador funcional, análise semântica robusta, formulário e apresentação P2                         | Criar lógica de interpretação recursiva, consolidar estruturas de controle, testar interpretador, preparar apresentação                                                                                                                |
| Sprint 5| 05/06 a 25/06     | Corrigir erros e débitos técnicos, garantir estabilidade e qualidade para entrega final                                    | Versão revisada e estável, bugs corrigidos, débitos técnicos resolvidos, projeto pronto para entrega      | Revisar/corrigir bugs, refatorar código, atualizar documentação, garantir cobertura de testes, testes finais de integração                                                                                                             |
| Sprint 6| 26/06 a 09/07     | Entrevistas finais, corrigir pendências, finalizar documentação e encerrar o projeto                                       | Entrevistas finais, documentação completa, ajustes finais                                                | Preparar-se para entrevistas, corrigir falhas apontadas, finalizar documentação e exemplos de uso                                                                                                                                      |

## Débitos Técnicos e Pendências

| Descrição do Débito Técnico ou Pendência | Sprint em que surgiu | Status (Aberto/Resolvido) |
|------------------------------------------|----------------------|---------------------------|
| Melhorar mensagens de erro    | Sprint 3     | Aberto                    | 
| Adicionar testes para o analisador sintático| Sprint 3|Aberto                    |
| Adicionar testes para AST     | Sprint 3             | Resolvido                    |
| Interpretar interpretação da AST| Sprint 4             | Aberto                    |


## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/04/2025 |  Documentação de cronograma | Breno Yuri |
| `1.1`  |  28/04/2025 |  Correções | Breno Yuri |
| `1.2`  |  26/05/2025 |  Organização do cronograma em formato de tabela e adição da tabela de débitos técnicos. | Arthur Evangelista |
| `1.21`  |  26/05/2025 | Débito técnico "adicionar testes para AST" resolvido. | Arthur Evangelista |

