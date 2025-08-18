# Simulate data
set.seed(123)  # For reproducibility
n <- 5  # Number of observations

# Create a dataframe with two time points and different offsets
data <- data.frame(
  group = rep(c("A", "B", "B'"), each = n * 2),
  time = rep(c(1, 2), each = n),
  response = c(
    5 + rnorm(n, mean = 0, sd = 1),
    # Group A at time 1
    15 + rnorm(n, mean = 0, sd = 1),
    # Group A at time 2
    10 + rnorm(n, mean = 0, sd = 1),
    # Group B' at time 1
    20 + rnorm(n, mean = 0, sd = 1),
    # Group B' at time 2
    rnorm(n, mean = 0, sd = 1),
    # Group B at time 1
    rnorm(n, mean = 0, sd = 1)   # Group B at time 2
  )
)

# add offset to group B at 2
data$response[data$group == "B'" &
                data$time == 1] <- data$response[data$group == "B" &
                                                   data$time == 1]
data$response[data$group == "B'" &
                data$time == 2] <- data$response[data$group == "B" &
                                                   data$time == 2] - 5

# Calculate means for plotting
means <- aggregate(response ~ group + time, data, mean)

# Create the plot
ggplot2::ggplot(means,
                ggplot2::aes(
                  x = time,
                  y = response,
                  color = group,
                  group = group
                )) +
  ggplot2::geom_line(size = 1) +               # Draw lines for means
  ggplot2::geom_point(size = 3) +              # Add points for means
  ggplot2::labs(title = "", x = "Tempo", y = "Resposta") +
  ggplot2::theme_minimal() +
  ggplot2::scale_color_manual(values = c("black", "gray", "black")) +  # Custom colors
  ggplot2::theme(legend.title = ggplot2::element_blank()) +
  # minumum theme
  ggplot2::theme(
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.background = ggplot2::element_blank(),
    axis.line = ggplot2::element_line(colour = "black")
  ) +
  # move legent to the top left corner
  ggplot2::theme(legend.position = c(0, 1),
                 legend.justification = c(0, 1)) +
  # annotate plot with "Efeito esperado sem interação"
  ggplot2::annotate(
    "text",
    x = 2,
    y = mean(data$response[data$group == "B" &
                             data$time == 2]),
    label = "Sem efeito de \n interação",
    size = 3,
    color = "gray",
    hjust = -0.1,
    vjust = 0.5
  ) +
  # annotate plot with "Efeito esperado com interação"
  ggplot2::annotate(
    "text",
    x = 2,
    y = mean(data$response[data$group == "B'" &
                             data$time == 2]),
    label = "Com efeito de \n interação",
    size = 3,
    color = "black",
    hjust = -0.1,
    vjust = 0.5
  ) +
  # draw dashed arrow of effect from B' to B at time 2
  ggplot2::geom_segment(
    ggplot2::aes(
      x = 2,
      xend = 2,
      y = mean(data$response[data$group == "B'" &
                               data$time == 2]),
      yend = mean(data$response[data$group == "B" &
                                  data$time == 2])
    ),
    arrow = ggplot2::arrow(
      type = "open",
      length = grid::unit(0.1, "inches"),
      ends = "both",
      angle = 20
    ),
    color = "black",
    linetype = "dashed"
  ) +
  # annotate plot with "Efeito de interação"
  ggplot2::annotate(
    "text",
    x = 2,
    y = mean(data$response[data$group != "A" &
                             data$time == 2]),
    label = "Tamanho de efeito \n estimado",
    size = 3,
    color = "black",
    hjust = -0.1,
    vjust = 0.5
  ) +
  # augment x axis margins to make room for annotations
  ggplot2::scale_x_continuous(
    breaks = c(1, 2),
    labels = c("Antes", "Depois"),
    expand = c(0.3, 0.3)
  )
