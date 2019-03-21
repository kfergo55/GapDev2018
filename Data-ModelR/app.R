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

# assume home directory for location of files
excel_path1 <- "~/Adventure_Works_Data_Definitions.xlsx"
excel_path2 <- "~/Adventure_Works_version_2.xlsx"

# store sheet names for tables
table_names <- c("Employee (HR)","Employee Dept History",  
                 "Business Entity Address", "Sales Person",           
                 "Contact", "Employee Pay History",   
                 "Address", "Sales Territory",
                 "Sales Order Header")

# read in the sheets - 
EmployeeHR <- read_excel(path=excel_path1, sheet = 1)
EmployeeDeptHistory <- read_excel(path=excel_path1, sheet = 2)
BusinessEntityAddress <- read_excel(path=excel_path1, sheet = 3)
Salesperson <- read_excel(path=excel_path1, sheet = 4)
Contact <- read_excel(path=excel_path1, sheet = 5)
EmployeePayHistory <- read_excel(path=excel_path1, sheet = 6)
Address <- read_excel(path=excel_path1, sheet = 7)
SalesTerritory <- read_excel(path=excel_path1, sheet = 8)
SalesOrderHeader <- read_excel(path=excel_path1, sheet = 9)

# reshape each "table" into the format that datamodelr requires 
# first column contents becomes the column names 
# except for SalesTerritory and SalesOrderHeader as they are in the correct format
EmployeeHR <- as.data.frame(t(EmployeeHR$column))
names(EmployeeHR) <- as.character(unlist(EmployeeHR[1,]))

EmployeeDeptHistory <- as.data.frame(t(EmployeeDeptHistory$column))
names(EmployeeDeptHistory) <- as.character(unlist(EmployeeDeptHistory[1,]))

BusinessEntityAddress <- as.data.frame(t(BusinessEntityAddress$column))
names(BusinessEntityAddress) <- as.character(unlist(BusinessEntityAddress[1,]))

Salesperson <- as.data.frame(t(Salesperson$column))
names(Salesperson) <- as.character(unlist(Salesperson[1,]))

Contact <- as.data.frame(t(Contact$column))
names(Contact) <- as.character(unlist(Contact[1,]))

EmployeePayHistory <- as.data.frame(t(EmployeePayHistory$column))
names(EmployeePayHistory) <- as.character(unlist(EmployeePayHistory[1,]))

Address <- as.data.frame(t(Address$column))
names(Address) <- as.character(unlist(Address[1,]))

# use datamodelr:dm_from_data_frames to create the data model
dm <- dm_from_data_frames(EmployeeHR, EmployeeDeptHistory, BusinessEntityAddress,
                                 Salesperson, Contact, EmployeePayHistory, Address, 
                                 SalesTerritory, SalesOrderHeader)

# add the keys to the data model
dm <- dm_add_references(
  datamodel,
  EmployeeDeptHistory$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  BusinessEntityAddress$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  BusinessEntityAddress$AddressID == Address$AddressID,
  Salesperson$SalesPersonID == EmployeeHR$`Business Entity ID`,
  Contact$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  EmployeePayHistory$EmployeeID == EmployeeHR$`Business Entity ID`,
  Address$TerritoryID == SalesTerritory$`Territory ID`,
  SalesOrderHeader$`Sales Person ID` == Salesperson$SalesPersonID,
  SalesOrderHeader$`Territory ID` == SalesTerritory$`Territory ID`)

# SHINY ADAPTION - move the following block to the shiny server section
# and add the ability to pass parameters for viewing options
####################################################
# specify the graph to be read right to left
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
    graph <- dm_create_graph(dm, rankdir = rankdir, view_type = view_type)
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
      get_graph(dm, rankdir = input$rankdir, view_type = input$view_type)
    )
    
  })
  output$downloadData <- downloadHandler(
    filename = "export.svg",
    content = function(file) {
      graph <- dm_create_graph(dm, rankdir = input$rankdir, view_type = input$view_type)
      dm_export_graph(graph, file, file_type = "svg");
    },
    contentType = "image/svg+xml"
  )
  output$downloadDataPng <- downloadHandler(
    filename = "export.png",
    content = function(file) {
      graph <- dm_create_graph(dm, rankdir = input$rankdir, view_type = input$view_type)
      dm_export_graph(graph, file, file_type = "png");
    },
    contentType = "image/png"
  )
}


# Run the application 
shinyApp(ui = ui, server = server)

