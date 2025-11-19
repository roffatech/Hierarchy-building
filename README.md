# Hierarchy-building
Code to build hierearchies and lineages when given rows of data with a child and parent element in each row. This is like a project I have worked on in the past, but the data, table names and column names are different. All data in the table is fictitious and not meant to represent project data in any real company. 

I will run you through the steps I took to import the data and build the hierarchy table. You are free to customize this to your situation as needed. 

The file legacy-project-table.xlsx contains sample project data for an unnamed fictitious company. This data was imported into a table that I called xlsx_projects using the SQL Server Import and Export Wizard that I installed with the Developer Edition of SQL Server. 

When importing the Excel data into this table, the wizard will take its 'best guess' at defining the data types for the columns. I usually go with these default settings, although you can customize them. My preference is to import the Excel data into a staging table with the prefix 'xlsx_' in the name then use some form of "INSERT INTO reg_table_XXXX SELECT * FROM xlsx_XXXX" with reg_table_XXXX having the structure of its columns more rigidly defined. 
