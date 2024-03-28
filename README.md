# Simulador Fundeb - Limpeza dos de 2024

O simulador do fundeb utiliza dados de diferentes anos para realizar as simulações. Os dados estão dispersos em diferentes arquivos do Fundeb e é necessário agrupa-los e organiza-los da forma adequada para serem consumidos pelo simulador. Esse projeto limpa os dados obtidos de 2024 para deixa-los adequado a formatação utilizada no simulador.

A principal fonte de dados utilizada foi a [portaria interministerial número 1 de 2024](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/legislacao/2023/portaria-interm-no-1-de-24-02-2024.pdf). Além disso, os resultados obtidos na portaria inteministeria número 7 de 2023 são considerados como resultados de referência do ano de 2024, ou seja, usa-se eles para verificar se os resultados da simulação do cenário base de 2024 estã corretos.

## Projeto

O projeto de limpeza dos do fundeb de 2024. Etapas:
1. Obtenção dos dados (extração manual do portal);
2. Conversão dos dados pdf em .xlsx (usando script em python e o portal [ilovepdf](https://www.ilovepdf.com/pt);
3. Limpeza inicial dos dados;
4. Agregação dos dados no formato adequado ao consumo pelo simulador.

## Produto

As seguintes tabelas são esperadas desse projeto:
* Dados de alunos para 2024 por etapa e ente federado;
* Dados de peso por etapa e modalidade de complementação (VAAF e VAAT);
* Dados complementares dos entes federados (recursos, habilitação para etapa VAAT e peso VAAR).

## Fontes

Os dados foram obtidos das seguintes fontes:

  * Os números de alunos foram obtidos dos anexos por Unidade da Federação da [portaria interministerial número 1 de 2024](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/matriculas-da-educacao-basica/copy_of_2024-com-base-na-portaria-interministerial-no-6-de-28-12-2023)
* Os valores de financiamento foram obtidos no [portal do FNDE](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/2024-1): 
  * Os recursos considerados para o VAAF foram obtidos no dados disponibilizados com a [portaria interministerial número 7 de 2023](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/2024/ReceitaTotalporEnteFederado.pdf);
  * Os recursos considerados para o VAAT foram obtidos em:
    * [Tabela com os recursos do STN](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/2024/ReceitaSTN2022VAAT2024parapublicao.pdf);
    * [Tabela com os recursos de Programas Universais](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/2024/ReceitaUniversais2022VAAT2024parapublicao.pdf);
  * A correção monetária para cálculo dos recursos considerados no VAAT foi obitdo da [nota técnica SEI nº 2083](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/2024/NotaTcnicaSTNn2083CorreoMonetriaVAAT.pdf).
* Os entes inabilitados para o VAAT foram obtidos no [comunicado do Fundeb sobre a habilitação dos entes](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/ListafinalhabilitaoVAAT202431agosto2023.pdf);
* Os pesos considerados para o VAAR foram obtidos no [portaria interministerial número 1 de 2024](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/2024/AnexoVPortariaInterm.n6de28.12.2023.pdf).
* Os pesos de aluno por etapa foram obtidos da [nota técnica conjunto número 12 de 2022](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/notas-tecnicas/NotaTcnicaConjuntan122022.pdf).
