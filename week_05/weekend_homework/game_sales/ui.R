ui <- fluidPage(
  
  theme = shinytheme("cyborg"),
  titlePanel("Game sales against critic and user score by year and genre from 2005"),
  
  
  fluidRow(
    
    column(
      width = 4,
      radioButtons("year_input",
                   "Choose a year",
                   choices = sort(unique(game_sales_sorted$year_of_release)),
                   inline = TRUE
      )
    ),
    
    column(
      width = 4,
      radioButtons("genre_input",
                   "Choose genre",
                   choices =sort(unique(game_sales_sorted$genre)),
                   inline = TRUE
      )
    )

  ),
  
  # Add an action button
  actionButton("update", 
               "Update Dashboard"),

  
  fluidRow(
    column(
      width = 6,
      plotOutput("sales_user_plot_output")
    ),
    column(
      width = 6,
      plotOutput("sales_critic_plot_output")
    )
  )
)