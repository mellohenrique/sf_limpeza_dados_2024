# Faz uma simulação com os dados atualizados ----

# Carrega dados ----
## Carregando dados de matriculas ----
matriculas = openxlsx2::read_xlsx('dados/simulacao/alunos.xlsx')
matriculas = matriculas[, c('ibge', pesos$etapa)]
##Carregando dados de recursos ----
complementar = openxlsx2::read_xlsx('dados/simulacao/complementar.xlsx')

## Carregando dados de pesos ----
pesos = openxlsx2::read_xlsx('dados/simulacao/pesos_etapas.xlsx')

# Simulando ----
cenario_atual = simulador.fundeb::simula_fundeb(
  dados_matriculas = matriculas,
  dados_complementar = complementar,
  dados_peso = pesos,
  complementacao_vaaf = 24153287047.4,
  complementacao_vaat = 18114965285.51,
  complementacao_vaar = 0)

# Gerando simulacao base agregada
cenario_atual_agregada = stats::aggregate(
  list(complemento_uniao = cenario_atual$complemento_uniao),
  by = list(uf = cenario_atual$uf),
  FUN=sum)

# Gerando simulacao estados
simulacao_ufs = cenario_atual[cenario_atual$inabilitados_vaat == FALSE | cenario_atual$uf == 'DF',]

cenario_ufs_atual = stats::aggregate(
  list(VAAF = simulacao_ufs$vaaf_final,
       VAAT = simulacao_ufs$vaat_final),
  by = list(uf = simulacao_ufs$uf),
  FUN=mean)


cenario_ufs_atual$tipo = 'Atual'


# Limpando regressão inicial
cenario_atual[, c('matriculas_vaaf', 'matriculas_vaat',  'recursos_vaaf', 'recursos_vaat',  'recursos_vaaf_final', 'vaaf_final', 'vaat_pre', 'recursos_vaat_final', 'vaat_final', 'complemento_vaaf', 'complemento_vaat', 'complemento_uniao', 'recursos_fundeb')] = lapply(cenario_atual[, c('matriculas_vaaf', 'matriculas_vaat',  'recursos_vaaf', 'recursos_vaat',  'recursos_vaaf_final', 'vaaf_final', 'vaat_pre', 'recursos_vaat_final', 'vaat_final', 'complemento_vaaf', 'complemento_vaat', 'complemento_uniao', 'recursos_fundeb')], round, 2)


cenario_atual = cenario_atual[, c('ibge', 'uf', 'nome', 'matriculas_vaaf', 'matriculas_vaat', "inabilitados_vaat", 'nse', 'nf', 'recursos_vaaf', 'recursos_vaat',  'recursos_vaaf_final', 'vaaf_final', 'vaat_pre', 'recursos_vaat_final', 'vaat_final', 'complemento_vaaf', 'complemento_vaat', 'complemento_uniao', 'recursos_fundeb')]

cenario_atual$inabilitados_vaat = ifelse(cenario_atual$inabilitados_vaat, 'Verdadeiro', "Falso")

# Gerando vetor de Disponibilidade Fiscal
nf = data.frame(
  ibge = cenario_atual$ibge,
  nf = simulador.fundeb:::reescala_vetor(cenario_atual$vaat_pre, maximo = .95, minimo = 1.05))

# Alterando complementar
complementar$nf = NULL
complementar = merge(complementar, nf, by = 'ibge')

# Salvando resultado ----
readr::write_excel_csv2(cenario_atual, 'dados/simulacao/cenario_atual.csv')

# Salva dados para o dashboard
save(matriculas, file = 'dados/dash/matriculas.rda')
save(complementar, file = 'dados/dash/complementar.rda')
save(pesos, file = 'dados/dash/pesos.rda')
save(cenario_atual, file = 'dados/dash/cenario_atual.rda')
save(cenario_atual_agregada, file = 'dados/dash/cenario_atual_agregada.rda')
save(cenario_ufs_atual, file = 'dados/dash/cenario_ufs_atual.rda')
