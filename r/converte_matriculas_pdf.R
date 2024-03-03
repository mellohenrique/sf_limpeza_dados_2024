source('r/utils.R')

estados = stringr::str_extract(dir('dados_pdf/matriculas/'), ".{2}")
readxl::rea


matriculas = purrr::map_dfr(estados, ~converte_matriculas(.x))
