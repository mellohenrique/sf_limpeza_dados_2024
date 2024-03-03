# Função para converter matriculas em pdf para data.frmae
converte_matriculas = function(uf){
  caminho = paste0('dados_pdf/matriculas/', uf, '.pdf')

  uf_texto = stringr::str_to_upper(uf)
  texto_pdf = pdftools::pdf_text(caminho)

  texto_int = stringr::str_split(texto_pdf, '\n', simplify = TRUE)

  texto_int = texto_int[stringr::str_detect(texto_int, paste0("^", uf_texto))]
  texto_int = texto_int[!stringr::str_detect(texto_int, 'TOTAL')]
  texto_int = stringr::str_remove_all(texto_int, "^\\D+")
  texto_int = texto_int[texto_int != '']
  texto_int = stringr::str_trim(texto_int)
  texto_int = stringr::str_replace_all(texto_int, '[:space:]+', ' ')
  texto_int = stringr::str_replace_all(texto_int, '\\.', '')
  texto_int = stringr::str_replace_all(texto_int, '\\,', '.')
  texto_int = stringr::str_split(texto_int, ' ', simplify = TRUE)


  df_matriculas = as.data.frame(texto_int)

  df_matriculas[df_matriculas == '-'] = NA_real_
  df_matriculas[] = lapply(df_matriculas, as.numeric)

  return(df_matriculas)
}

