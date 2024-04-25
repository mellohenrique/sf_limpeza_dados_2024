# NSE
nse = openxlsx2::read_xlsx('dados/pesos/PonderadorNSE.xlsx', startRow = 2)
nse = nse[, c('Código\nIBGE', 'Ponderador')]
names(nse) = c('ibge', 'nse')
openxlsx2::write_xlsx(nse, 'dados/pesos/nse.xlsx')
