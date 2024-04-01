#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(DT)

# Sample data
data <- data.frame(
  Category = c("Jews", "Poles", "Romani", "Soviet POWs", "Others"),
  Number = c(1000000, 70000, 21000, 14000, 12000)
)

# Define UI
ui <- fluidPage(
  titlePanel("Holocaust Victims killed at Auschwitz concentration camp"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("selectedCategory", "Select Categories:",
                         choices = data$Category,
                         selected = data$Category)
    ),
    mainPanel(
      plotOutput("barPlot"),
      DTOutput("dataTable")
    )
  )
)

# Define server logic
server <- function(input, output) {
  filteredData <- reactive({
    data[data$Category %in% input$selectedCategory,]
  })
  
  output$barPlot <- renderPlot({
    ggplot(filteredData(), aes(x = Category, y = Number, fill = Category)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Number of Victims by Category", y = "Number of Victims", x = "Category")
  })
  
  output$dataTable <- renderDT({
    filteredData()
  }, options = list(pageLength = 5))
}

# Run the application
shinyApp(ui = ui, server = server)
