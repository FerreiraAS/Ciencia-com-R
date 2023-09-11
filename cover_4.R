W <- 8.3
H <- 11.7

for(i in 1:2){
  
  if(i == 1){
    grDevices::png(file = "Cover_4.png",
                   width = W,
                   height = H,
                   units = "in",
                   res = 300)
  } else {
    grDevices::pdf(file = "Cover_4.pdf",
                   width = W,
                   height = H)
  }
  par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), bg = "black")
  plot(1, type = "n", xlab = "", ylab = "", xlim = c(0,W), ylim = c(0,H))
  
  # sobre o autor
  author <- png::readPNG("ASF.png")
  rasterImage(author, xleft = W/2 - 1, ybottom = H/2 - 1, xright = W/2 + 1, ytop = H/2 + 1)

  texto <- "Obtive minha Graduação em Fisioterapia pela Universidade Federal do Rio de Janeiro (UFRJ, 1999), Formação em Acupuntura pela Academia Brasileira de Arte e Ciência Oriental (ABACO, 2001), Mestrado em Engenharia Biomédica pela Universidade Federal do Rio de Janeiro (UFRJ, 2002) e Doutorado em Engenharia Biomédica pela Universidade Federal do Rio de Janeiro (UFRJ, 2006).
  Tenho experiência em docência no ensino superior, atuando com professor da graduação em cursos de Fisioterapia, Enfermagem e Odontologia, entre outros (2001-atual); pós-graduação lato sensu em Fisioterapia (2001-atual) e stricto sensu em Ciências da Reabilitação (2010-atual).
  Sou professor adjunto do Centro Universitário Augusto Motta (UNISUAM), pesquisador dos Programas de Pós-graduação em Ciências da Reabilitação (PPGCR) e Desenvolvimento Local (PPGD) e Coordenador do Comitê de Ética em Pesquisa (CEP) (2020-atual).
  Fundei o Laboratório de Simulação Computacional e Modelagem em Reabilitação (LSCMR), onde desenvolvo projetos de pesquisa principalmente nos seguintes temas: Bioestatística, Modelagem e simulação computacional, Processamento de sinais biomédicos, Movimento funcional humano, Medicina tradicional (chinesa), Distúrbios musculoesqueléticos, Doenças cardiovasculares e Doenças respiratórias.
  Sou membro efetivo da Associação Brasileira de Pesquisa e Pós-Graduação em Fisioterapia (ABRAPG-FT) (2007-atual), Committee on Publication Ethics (COPE) (2018-atual), Consórcio Acadêmico Brasileiro de Saúde Integrativa (CABSIN) (2019-atual) e Royal Statistical Society (RSS) (2021-atual).
  Componho o corpo editoral dos periódicos internacionais e nacionais: Scientific Reports, Frontiers in Rehabilitation Sciences, Evidence-Based Complementary and Alternative Medicine, Chinese Journal of Integrative Medicine, Journal of Integrative Medicine, Fisioterapia e Pesquisa."
  
  rectangleWidth <- W
  s <- texto
  n <- nchar(s)
  for(i in n:1) {
    wrappeds <- paste0(strwrap(s, i), collapse = "\n")
    if(strwidth(wrappeds) < rectangleWidth) break
  }
  textHeight <- strheight(wrappeds)
  text(W/2, H/5, labels = wrappeds, col = "white")
  
  dev.off()
}
