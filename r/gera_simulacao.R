# Faz uma simulação com os dados atualizados ----

# Carrega dados ----
## Carregando dados de matriculas ----
matriculas = openxlsx2::read_xlsx('dados/simulacao/alunos.xlsx')

##Carregando dados de recursos ----
complementar = openxlsx2::read_xlsx('dados/simulacao/complementar.xlsx')

## Carregando dados de pesos ----
pesos = openxlsx2::read_xlsx('dados/simulacao/pesos_etapas.xlsx')

# Simulando ----
simulacao_base = simulador.fundeb::simula_fundeb(
  dados_matriculas = matriculas,
  dados_complementar = complementar,
  dados_peso = pesos[,c("etapa", "peso_vaaf", "peso_vaat")],
  complementacao_vaaf = 24153287047.4,
  complementacao_vaat = 18114965285.51,
  complementacao_vaar = 0)

# Gerando simulacao base agregada
simulacao_base_agregada = stats::aggregate(
  list(complemento_uniao = simulacao_base$complemento_uniao),
  by = list(uf = simulacao_base$uf),
  FUN=sum)

# Salvando resultado ----
readr::write_excel_csv2(simulacao_base, 'dados/simulacao/simulacao_padrao.csv')

# Salva dados para o dashboard
save(matriculas, file = 'dados/dash/matriculas.rda')
save(complementar, file = 'dados/dash/complementar.rda')
save(pesos, file = 'dados/dash/pesos.rda')
save(simulacao_base, file = 'dados/dash/simulacao_base.rda')
save(simulacao_base_agregada, file = 'dados/dash/simulacao_base_agregada.rda')
