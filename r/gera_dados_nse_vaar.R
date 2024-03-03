# Pesos vaar
pesos_vaar = openxlsx2::read_xlsx('dados/pesos/pesos_vaar.xlsx', startRow = 4)
pesos_vaar = pesos_vaar[, c("Código IBGE", "Coeficientes de distribuição da complementação da\nUnião-VAAR")]
names(pesos_vaar) = c('ibge', 'peso_vaar')
openxlsx2::write_xlsx(pesos_vaar, 'dados/pesos/pesos_vaar.xlsx')

# NSE
nse = openxlsx2::read_xlsx('dados/pesos/PonderadorNSE.xlsx', startRow = 2)
nse = nse[, c('Código\nIBGE', 'Ponderador')]
names(nse) = c('ibge', 'nse')
openxlsx2::write_xlsx(nse, 'dados/pesos/nse.xlsx')
