
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

# store sheet names for tables - visual reference
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
datamodel <- dm_from_data_frames(EmployeeHR, EmployeeDeptHistory, BusinessEntityAddress,
                                 Salesperson, Contact, EmployeePayHistory, Address, 
                                 SalesTerritory, SalesOrderHeader)

# add the keys to the data model
datamodel <- dm_add_references(
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


# specify the graph to be read right to left
graph <- dm_create_graph(datamodel, 
                         graph_attrs = "rankdir = RL, bgcolor = '#F4F0EF', splines = ortho ", 
                         edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond",
                         node_attrs = "fontname = 'Arial'")
dm_render_graph(graph)


