# Salva os resultados de matriculas casos especiais

# Carrega pacote
library(tidyverse)

# Carrega dados
microdados_censo_escolar = read_csv2('dados/microdados_censo_escolar_2023/dados/microdados_ed_basica_2023.csv')

# Carrega dados
matriculas_casos_especiais = microdados_censo_escolar %>%
  select(ibge = CO_MUNICIPIO, TP_AEE, TP_DEPENDENCIA, TP_LOCALIZACAO_DIFERENCIADA, starts_with('QT_MAT_INF'))  %>%
  mutate(dependencia = ifelse(ibge %/% 100000 == 53, 2, TP_DEPENDENCIA),
         creche_parcial_rede_publica = QT_MAT_INF_CRE  - QT_MAT_INF_CRE_INT,
         pre_escola_parcial_rede_publica = QT_MAT_INF_PRE - QT_MAT_INF_PRE_INT) %>%
  filter(dependencia == 2) %>%
  mutate(tipo = case_when(
    TP_LOCALIZACAO_DIFERENCIADA == 2 ~ 'indigena',
    TP_LOCALIZACAO_DIFERENCIADA == 3 ~ 'quilombola',
    TP_AEE %in% 2:3 ~ 'aee',
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(tipo)) %>%
  group_by(ibge, tipo) %>%
  summarise(
    creche_parcial_rede_publica = sum(creche_parcial_rede_publica),
    pre_escola_parcial_rede_publica = sum(pre_escola_parcial_rede_publica)
  ) %>%
  pivot_longer(cols = creche_parcial_rede_publica:pre_escola_parcial_rede_publica,
               names_to = 'var',
               values_to = 'matriculas') %>%
  filter(matriculas > 0) %>%
  mutate(etapa = paste(var, tipo, sep = '_')) %>%
  select(ibge, matriculas, etapa) %>%
  pivot_wider(names_from = etapa, values_from = matriculas, values_fill = 0)

# Salva resultado
openxlsx2::write_xlsx(matriculas_casos_especiais, 'dados/matriculas/casos_especiais.xlsx')
