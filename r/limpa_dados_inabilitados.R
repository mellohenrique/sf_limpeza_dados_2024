# Obtem dados de inabilitacao vaat e vaar

# Extrai codigo dados de inabilitados vaat
inabilitados_vaat = purrr::map_dfr(
  readxl::excel_sheets('dados/inabilitados/inabilitados_vaat.xlsx'),
  function(x){
    dados = readxl::read_excel('dados/inabilitados/inabilitados_vaat.xlsx', sheet = x)
    dados = dados[, 1:4]
    return(dados)}
  )

## Corrige nomes das colunas
names(inabilitados_vaat) = c('uf', 'ente', 'ibge', 'texto_1', 'texto_2')

## Consolida em uma coluna informacoes de habilitacao
inabilitados_vaat$texto = inabilitados_vaat$texto_1
inabilitados_vaat$texto[is.na(inabilitados_vaat$texto_1)] = inabilitados_vaat$texto_2[is.na(inabilitados_vaat$texto_1)]

## Define inabiltiados vaat
v_inabilitados_vaat = inabilitados_vaat$ibge[!stringr::str_detect(inabilitados_vaat$texto, '^Habilitado')]

## Extrai codigo ibge de inabilitados vaar
inabilitados_vaar = openxlsx2::read_xlsx('dados/inabilitados/inabilitados_vaar.xlsx', startRow = 2)
v_inabilitados_vaar = inabilitados_vaar$`Código IBGE`

## Agrega dados
inabilitados = data.frame(ibge = inabilitados_vaat$ibge)
inabilitados$inabilitados_vaat = inabilitados$ibge %in% v_inabilitados_vaat
inabilitados$inabilitados_vaar = inabilitados$ibge %in% v_inabilitados_vaar


# Salva dados
openxlsx2::write_xlsx(inabilitados, 'dados/inabilitados/inabilitados.xlsx')
