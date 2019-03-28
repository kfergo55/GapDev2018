
#####################################
# Reshape data for use in datamodelr
# Use this code for testing prior to 
# adapting to shiny or on it's own.


# 
# setup the environment first

#install.packages("datamodelr")
#library(datamodelr)

library(devtools)
#install_github("bergant/datamodelr")
library(datamodelr)
library(DiagrammeR)
library(V8)

#install.packages("readxl")
library(readxl)

######################################
# Read in the Excel files

# assume home directory for location of files
excel_path1 <- "~/Adventure_Works_Data_Definitions.xlsx"
excel_path2 <- "~/Adventure_Works_version_2.xlsx"

# read in the sheets - 
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


# specify the graph to be read right to left
graph <- dm_create_graph(datamodel, 
                         graph_attrs = "rankdir = RL, bgcolor = '#F4F0EF', splines = ortho ", 
                         edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond",
                         node_attrs = "fontname = 'Arial'")
dm_render_graph(graph)

