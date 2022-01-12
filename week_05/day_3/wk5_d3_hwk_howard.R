# D12 Howard Davies  wk5 day 3 Homework

library(shiny) 
library(tidyverse)
library(janitor)
library(shinythemes)
library(CodeClanData)
library(plotly)

# Set up base data
backpack_health <- backpack %>%
  clean_names()  %>%
  select(back_problems, backpack_weight, body_weight, sex,ratio) %>%
  mutate(back_problems = case_when(back_problems == 0 ~ "No back problems",
                                   TRUE ~ "Back Problems")) 

 


# define ui
ui <- fluidPage(
  theme = shinytheme("cyborg"),
  titlePanel(tags$h4("Student backpack weights related to backpain and bodyweight by sex in interactive format")),

#  selectInput("sex2_input", "sex", c("Male", "Female", "Male & Female")),
  
  tabsetPanel(
    tabPanel(
      "Plot",
      plotlyOutput(outputId = "backpain_plot"),
    ),
    tabPanel(
      "Inputs",
      fluidRow(
        column(
          width = 6,
          radioButtons(
            inputId = "sex_input",
            label = tags$i("Female or Male"),
            choices = c("Female","Male")
          )
        ),
        column(
          width = 6,
          selectInput(
            inputId = "backpain_input",
            label = tags$i("With backpain or without?"),
            choices = c("Back Problems","No back problems")
          )
        )
      )
    )
  )
)


# define server
server <- function(input, output){
  
  # Creates outpuit medal_plot
  output$backpain_plot <- renderPlotly(

      ggplotly(backpack_health %>% 
      filter(sex %in% input$sex_input & back_problems %in% input$backpain_input) %>%
      ggplot( aes(  x = body_weight, 
                    y = backpack_weight,
                    size = ratio, 
                    fill = sex)) +
      geom_point() +
      theme_bw())

  )
}

shinyApp(ui = ui, server = server)
