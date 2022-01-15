#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#


library(shiny)
library(shinythemes)
library(tidyverse)
library(janitor)
library(CodeClanData)


game_sales_sorted <- game_sales %>% arrange(desc(sales)) %>% filter(year_of_release >= "2005")





                    

