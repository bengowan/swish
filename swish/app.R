
library(shiny)
library(visNetwork)
library(tidyverse)
library(readxl)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("SeeMeshFun"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            fileInput("viz_file", "Choose an xlsx file with a nodes tab and an edges tab",
                      accept = c(".xlsx")
            )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            visNetworkOutput("network")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$network <- renderVisNetwork({
        viz_dat <- input$viz_file$datapath %>%
            excel_sheets() %>%
            set_names() %>%
            map(read_excel, path = input$viz_file$datapath)
        
        print(viz_dat)
        
        visNetwork(
            viz_dat$nodes,
            viz_dat$edges
        )
    })
}

# Run the application
shinyApp(ui = ui, server = server)
