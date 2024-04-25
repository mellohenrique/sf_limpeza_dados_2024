# Faz uma simulação com os dados atualizados ----

# Carrega dados ----
## Carregando dados de matriculas ----
matriculas = openxlsx2::read_xlsx('dados/simulacao/alunos.xlsx')

##Carregando dados de recursos ----
complementar = openxlsx2::read_xlsx('dados/simulacao/complementar.xlsx')

## Carregando dados de pesos ----
pesos = openxlsx2::read_xlsx('dados/simulacao/pesos_etapas.xlsx')

# Simulando ----
simulacao = simulador.fundeb::simula_fundeb(
  dados_alunos = matriculas,
  dados_complementar = complementar,
  dados_peso = pesos,
  complementacao_vaaf = 24153287047.4,
  complementacao_vaat = 18114965285.51,
  complementacao_vaar = 3622993057.10)

# Salvando resultado ----
readr::write_excel_csv2(simulacao, 'dados/simulacao/simulacao_padrao.csv')
