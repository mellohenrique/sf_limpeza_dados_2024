# Faz uma simulação com os dados atualizados ----

# Carrega pacotes----
library(tidyverse)

# Carrega dados ----
# #Carregando dados de recursos ----
recursos = openxlsx2::read_xlsx('dados/recursos/recursos.xlsx')

## Carregando dados de nível socioeconomico ----
nse = openxlsx2::read_xlsx('dados/pesos/nse.xlsx')

## Carregando dados de pesos ----
pesos = openxlsx2::read_xlsx('dados/pesos/pesos_etapas.xlsx')

## Carregando dados de matriculas ----
matriculas = openxlsx2::read_xlsx('dados/matriculas/matriculas_limpa.xlsx')

## Inabilitados ----
inabilitados_vaat = openxlsx2::read_xlsx('dados/inabilitados/inabilitados_vaat.xlsx')

# Unindo para formar dados complementares ----
complementar = merge(recursos, nse)

# Simulando ----
simulacao = simulador.fundeb2::simula_fundeb(matriculas, dados_complementar = complementar, peso_etapas =  pesos, complementacao_vaaf = 24153287047.4, complementacao_vaat = 18114965285.51)

# Resultado ----
simulacao

# Testes ----

## Teste matriculas ----
### Carregando matriculas
matriculas_teste = openxlsx2::read_xlsx('dados/matriculas/matriculas.xlsx') %>%
  select(ibge, prop_vaaf = coeficiente_de_distribuicao_vaaf ) %>%
  mutate(across(everything(), as.numeric))

simulacao %>%
  group_by(uf) %>%
  mutate(prop = alunos_vaaf/sum(alunos_vaaf)) %>%
  ungroup() %>%
  left_join(matriculas_teste) %>%
  mutate(teste = abs(prop - prop_vaaf) > 0.00001) %>%
  summarise(teste = sum(teste)*1e5)

## Teste receitas ----

### VAAF ----
receitas_teste = openxlsx2::read_xlsx('dados/recursos/receitas_vaaf.xlsx', start_row = 2, na.strings = '-') %>%
  filter(!`ENTE FEDERADO` %in% c('GOVERNO MUNICIPAL', 'TOTAL GERAL')) %>%
  mutate(uf_cod = `CÓDIGO IBGE` %/% 100000) %>%
  mutate(uf_cod = ifelse(UF == 'DF', 53, uf_cod)) %>%
  fill(uf_cod) %>%
  mutate(ibge = ifelse(is.na(`CÓDIGO IBGE`), uf_cod, `CÓDIGO IBGE`)) %>%
  select(ibge, receita_ente = `RECEITA DA CONTRIBUIÇÃO DE ESTADOS E MUNICÍPIOS AO\nFUNDEB`, total_receitas_ente_vaaf = `TOTAL DAS RECEITAS ESTIMADAS`)

simulacao %>%
  select(ibge, fundo_vaaf, fundeb_vaaf) %>%
  left_join(receitas_teste) %>%
  mutate(teste_pre = fundeb_vaaf - receita_ente,
         teste_pos = fundo_vaaf - total_receitas_ente_vaaf) %>%
  summarise(
    mean(abs(teste_pre) > 1),
    mean(abs(teste_pos) > 1)
  )

### VAAT ----
