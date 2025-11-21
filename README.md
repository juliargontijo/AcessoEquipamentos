# Acesso a Equipamentos Públicos – Análise com ACP

### Descrição
Este projeto explora uma metodologia para calculo de acesso a equipamentos públicos. A abordagem utiliza **buffers de 1 km** para contar equipamentos públicos e serviços urbanos em toda a cidade, relacionando essa distribuição territorial às áreas com **ônus excessivo de aluguel**, produzidos pela Fundação João Pinheiro.

A análise aplica **Análise de Componentes Principais (ACP)** para sintetizar variáveis de infraestrutura urbana, mercado imobiliário e vínculos formais (RAIS).

---

## Dados Utilizados
- Buffer com contagem de elementos em até 1km. 
- Indicadores: transporte, saúde, escolas, vínculos RAIS, média de aluguel, proporção de alugados e ônus excessivo de aluguel.

---

## Metodologia
1. Leitura e filtragem das bases.
2. Padronização das variáveis (`scale()`).
3. Análise exploratória: correlação e gráficos de dispersão.
4. Execução da ACP:
   - remoção de variáveis incompatíveis com ACP,
   - geração de loadings, autovalores e biplots,
   - extração dos scores finais.
5. Exportação de:
   - `comp_acp.csv` (componentes),
   - `base_final_acp.csv` (índice final).

---

## 👩‍💻 Autoria
**Júlia Rodrigues Gontijo**  
 31/07/2025
