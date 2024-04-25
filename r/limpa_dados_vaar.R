# Pesos vaar
pesos_vaar = openxlsx2::read_xlsx('dados/pesos/pesos_vaar.xlsx', startRow = 4)
pesos_vaar = pesos_vaar[, c("Código IBGE", "Coeficientes de distribuição da complementação da\nUnião-VAAR")]
names(pesos_vaar) = c('ibge', 'peso_vaar')
openxlsx2::write_xlsx(pesos_vaar, 'dados/pesos/pesos_vaar.xlsx')
