# Cria dados de matriculas limpas

# Carregando dados
## Carrega dados de matriculas
matriculas = openxlsx2::read_xlsx('dados/matriculas/matriculas.xlsx', na.strings = '-')

# Limpando dados
## Seleciona colunas de matriculas
matriculas = matriculas[, names(matriculas)[2:39]]

## Tornando todas as colunas numericas
matriculas[] = lapply(matriculas, as.numeric)
matriculas[] = lapply(matriculas, function(x){ifelse(is.na(x), 0, x)})

# Salvando dados
openxlsx2::write_xlsx(matriculas, 'dados/simulacao/alunos.xlsx')
