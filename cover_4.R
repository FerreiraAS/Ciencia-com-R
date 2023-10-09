W <- 8.27
H <- 11.69

texto <-
  "<p style=\"font-size: 60px;\"><b>Ciência com R</b></p>
  \n
  <br>
  \n
  Você está pronto para desbloquear o poder da análise estatística de dados e elevar sua pesquisa a novos patamares? Não procure mais. Em \"Ciência com R\", o Dr. Arthur de Sá Ferreira, um pesquisador experiente, oferece um guia indispensável que capacitará pesquisadores, analistas de dados e estudantes a tomarem decisões informadas e baseadas em evidências em seus empreendimentos científicos.
  \n
  <br>
  \n *ORIENTAÇÃO ESPECIALIZADA*: Beneficie-se da ampla experiência do Dr. Arthur de Sá Ferreira enquanto ele responde às perguntas mais fundamentais: *O que é isso?* *Por que usá-lo?* *Quando usar?* *Quando não usar?* *Como fazer?* Cada capítulo se aprofunda em questões específicas, oferecendo explicações claras e concisas e exemplos práticos.
  \n *FORMATO DE PERGUNTAS E RESPOSTAS*: Mantenha uma conversa direta e objetiva com o autor. Descubra respostas para as perguntas comumente feitas por estudantes, pesquisadores e profissionais em todas as fases de sua jornada acadêmica e científica.
  \n *APRENDIZADO PROGRESSIVO*: Navegue por uma progressão de conceitos e aplicações. Capítulos são estruturados didaticamente para maior clareza educacional, com referências cruzadas para garantir uma compreensão coesa dos tópicos inter-relacionados, reduzindo a fragmentação do conteúdo.
  \n *INSIGHTS ATUALIZADOS*: Fique à frente da curva com as referências e insights mais recentes. Dr. [Seu nome] lança luz sobre preconceitos, paradoxos, mitos e práticas ilícitas na área, oferecendo uma clareza inestimável até mesmo para os pesquisadores mais experientes.
  \n
  <br>
  \n
  Quer você seja um estudante de pós-graduação em busca de métodos para analisar seus projetos de pesquisa, um pesquisador que precisa de informações e referências para o desenvolvimento de projetos ou um analista de dados experiente que deseja se manter atualizado, este livro é seu melhor companheiro. Além disso, pessoas de diversas áreas encontrarão neste livro uma porta de entrada para compreender a importância de fazer e responder perguntas no mundo da ciência.
  \n
  Tome decisões informadas, evite armadilhas e destaque-se em sua pesquisa científica com \"Ciência com R\". Os insights profundos do Dr. [Seu Nome] permitirão que você transforme seus dados em descobertas significativas, colocando você no caminho da excelência em pesquisa."

grDevices::png(
  file = "Cover_4.png",
  width = W,
  height = H,
  units = "in",
  res = 300
)

df <- data.frame(
  label = texto,
  x = 0,
  y = 11.69 - 0,
  hjust = 0,
  vjust = 1,
  orientation = "upright",
  color = "white",
  fill = "black"
)

ggplot2::ggplot(df) +
  ggplot2::aes(
    x,
    y,
    label = label,
    color = color,
    fill = fill,
    hjust = hjust,
    vjust = vjust,
    orientation = orientation
  ) +
  ggtext::geom_textbox(width = unit(0.93, "npc"),
                       box.colour = "black") +
  ggplot2::scale_discrete_identity(aesthetics = c("color", "fill", "orientation")) +
  ggplot2::xlim(0, 8.27) + ggplot2::ylim(0, 11.69) +
  theme_void() +
  theme(
    legend.position = "none",
    panel.background = element_rect(fill = 'black', colour = 'black')
  )

dev.off()

# save PDF
grDevices::pdf(file = "Cover_4.pdf",
               width = W,
               height = H)
img <- png::readPNG("Cover_4.png")
img <- as.raster(img[, , 1:3])
par(
  mar = c(0, 0, 0, 0),
  oma = c(0, 0, 0, 0),
  omi = c(0, 0, 0, 0),
  mai = c(0, 0, 0, 0),
  bg = "black"
)
plot(img)
dev.off()
