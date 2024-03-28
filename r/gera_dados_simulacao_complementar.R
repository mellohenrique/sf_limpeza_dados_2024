# Monta base com os dados complementares ----
## Os dados complementares contem dados de receitas consideradas no vaaf e no vaat, assim como nivel socioeconomico do ente


# Carrega dados ----
## VAAF ----
recursos_vaaf = openxlsx2::read_xlsx('dados/recursos/recursos_vaaf.xlsx', start_row = 2, na.strings = '-')
## VAAT ----
recursos_vaat = openxlsx2::read_xlsx('dados/recursos/recursos_vaat.xlsx', startRow = 2, na.strings = '-')
recursos_vaat_complementares = openxlsx2::read_xlsx('dados/recursos/recursos_vaat_complementares.xlsx', startRow = 2, na.strings = '-')
## NSE ----
nse = openxlsx2::read_xlsx('dados/pesos/nse.xlsx')
## VAAR ----
vaar = readxl::read_excel('dados/pesos/pesos_vaar.xlsx')
## Inabilitados ----
inabilitados = readxl::read_excel('dados/inabilitados/inabilitados.xlsx')

# Limpeza VAAF ----
## Remove linhas ----
recursos_vaaf = recursos_vaaf[!recursos_vaaf$`ENTE FEDERADO` %in% c("GOVERNO MUNICIPAL", 'TOTAL GERAL'),]

## Selecioan colunas ----
recursos_vaaf = recursos_vaaf[, c('CÓDIGO IBGE', 'UF', 'ENTE FEDERADO', 'RECEITA DA CONTRIBUIÇÃO DE ESTADOS E MUNICÍPIOS AO\nFUNDEB')]

## Corrige nomes ----
names(recursos_vaaf) = c('ibge', 'uf', 'nome', 'fundeb_vaaf')

## Completa valor de ibge para estados com valor faltantes (DF) ----
recursos_vaaf$ibge = ifelse(recursos_vaaf$uf == 'DF', 53, recursos_vaaf$ibge)
ibge_estados = recursos_vaaf$ibge %/% 100000
ibge_estados = zoo::na.locf(ibge_estados)
recursos_vaaf$ibge = ifelse(is.na(recursos_vaaf$ibge), ibge_estados, recursos_vaaf$ibge)

# Limpeza VAAT ----
## Remove linha indesejada ----
recursos_vaat = recursos_vaat[recursos_vaat$UF != 'Total Brasil',]

## Seleciona colunas ----
recursos_vaat = recursos_vaat[, c('Código IBGE', 'TOTAL GERAL')]
recursos_vaat_complementares = recursos_vaat_complementares[, c('Código IBGE', 'Total')]

## Corrige nomes ----
names(recursos_vaat) = c('ibge', 'fundeb_vaat_previo')
names(recursos_vaat_complementares) = c('ibge', 'fundeb_vaat_complementar')

## Une bases ----
recursos_vaat = merge(recursos_vaat, recursos_vaat_complementares)

## Soma recursos ----
recursos_vaat$fundeb_vaat = recursos_vaat$fundeb_vaat_previo + recursos_vaat$fundeb_vaat_complementar

## Seleciona colunas ----
recursos_vaat = recursos_vaat[, c('ibge', 'fundeb_vaat')]

## Correção monetária ----
recursos_vaat$fundeb_vaat = recursos_vaat$fundeb_vaat *  1.2663

# Une dados ----
recursos = merge(recursos_vaaf, recursos_vaat, by = 'ibge')
complementar = merge(recursos, nse, by = 'ibge')
complementar = merge(complementar, vaar, by = 'ibge', all.x = TRUE)
complementar = merge(complementar, inabilitados, by = 'ibge', all.x = TRUE)

# Preenche valores vazios
complementar[] = lapply(complementar, function(x){ifelse(is.na(x), 0, x)})

# Teste
if (!any(complementar[complementar$inabilitados_vaar,]$peso_vaar > 0)){
  complementar$inabilitados_vaar = NULL
}

# Padronizando nomes
names(complementar) = c('ibge', 'uf', 'nome', 'recursos_vaaf', 'recursos_vaat', 'nse', 'peso_vaar', 'inabilitados_vaat')

# Salva resultados
openxlsx2::write_xlsx(complementar, 'dados/simulacao/complementar.xlsx')
