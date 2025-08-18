DiagrammeR::mermaid(
  "

graph TB

A(Projeto <br/>de pesquisa) --- B(Geração e especificação <br/> de hipóteses)
B(Geração e especificação <br/> de hipóteses)-->C(Delineamento <br/> do estudo)
C(Delineamento do estudo)-->D(Realização do estudo <br/> e coleta de dados)
D(Realização do estudo e coleta de dados)-->E(Análise de dados e teste de hipóteses)
E(Análise de dados <br/> e teste de hipóteses)-->F(Interpretação de resultados)
F(Interpretação <br/> de resultados)-->G(Publicação e/ou realização <br/> do próximo experimento)

H(Elaboração das hipóteses <br/> nula e alternativa)-.->B(Geração e especificação <br/> de hipóteses)
I(Seleção das análises <br/> descritiva/inferencial e testes)-.->C(Delineamento <br/> do estudo)
J(Análise inicial <br/> de dados)-.->D(Realização do estudo <br/> e coleta de dados)
K(Análise <br/> inferencial)-.->E(Análise de dados <br/> e teste de hipóteses)
L(Tamanho do efeito <br/> e P-valor)-.->F(Interpretação <br/> de resultados)
M(Redação <br/> dos resultados)-.->G(Publicação e/ou realização <br/> do próximo experimento)

H-->I
I-->J
J-->K
K-->L
L-->M

style H fill:#FFFFFF00;
style I fill:#FFFFFF00;
style J fill:#FFFFFF00;
style K fill:#FFFFFF00;
style L fill:#FFFFFF00;
style M fill:#FFFFFF00;

"
)
