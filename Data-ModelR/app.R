# Shiny App version of:

#####################################
# Data Model Example using The Adventure Works
#  publicly available dataset  
 
####################################
# setup the environment first

#install.packages("datamodelr")
#library(datamodelr)

# library(devtools)
# install_github("bergant/datamodelr")
library(datamodelr)
library(DiagrammeR)


#install.packages("readxl")
library(readxl)

######################################
# Read in the Excel files

# set file path -assume home directory for location of files
excel_path1 <- "~/Adventure_Works_Data_Definitions.xlsx"
excel_path2 <- "~/Adventure_Works_version_2.xlsx"

# read in the sheets that have data - ignore the rest
EmployeeHR <- read_excel(path=excel_path2, sheet = 1)
BusinessEntityAddress <- read_excel(path=excel_path2, sheet = 2)
Salesperson <- read_excel(path=excel_path2, sheet = 3)
Contact <- read_excel(path=excel_path2, sheet = 4)
EmployeePayHistory <- read_excel(path=excel_path2, sheet = 5)
Address <- read_excel(path=excel_path2, sheet = 6)
SalesTerritory <- read_excel(path=excel_path1, sheet = 8)
SalesOrderHeader <- read_excel(path=excel_path1, sheet = 9)

# use datamodelr:dm_from_data_frames to create the data model
datamodel <- dm_from_data_frames(EmployeeHR, BusinessEntityAddress,
                                 Salesperson, Contact, EmployeePayHistory, Address, 
                                 SalesTerritory, SalesOrderHeader)

# add the keys to the data model
datamodel <- dm_add_references(
  datamodel,
  BusinessEntityAddress$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  BusinessEntityAddress$`Address ID` ==Address$`Address ID`,
  Salesperson$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  Contact$`BusinessEntityID (Person)` == EmployeeHR$`Business Entity ID`,
  EmployeePayHistory$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  Address$`Territory ID` == SalesTerritory$`Territory ID`,
  SalesOrderHeader$`Sales Person ID` == Salesperson$`Business Entity ID`,
  SalesOrderHeader$`Territory ID` == SalesTerritory$`Territory ID`)

# SHINY ADAPTION - move the following block to the shiny server section
# and add the ability to pass parameters for viewing options
####################################################
# graph <- dm_create_graph(datamodel, rankdir = "RL", col_attr = c("column"))

# dm_render_graph(graph)
####################################################

# Start of the adaption to a shiny app
library(shiny)
library(shinyAce)
library(rsvg)
library(V8)

# (kf) Adapted for the Adventure Works Data model:
# this function gets copied to the shiny app section 
get_graph <- function(x, rankdir = "RL", view_type = "all") {
  
  ret <- ""
  try({
    graph <- dm_create_graph(datamodel, graph_attrs = "bgcolor = '#F4F0EF', splines = ortho, model = subset",
                             rankdir = rankdir, view_type = view_type, 
                             edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond",
                             node_attrs = "fontname = 'Arial'")
    ret <- graph$dot_code
  })
  ret
}

# Define UI based on the Bergant sample
ui <- fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  fluidRow(
    # Application title
    titlePanel("Data ModelR Example")
  ),
  fluidRow(
    column(10,
           grVizOutput('diagram', height = 600)
    ),
    column(2,
           selectInput("view_type", label = "Show columns",  choices = list(
             "All columns" = "all",
             "Keys only" = "keys_only",
             "No columns" = "title_only"), selected = "RL"),
           selectInput("rankdir", label = "Graph direction",  choices = list(
             "Right-left" = "RL",
             "Bottom-top" = "BT",
             "Left-right" = "LR",
             "Top-bottom" = "TB"), selected = "RL"),
           hr(),
           downloadButton(outputId = 'downloadData', label = 'Download SVG'),
           downloadButton(outputId = 'downloadDataPng', label = 'Download PNG')
    )
  ),
  HTML('<footer>
       Powered by:
       <a href = "https://github.com/bergant/datamodelr">datamodelr</a> - Data model diagrams in R
       | <a href = "http://rich-iannone.github.io/DiagrammeR/">DiagrammeR</a> - Create graph diagrams and flowcharts using R
       | <a href = "http://shiny.rstudio.com/">shiny</a> - A web application framework for R
       | <a href = "http://trestletech.github.io/shinyAce/">shinyAce</a> - Integrating the <a href="http://ace.c9.io">Ace Editor</a> with Shiny
       </footer>'
  )
)

# from Bergant example
server = function(input, output, session){
  
  output$diagram <- renderGrViz({
    grViz(
      get_graph(datamodel, rankdir = input$rankdir, view_type = input$view_type)
    )
    
  })
  output$downloadData <- downloadHandler(
    filename = "export.svg",
    content = function(file) {
      graph <- dm_create_graph(datamodel, 
                               graph_attrs = "bgcolor = '#F4F0EF', splines = ortho ",
                               rankdir = input$rankdir, view_type = input$view_type,
                               edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond",
                               node_attrs = "fontname = 'Arial'")
      dm_export_graph(graph, file, file_type = "svg");
    },
    contentType = "image/svg+xml"
  )
  output$downloadDataPng <- downloadHandler(
    filename = "export.png",
    content = function(file) {
      graph <- dm_create_graph(datamodel, 
                               graph_attrs = "bgcolor = '#F4F0EF', splines = ortho ",
                               rankdir = input$rankdir, view_type = input$view_type,
                               edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond",
                               node_attrs = "fontname = 'Arial'")
      dm_export_graph(graph, file, file_type = "png");
    },
    contentType = "image/png"
  )
}


# Run the application 
shinyApp(ui = ui, server = server)

