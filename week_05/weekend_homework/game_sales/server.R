
server <- function(input, output) {
  
filtered_data <- eventReactive( input$update, 
                                 {game_sales_sorted %>% 
                                 filter(year_of_release == input$year_input & genre == input$genre_input) %>%
                                 head(5)})

  output$sales_user_plot_output <-    renderPlot({
                                      filtered_data() %>%
                                      ggplot(aes(x= name, y = sales, fill = user_score)) +
                                      geom_col(position = "dodge") +
                                      labs(title = "Sales related to user ratings for games of same genre in that year",
                                           y = "Sales in millions",
                                           x = "Name of game") + 
                                      theme(axis.text.x = element_text(angle=-45))
                                  }) 
  # This choice of graphs is intended to see whether ratings do closely relate to sales and whether conflicts between ratings and sales, due
  #  to pre-order marketing and so on, can be understood. Is there much difference between user and critic ratings?
  
  output$sales_critic_plot_output <-  renderPlot({
                                      filtered_data() %>%
                                      ggplot(aes(x= name, y = sales, fill = critic_score)) +
                                      geom_col(position = "dodge") +
                                      labs(title = "Sales related to critic ratings for games of same genre in that year",
                                           x = "Name of game",
                                           y = "Sales in millions") +
                                      theme(axis.text.x = element_text(angle=-45))
                                      }) 
  
}