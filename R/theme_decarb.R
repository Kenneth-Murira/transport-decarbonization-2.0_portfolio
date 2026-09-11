# Create a Custom Theme
library(ggplot2)

theme_decarb <- function() {
  theme_minimal(base_size = 12, base_family = "sans") +
    theme(
      plot.title = element_text(
        face = "bold",
        size = 16,
        margin = margin(b = 8)
      ),

      plot.subtitle = element_text(
        color = "gray30",
        margin = margin(b = 15)
      ),

      strip.background = element_rect(
        fill = "#2C3E50",
        color = NA
      ),

      strip.text = element_text(
        face = "bold",
        color = "white"
      ),

      panel.grid.minor = element_blank(),

      axis.text = element_text(
        color = "black"
      )
    )
}
