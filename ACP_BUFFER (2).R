
####Projeto: Análise de Componentes Principais (ACP) - Acesso a Equipamentos Públicos####
# Data: 31/07/2025
# Autora: Júlia Rodrigues Gontijo
# Instituição: Fundação João Pinheiro (FJP)

# Descrição:
# Este script realiza a preparação dos dados domiciliares e aplica a Análise de 
# Componentes Principais (ACP) como etapa de construção do índice sintético de 
# acesso a equipamentos públicos. Os dados utilizados foram extraídos de diversas bases
#e tratam de condições de infraestrutura urbana (acesso a transporte público, saúde, emprego e escolas), além de 
#verificar também condições de aluguel.

# O objetivo é gerar escores padronizados que possam ser utilizados na análise 
# espacial da distribuição das oportunidades urbanas no território, com foco 
# especial nas áreas de maior vulnerabilidade habitacional.


# Última atualização: 31 de julho de 2025


# 1. CARREGAMENTO DE PACOTES ----
library(tidyverse)
library(ggplot2)
library(scales)
library(readxl)
library(stats)
library(FactoMineR)
library(missMDA)
library(factoextra)
library(writexl)
library(GGally)


# 2. LEITURA DOS DADOS ----

setwd("ARTIGO_AOP")

buffer1km <-  openxlsx::read.xlsx("BUFFER_ELEMENTOS_DENTRO_1KM_corrigido.xlsx", sheet = 1) %>% 
  select(
    COUNT_linh,
    CONT_EQUI_,
    CONTA_ESCO,
    RAIS,
    media_aluguel,
    prop_alugados,
    bh_onus) %>%
  rename(
     transporte = COUNT_linh,
     saude = CONT_EQUI_,
     escolas = CONTA_ESCO) 

write_xlsx(buffer1km, path = "buffer1km_tratado.xlsx")

# 3. PADRONIZACAO DOS DADOS ----
# Por ter unidades de análise diferentes os dados precisam ser padronizados. 
#A função subtraí cada variavel pela média e divide pelo desvio padrão. 

buffer1km_P=scale(buffer1km)

apply(buffer1km_P, 2, mean, na.rm = TRUE)
apply(buffer1km_P,2,sd,na.rm = TRUE)


# 4. ANALISE INICIAL ----
##OBS: foram encontradas algumas linhas em media de aluguel e prop de alugados que possuem NA, o que faz com que a análise tenha erros. Nesse caso linhas com NA foram ignoradas. 
#Foi verificado por meio de comparação que remover as linhas NA não afetou a análise.  

#matriz de correlação
cor(buffer1km_P, use = "complete.obs")

#Matriz de correlação e graficos de dispersão (ignora automaticamente linhas com NA) 
ggpairs(buffer1km_P, columns = 1:7)
ggpairs(buffer1km_P, columns = c( "transporte", "saude", "escolas", "RAIS", "bh_onus"))

warnings()


# 4. ANALISE DE COMPONENTES PRINCIPAIS----
# Remover apenas as linhas com NA
summary(buffer1km)
buffer1km_ACP <- buffer1km %>%
  select(-bh_onus) %>%
  drop_na()

acp_buffer1km <- princomp(buffer1km_ACP, cor=TRUE) 

loadings(acp_buffer1km)

biplot(acp_buffer1km)

plot(acp_buffer1km)

get_pca(acp_buffer1km)

eig.val <- get_eigenvalue(acp_buffer1km)

fviz_pca_var(acp_buffer1km, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
             )

?fviz_pca_var

comp_acp <- acp_buffer1km$scores

write.csv(x=comp_acp, file="comp_acp.csv", row.names = TRUE)

base_final <- cbind(dados[c(1,2)], comp_acp)

write.csv2(base_final, "base_final_acp.csv")



