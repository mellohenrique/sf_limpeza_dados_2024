# Carrega pacotes
library(tidyverse)

# Carrega dados
simulacao = readr::read_csv2('dados/simulacao/simulacao_padrao.csv')
matriculas_teste_bruto = openxlsx2::read_xlsx('dados/matriculas/matriculas.xlsx')
recursos_vaaf_bruto = openxlsx2::read_xlsx('dados/recursos/recursos_vaaf.xlsx', start_row = 2, na.strings = '-')
vaaf_bruto = openxlsx2::read_xlsx('dados/teste/AnexoIPortariaInterm.n1de23.02.2024.xlsx', sheet = 'Table 2', start_row = 4)
vaar_bruto_1 = openxlsx2::read_xlsx('dados/teste/recursos_total_ente_federado.xlsx', start_row = 2, na.strings = '-')
vaar_bruto_2 = openxlsx2::read_xlsx('dados/teste/recursos_total_ente_federado.xlsx', start_row = 1, na.strings = '-', sheet = 'Table 2')
vaat_bruto = openxlsx2::read_xlsx('dados/teste/recursos_vaat_geral.xlsx', start_row = 3, na.strings = '-')
matriculas_bruto = openxlsx2::read_xlsx('dados/simulacao/alunos.xlsx', start_row = 1, na.strings = '-')

# Testes ----
## Teste matriculas ----
### Limpando matriculas ----
matriculas_teste = matriculas_teste_bruto %>%
  select(ibge, prop_vaaf = coeficiente_de_distribuicao_vaaf ) %>%
  mutate(across(everything(), as.numeric))

### Teste matriculas vaaf ----
simulacao %>%
  group_by(uf) %>%
  mutate(prop = alunos_vaaf/sum(alunos_vaaf)) %>%
  ungroup() %>%
  select(ibge, prop) %>%
  left_join(matriculas_teste, by = 'ibge') %>%
  mutate(teste = abs(prop - prop_vaaf) > 0.00001)  %>%
  pull(teste) %>% any()


## Teste VAAF entes ----

### Limpando recursos VAAF ----
recursos_teste = recursos_vaaf_bruto %>%
  filter(!`ENTE FEDERADO` %in% c('GOVERNO MUNICIPAL', 'TOTAL GERAL')) %>%
  mutate(uf_cod = `CÓDIGO IBGE` %/% 100000) %>%
  mutate(uf_cod = ifelse(UF == 'DF', 53, uf_cod)) %>%
  fill(uf_cod) %>%
  mutate(ibge = ifelse(is.na(`CÓDIGO IBGE`), uf_cod, `CÓDIGO IBGE`)) %>%
  select(ibge, recursos_vaaf_inicial_planilha = `RECEITA DA CONTRIBUIÇÃO DE ESTADOS E MUNICÍPIOS AO\nFUNDEB`, recursos_vaaf_final_planilha = `TOTAL DAS RECEITAS ESTIMADAS`)

### Teste recursos vaaf ----
simulacao %>%
  select(ibge, recursos_vaaf, recursos_vaaf_final) %>%
  left_join(recursos_teste) %>%
  mutate(teste_pre = recursos_vaaf - recursos_vaaf_inicial_planilha,
         teste_pos = recursos_vaaf_final - recursos_vaaf_final_planilha) %>%
  summarise(
    recursos_vaaf_inicial = sum(abs(teste_pre) > .01),
    recursos_vaaf_final = sum(abs(teste_pos) > .1)
  )

### Teste VAAF estados ----
#### Limpeza vaaf por estado ----
vaaf = vaaf_bruto[, c(1, 6, 41)] %>%
  set_names(c('uf', 'vaaf_inep', 'recursos_vaaf_inep')) %>%
  drop_na()

#### Teste VAAF por estado ----
simulacao %>% group_by(uf) %>%
  summarise(recursos_vaaf = sum(recursos_vaaf_final), vaaf = mean(vaaf_final)) %>%
  left_join(vaaf, by = 'uf') %>%
  mutate(teste_vaaf =  abs(vaaf - vaaf_inep),
         teste_recursos_vaaf =   abs(recursos_vaaf - recursos_vaaf_inep )) %>%
  filter(teste_vaaf > 0.01)

## VAAT ----
### Limpeza dados vaat ----
vaat = vaat_bruto[,c(3, 4)] %>%
  set_names('ibge', 'vaat_pre_inep')

### Teste vaat pre ----
ibge_corretos = simulacao %>%
  filter(!inabilitados_vaat) %>%
  select(ibge, vaat_pre)  %>%
  left_join(vaat, by = 'ibge') %>%
  mutate(teste = abs(round(vaat_pre, 2) - vaat_pre_inep)) %>%
  select(ibge, teste)


## VAAR ----
### Limpeza dados vaar ----

vaar = rbind(vaar_bruto_1[, c(2, 7)] %>%
  set_names(c('ibge', 'complementacao_vaar_inep')),
vaar_bruto_2[, c(2, 7)] %>%
  set_names(c('ibge', 'complementacao_vaar_inep'))) %>%
  mutate(complementacao_vaar_inep = ifelse(is.na(complementacao_vaar_inep), 0, complementacao_vaar_inep))

### Teste VAAR estados ----
simulacao %>%
  select(ibge, recursos_vaar) %>%
  left_join(vaar, by = 'ibge') %>%
  mutate(teste = abs(recursos_vaar - complementacao_vaar_inep) < 1) %>%
  pull(teste) %>% all()
