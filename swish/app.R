
library(shiny)
library(visNetwork)
library(tidyverse)
library(readxl)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Swish"),
    
    h4("Nothing but Net!...work visuzlization using the vizNetwork R package / vis.js javascript library."),
    
    p("This is a shiny the lets you build a network visualization with just a spreadsheet. 
      All you need is a 'nodes' tab, where you outline the 'points' in the network,
      and an 'edges' tab, where you define the 'links' or 'connections' between the points."),
    
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
            h1("Load file here"),
            
            fileInput("viz_file", 
                      "Load an .xlsx file with a 'nodes' tab and an 'edges' tab",
                      accept = c(".xlsx")
            ),
            
            textInput("viz_title", 
                      "Title",
                      placeholder = "My cool network viz...")
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            
            h1("Network output here"),
            visNetworkOutput("network")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    
    viz_title <- reactive(input$viz_title) %>% debounce(1500)
    
    
    viz_dat <- reactive({
        
        input$viz_file$datapath %>%
        excel_sheets() %>%
        set_names() %>%
        map(read_excel, path = input$viz_file$datapath)
    })
        
        
    output$network <- renderVisNetwork({
        
        req(input$viz_file)
        
        visNetwork(
            nodes = viz_dat()$nodes,
            edges = viz_dat()$edges,
            main = viz_title())%>% 
        visOptions(manipulation = TRUE)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
