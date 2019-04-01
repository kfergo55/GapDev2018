---
title: "A Quick Data Model Visualization"
subtitle: "built with R and datamodelr"
author: "Kim Ferguson"
date: "2019-04-02"
output: 
  html_document:
      self_contained: false
      keep_md: true

---



class: inverse, center, middle

#  credit: [github.com/bergant/datamodelr](github.com/bergant/datamodelr)

---
class: center

# Visualizing Data at a High Level
<img src="https://raw.githubusercontent.com/kfergo55/QuickDataModel/master/images/Capture1.PNG", width= "70%" >


---
# So why build  a Data Model with datamodelr? 
It's a quick and effective way to communicate the structure of data...

.pull-left[
- **Includes** table names, column names, data types and key references

- **Includes** ability to use colors and pretty fonts 

- It's **Open Source** so no software license hassles.
 
]
.pull-right[
- **Doesn't Include** all UML bells and whistles.

-  for example: no ability to specify one-to-one, one-to-many or many-to-many relationships. (future enhancement perhaps?)

]
--

### It's especially handy when dealing with alternate data sources!

CSV files, Excel spreadsheets, even Spark tables. If you can read data into R as a dataframe you can visualize it as a data model with a little effort!
---

class: center, bottom, inverse

# It's so easy... Let's do this...
---
# First
- Download the code from github:  [https://github.com/kfergo55/QuickDataModel](https://github.com/kfergo55/QuickDataModel)  

--

## Next - what's the down low on our data?
- we'll use the public dataset for a fictitious bicycle company called Adventure Works. 

- It's spread across multiple sheets in 2 spreadsheets files 

- We are using the actual data "tables" and not the data definitions (they don't match anyway)

.footnote[
[1] To follow along: from RStudio, open file [https://github.com/kfergo55/QuickDataModel/datamodelrSamp.R](https://github.com/kfergo55/QuickDataModel/datamodelrSamp.R)

]

---
# Setup the Environment

```r
install.packages("datamodelr")
library(datamodelr)

install.packages("Diagrammer")
library(DiagrammeR)

install.packages("readxl")
library(readxl)
```
---
# Read the files


```r
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
```
##### variable names -> will be your table names, so choose wisely!
.footnote[


(the Adventure Works .xlsx files are in the github directory, peruse at your leisure)

]
---
### Here's a peek at the data frames in R...

Employee data: <table class="table" style="font-size: 9px; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Birth Date </th>
   <th style="text-align:right;"> Business Entity ID </th>
   <th style="text-align:left;"> Current Flag </th>
   <th style="text-align:left;"> Gender </th>
   <th style="text-align:left;"> Hire Date </th>
   <th style="text-align:left;"> Job Title </th>
   <th style="text-align:left;"> Login ID </th>
   <th style="text-align:left;"> Marital Status </th>
   <th style="text-align:left;"> Modified Date </th>
   <th style="text-align:right;"> National ID Number </th>
   <th style="text-align:left;"> Organization Node </th>
   <th style="text-align:left;"> Rowguid </th>
   <th style="text-align:left;"> Salaried Flag </th>
   <th style="text-align:right;"> Number of Records </th>
   <th style="text-align:right;"> Organization Level </th>
   <th style="text-align:right;"> Sick Leave Hours </th>
   <th style="text-align:right;"> Vacation Hours </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1963-03-02 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> M </td>
   <td style="text-align:left;"> 2003-02-15 </td>
   <td style="text-align:left;"> Chief Executive Officer </td>
   <td style="text-align:left;"> adventure-works\ken0 </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> 2008-07-31 </td>
   <td style="text-align:right;"> 295847284 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> F01251E5-96A3-448D-981E-0F99D789110D </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 69 </td>
   <td style="text-align:right;"> 99 </td>
  </tr>
</tbody>
</table>

 Salesperson data: <table class="table" style="font-size: 9px; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Business Entity ID </th>
   <th style="text-align:left;"> Modified Date </th>
   <th style="text-align:left;"> Rowguid </th>
   <th style="text-align:right;"> Sales Last Year </th>
   <th style="text-align:right;"> Territory ID </th>
   <th style="text-align:right;"> Bonus </th>
   <th style="text-align:right;"> Commission Pct </th>
   <th style="text-align:right;"> Number of Records </th>
   <th style="text-align:right;"> Sales Quota </th>
   <th style="text-align:right;"> Sales YTD </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 274 </td>
   <td style="text-align:left;"> 2005-01-28 </td>
   <td style="text-align:left;"> 48754992-9EE0-4C0E-8C94-9451604E3E02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 559697.6 </td>
  </tr>
</tbody>
</table>

 Contact data: <table class="table" style="font-size: 9px; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Additional Contact Info </th>
   <th style="text-align:right;"> BusinessEntityID (Person) </th>
   <th style="text-align:left;"> First Name </th>
   <th style="text-align:left;"> Last Name </th>
   <th style="text-align:left;"> Middle Name </th>
   <th style="text-align:left;"> ModifiedDate (Person) </th>
   <th style="text-align:left;"> Name Style </th>
   <th style="text-align:left;"> rowguid (Person) </th>
   <th style="text-align:left;"> Suffix </th>
   <th style="text-align:left;"> Title </th>
   <th style="text-align:right;"> Email Promotion </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Ken </td>
   <td style="text-align:left;"> Sánchez </td>
   <td style="text-align:left;"> J </td>
   <td style="text-align:left;"> 2003-02-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 92C4279F-1207-48A3-8448-4636514EB7E2 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>



---

Employee Pay History data: <table class="table" style="font-size: 9px; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Business Entity ID </th>
   <th style="text-align:left;"> Modified Date </th>
   <th style="text-align:left;"> Rate Change Date </th>
   <th style="text-align:right;"> Number of Records </th>
   <th style="text-align:right;"> Pay Frequency </th>
   <th style="text-align:right;"> Rate </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> 2008-07-31 </td>
   <td style="text-align:left;"> 2003-02-15 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 125.5 </td>
  </tr>
</tbody>
</table>

 Business Entity Address data: <table class="table" style="font-size: 9px; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Address ID </th>
   <th style="text-align:right;"> Address Type ID </th>
   <th style="text-align:right;"> Business Entity ID </th>
   <th style="text-align:left;"> Modified Date </th>
   <th style="text-align:left;"> Rowguid </th>
   <th style="text-align:right;"> Number of Records </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 249 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> 2008-10-13 11:15:07 </td>
   <td style="text-align:left;"> 3A5D0A00-6739-4DFE-A8F7-844CD9DEE3DF </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

  Address data: <table class="table" style="font-size: 9px; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Address ID </th>
   <th style="text-align:left;"> AddressLine1 </th>
   <th style="text-align:left;"> AddressLine2 </th>
   <th style="text-align:left;"> City </th>
   <th style="text-align:left;"> Country Region Code </th>
   <th style="text-align:left;"> Is Only State Province Flag </th>
   <th style="text-align:left;"> Modified Date </th>
   <th style="text-align:left;"> ModifiedDate (StateProvince) </th>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:left;"> Postal Code </th>
   <th style="text-align:left;"> Rowguid </th>
   <th style="text-align:left;"> rowguid (StateProvince) </th>
   <th style="text-align:left;"> Spatial Location </th>
   <th style="text-align:left;"> State Province Code </th>
   <th style="text-align:right;"> State Province ID </th>
   <th style="text-align:right;"> StateProvinceID (StateProvince) </th>
   <th style="text-align:right;"> Territory ID </th>
   <th style="text-align:right;"> Number of Records </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> 1970 Napa Ct. </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Bothell </td>
   <td style="text-align:left;"> US </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2002-01-04 </td>
   <td style="text-align:left;"> 2008-03-11 10:17:22 </td>
   <td style="text-align:left;"> Washington </td>
   <td style="text-align:left;"> 98011 </td>
   <td style="text-align:left;"> 9AADCB0D-36CF-483F-84D8-585C2D4EC6E9 </td>
   <td style="text-align:left;"> 16274DF0-6F05-43A6-BC18-AD171017A1EB </td>
   <td style="text-align:left;"> #Error </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:right;"> 79 </td>
   <td style="text-align:right;"> 79 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

 Sales Territory data: <table class="table" style="font-size: 9px; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> Cost Last Year </th>
   <th style="text-align:left;"> Country Region Code </th>
   <th style="text-align:left;"> Group </th>
   <th style="text-align:left;"> Modified Date </th>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:left;"> Rowguid </th>
   <th style="text-align:right;"> Sales Last Year </th>
   <th style="text-align:right;"> Territory ID </th>
   <th style="text-align:right;"> Cost YTD </th>
   <th style="text-align:right;"> Number of Records </th>
   <th style="text-align:right;"> Sales YTD </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:left;"> US </td>
   <td style="text-align:left;"> North America </td>
   <td style="text-align:left;"> 2002-06-01 </td>
   <td style="text-align:left;"> Northwest </td>
   <td style="text-align:left;"> 43689A10-E30B-497F-B0DE-11DE20267FF7 </td>
   <td style="text-align:right;"> 3298694 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 7887187 </td>
  </tr>
</tbody>
</table>

  

---
AND finally.. Sales Order data: <table class="table" style="font-size: 9px; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Account Number </th>
   <th style="text-align:right;"> Bill To Address ID </th>
   <th style="text-align:left;"> Comment </th>
   <th style="text-align:left;"> Credit Card Approval Code </th>
   <th style="text-align:right;"> Credit Card ID </th>
   <th style="text-align:right;"> Currency Rate ID </th>
   <th style="text-align:right;"> Customer ID </th>
   <th style="text-align:left;"> Due Date </th>
   <th style="text-align:left;"> Modified Date </th>
   <th style="text-align:left;"> Online Order Flag </th>
   <th style="text-align:left;"> Order Date </th>
   <th style="text-align:left;"> Purchase Order Number </th>
   <th style="text-align:right;"> Revision Number </th>
   <th style="text-align:left;"> Rowguid </th>
   <th style="text-align:right;"> Sales Order ID </th>
   <th style="text-align:left;"> Sales Order Number </th>
   <th style="text-align:right;"> Sales Person ID </th>
   <th style="text-align:left;"> Ship Date </th>
   <th style="text-align:right;"> Ship Method ID </th>
   <th style="text-align:right;"> Ship To Address ID </th>
   <th style="text-align:right;"> Territory ID </th>
   <th style="text-align:right;"> Freight </th>
   <th style="text-align:right;"> Number of Records </th>
   <th style="text-align:right;"> Status </th>
   <th style="text-align:right;"> Sub Total </th>
   <th style="text-align:right;"> Tax Amt </th>
   <th style="text-align:right;"> Total Due </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 10-4020-000001 </td>
   <td style="text-align:right;"> 832 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 105571Vi99678 </td>
   <td style="text-align:right;"> 19181 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29773 </td>
   <td style="text-align:left;"> 2005-08-13 </td>
   <td style="text-align:left;"> 2005-08-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2005-08-01 </td>
   <td style="text-align:left;"> PO16646146654 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> D2745233-B05B-409C-93BB-4451569F4253 </td>
   <td style="text-align:right;"> 43860 </td>
   <td style="text-align:left;"> SO43860 </td>
   <td style="text-align:right;"> 280 </td>
   <td style="text-align:left;"> 2005-08-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 832 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 330.4013 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 10993.394 </td>
   <td style="text-align:right;"> 1057.2843 </td>
   <td style="text-align:right;"> 12381.080 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000001 </td>
   <td style="text-align:right;"> 832 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 105516Vi99678 </td>
   <td style="text-align:right;"> 19181 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29773 </td>
   <td style="text-align:left;"> 2005-11-13 </td>
   <td style="text-align:left;"> 2005-11-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2005-11-01 </td>
   <td style="text-align:left;"> PO16646128920 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 1A116F86-71E4-40A2-A32C-4938D8977D26 </td>
   <td style="text-align:right;"> 44501 </td>
   <td style="text-align:left;"> SO44501 </td>
   <td style="text-align:right;"> 280 </td>
   <td style="text-align:left;"> 2005-11-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 832 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 591.1508 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 19669.411 </td>
   <td style="text-align:right;"> 1891.6827 </td>
   <td style="text-align:right;"> 22152.245 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000001 </td>
   <td style="text-align:right;"> 832 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 105493Vi99678 </td>
   <td style="text-align:right;"> 19181 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29773 </td>
   <td style="text-align:left;"> 2006-02-13 </td>
   <td style="text-align:left;"> 2006-02-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2006-02-01 </td>
   <td style="text-align:left;"> PO16646111452 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> F57AB920-675E-4B1D-B43C-8EA091CF6F38 </td>
   <td style="text-align:right;"> 45283 </td>
   <td style="text-align:left;"> SO45283 </td>
   <td style="text-align:right;"> 280 </td>
   <td style="text-align:left;"> 2006-02-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 832 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 851.6547 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 28395.219 </td>
   <td style="text-align:right;"> 2725.2950 </td>
   <td style="text-align:right;"> 31972.168 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000001 </td>
   <td style="text-align:right;"> 832 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 105533Vi99678 </td>
   <td style="text-align:right;"> 19181 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29773 </td>
   <td style="text-align:left;"> 2006-05-13 </td>
   <td style="text-align:left;"> 2006-05-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2006-05-01 </td>
   <td style="text-align:left;"> PO16646156443 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 62991BDA-C42D-494F-9EF1-2754BEC25FAE </td>
   <td style="text-align:right;"> 46042 </td>
   <td style="text-align:left;"> SO46042 </td>
   <td style="text-align:right;"> 280 </td>
   <td style="text-align:left;"> 2006-05-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 832 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 785.5880 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 26119.057 </td>
   <td style="text-align:right;"> 2513.8817 </td>
   <td style="text-align:right;"> 29418.527 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000002 </td>
   <td style="text-align:right;"> 833 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 15832Vi51504 </td>
   <td style="text-align:right;"> 10004 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29816 </td>
   <td style="text-align:left;"> 2006-08-13 </td>
   <td style="text-align:left;"> 2006-08-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2006-08-01 </td>
   <td style="text-align:left;"> PO14558186797 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 8A533BE6-0669-470A-B361-796DD1CD0ED4 </td>
   <td style="text-align:right;"> 46976 </td>
   <td style="text-align:left;"> SO46976 </td>
   <td style="text-align:right;"> 283 </td>
   <td style="text-align:left;"> 2006-08-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 297 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 230.4090 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 7759.388 </td>
   <td style="text-align:right;"> 737.3088 </td>
   <td style="text-align:right;"> 8727.105 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000002 </td>
   <td style="text-align:right;"> 833 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 15790Vi51504 </td>
   <td style="text-align:right;"> 10004 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29816 </td>
   <td style="text-align:left;"> 2006-11-13 </td>
   <td style="text-align:left;"> 2006-11-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2006-11-01 </td>
   <td style="text-align:left;"> PO14558139554 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 1FAAD98B-1DE0-4B80-A804-9FBBB6F289EB </td>
   <td style="text-align:right;"> 47997 </td>
   <td style="text-align:left;"> SO47997 </td>
   <td style="text-align:right;"> 283 </td>
   <td style="text-align:left;"> 2006-11-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 297 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 123.7465 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4162.956 </td>
   <td style="text-align:right;"> 395.9887 </td>
   <td style="text-align:right;"> 4682.691 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000002 </td>
   <td style="text-align:right;"> 833 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 15786Vi51504 </td>
   <td style="text-align:right;"> 10004 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29816 </td>
   <td style="text-align:left;"> 2007-02-13 </td>
   <td style="text-align:left;"> 2007-02-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2007-02-01 </td>
   <td style="text-align:left;"> PO14558112909 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 01C5EFDE-5C6E-47C9-B1AE-077937989297 </td>
   <td style="text-align:right;"> 49054 </td>
   <td style="text-align:left;"> SO49054 </td>
   <td style="text-align:right;"> 283 </td>
   <td style="text-align:left;"> 2007-02-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 297 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 39.3531 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 1320.635 </td>
   <td style="text-align:right;"> 125.9300 </td>
   <td style="text-align:right;"> 1485.918 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000002 </td>
   <td style="text-align:right;"> 833 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 15795Vi51504 </td>
   <td style="text-align:right;"> 10004 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29816 </td>
   <td style="text-align:left;"> 2007-05-13 </td>
   <td style="text-align:left;"> 2007-05-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2007-05-01 </td>
   <td style="text-align:left;"> PO14558158414 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 00A755D8-7BD9-4B12-AF58-E4EF22D39AA1 </td>
   <td style="text-align:right;"> 50216 </td>
   <td style="text-align:left;"> SO50216 </td>
   <td style="text-align:right;"> 283 </td>
   <td style="text-align:left;"> 2007-05-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 297 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 43.7900 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 1484.457 </td>
   <td style="text-align:right;"> 140.1279 </td>
   <td style="text-align:right;"> 1668.375 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000002 </td>
   <td style="text-align:right;"> 833 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 15862Vi51504 </td>
   <td style="text-align:right;"> 10004 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29816 </td>
   <td style="text-align:left;"> 2007-08-13 </td>
   <td style="text-align:left;"> 2007-08-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2007-08-01 </td>
   <td style="text-align:left;"> PO14558119777 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> C2B5D4CC-113E-4102-884B-22A6DACEEDE6 </td>
   <td style="text-align:right;"> 51728 </td>
   <td style="text-align:left;"> SO51728 </td>
   <td style="text-align:right;"> 283 </td>
   <td style="text-align:left;"> 2007-08-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 297 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 88.3542 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 3107.022 </td>
   <td style="text-align:right;"> 282.7334 </td>
   <td style="text-align:right;"> 3478.110 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10-4020-000003 </td>
   <td style="text-align:right;"> 559 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 38409Vi26986 </td>
   <td style="text-align:right;"> 5164 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29637 </td>
   <td style="text-align:left;"> 2005-09-13 </td>
   <td style="text-align:left;"> 2005-09-08 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 2005-09-01 </td>
   <td style="text-align:left;"> PO6786110112 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 0F0EB783-FA76-466D-9A0A-2F88C1C7EDE8 </td>
   <td style="text-align:right;"> 44124 </td>
   <td style="text-align:left;"> SO44124 </td>
   <td style="text-align:right;"> 277 </td>
   <td style="text-align:left;"> 2005-09-08 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 559 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 463.8954 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 15439.036 </td>
   <td style="text-align:right;"> 1484.4652 </td>
   <td style="text-align:right;"> 17387.396 </td>
  </tr>
</tbody>
</table>



        
---

class: center, bottom, inverse

# now we throw all of those dataframes at datamodelr... 

---
### datamodelr converts the data frames to a data model 


```r
datamodel <- dm_from_data_frames(EmployeeHR,
                                 BusinessEntityAddress,
                                 Salesperson, 
                                 Contact, 
                                 EmployeePayHistory, 
                                 Address, 
                                 SalesTerritory,  
                                 SalesOrderHeader)
```


---

### Do a little work here by connecting the data frames:


```r
datamodel <- dm_add_references(
  datamodel,
  BusinessEntityAddress$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  BusinessEntityAddress$`Address ID` == Address$`Address ID`,
  Salesperson$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  Contact$`BusinessEntityID (Person)` == EmployeeHR$`Business Entity ID`,
  EmployeePayHistory$`Business Entity ID` == EmployeeHR$`Business Entity ID`,
  Address$`Territory ID` == SalesTerritory$`Territory ID`,
  SalesOrderHeader$`Sales Person ID` == Salesperson$`Business Entity ID`,
  SalesOrderHeader$`Territory ID` == SalesTerritory$`Territory ID`)
```
#### This is where we join the keys. Child on the left, Parent on the right.
---
background-position: 50% 50%
class: center, bottom, inverse

# Nearly there...
---
### Now datamodelr will create and render the graph  

```r
graph <- dm_create_graph(datamodel, 
              graph_attrs = "rankdir = RL, bgcolor = '#F4F0EF', splines = ortho ", 
              edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond",
              node_attrs = "fontname = 'Arial'")

dm_render_graph(graph)
```

#### add in some extras...
- draw the graph from right to left (RL) 
- add a background color 
- square off the lines
- add a diamond connector to the parent table and a crows feet at the child table
- change the font to Arial
---
background-position: 50% 50%
class: center, bottom, inverse

# Voila...

---
<img src="https://raw.githubusercontent.com/kfergo55/QuickDataModel/master/downloadDataPng.png", width= "50%" >
---
## Shiny App Version:
<img src="https://raw.githubusercontent.com/kfergo55/QuickDataModel/master/images/Capture2.PNG", width= "90%" >
---

background-position: 50% 50%
class: center, bottom, inverse

# That's all folks...

---

class: center, middle

# Thanks!

Slides created via the R package [**xaringan**](https://github.com/yihui/xaringan).


(I should have called it Quick AND Easy Data Model!)
