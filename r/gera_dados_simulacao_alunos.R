# Cria dados de matriculas limpas

# Carregando dados
## Carrega dados de matriculas
matriculas = openxlsx2::read_xlsx('dados/matriculas/matriculas.xlsx', na.strings = '-')
matriculas_especiais = readxl::read_excel('dados/matriculas/Matrículas por categoria Fundeb 2024 - alteração Boca da Mata-AL.xlsx', skip = 1)
matriculas_especiais = janitor::clean_names(matriculas_especiais)

# Corrigindo matriculas especiais
## Seleciona municipios
matriculas_especiais = matriculas_especiais[matriculas_especiais$esfera_adm == 'Municipal',]

## Calcula vetores de alunos
matriculas_especiais$ed_esp_creche = matriculas_especiais$x13_ed_esp_pub_creche
matriculas_especiais$ed_esp_pre_escola = matriculas_especiais$x14_ed_esp_pub_pre_escola
matriculas_especiais$ed_ind_quil_creche = matriculas_especiais$x34_quil_creche + matriculas_especiais$x27_ed_ind_creche
matriculas_especiais$ed_ind_quil_pre_escola = matriculas_especiais$x35_quil_pre_escola + matriculas_especiais$x28_ind_pre_escola

## Selecioan colunas de interesse
matriculas_especiais = matriculas_especiais[,c('cod_ibge', 'ed_esp_creche', 'ed_esp_pre_escola', 'ed_ind_quil_creche' , 'ed_ind_quil_pre_escola')]

matriculas = merge(matriculas, matriculas_especiais, by.x = 'ibge', by.y = 'cod_ibge', all.x = TRUE)

# Limpando dados
## Seleciona colunas de matriculas
matriculas = matriculas[, names(matriculas)[c(1, 3:46)]]

## Tornando todas as colunas numericas
matriculas[] = lapply(matriculas, as.numeric)
matriculas[] = lapply(matriculas, function(x){ifelse(is.na(x), 0, x)})

## Recalculando educacao especial
matriculas$educacao_especial_rede_publica = matriculas$educacao_especial_rede_publica - matriculas$ed_esp_creche - matriculas$ed_esp_pre_escola

## Recalculando educacao indigena
matriculas$educacao_indigena_e_quilombola_rede_publica = matriculas$educacao_indigena_e_quilombola_rede_publica - matriculas$ed_ind_quil_creche - matriculas$ed_ind_quil_pre_escola

# Salvando dados
openxlsx2::write_xlsx(matriculas, 'dados/simulacao/alunos.xlsx')
