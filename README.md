# Hierarchy-building

Code to build hierearchies and lineages when given rows of data with a child and parent element in each row. This is like a project I have worked on in the past, but the data, table names and column names are different. All data in the table is fictitious and not meant to represent project data in any real company. 

I will run you through the steps I took to import the data and build the hierarchy table. You are free to customize this to your situation as needed. Just because I did something one way doesn't mean you have to. 

(1) Creating Sample Data - I used AI to create legacy-project-table.xlsx from scratch. I do not have a copy of the original prompt, but I believe I did it in Claude.ai. 
------------------------------

The following paraphrases what I asked the AI to do for creating the data for legacy-project-table.xlsx and is my best recollection of what I did. If you used this prompt verbatim, it might not get you the same data that is in the file, but should get you close to where you could tweak it to get what you wanted. 

The prompt:

Create a CSV called legacy-project-table.csv (IIRC, Claude won't save to XLSX) of random project IDs based on a four-letter abbreviation for the departments: 'DLVY' for delivery; 'SHIP' for shipping; 'RCVG' for receiving; 'ACCT' for accounting; 'HRPR' for HR/Payroll; 'SALE' for Sales; and 'TECH' for IT.

The next six characters should be a date in yyyymm format, followed by a dash, then followed by a three-digit sequence with leading zeros. The sequence should impose uniqueness on the numbering. If there was already a DLVY202401-001 
indicating it is the first delivery project for January 2024, then the next delivery project would be DLVY2024001-002. 

The project description should be a subject appropriate to the department. You would not have 'DOT compliance training' for an accountant for example. 

Project start dates are in yyyymmdd format and can be random dates in 2024 to 2025. The project end date must be after the project start date and is in the same yyyymmdd format. If a project has an end date, its project active flag is 0, otherwise it is 1. 

If a project is no longer active, a project end reason must be provided: 'executive decision', 'funding', 'obsolete', 'scheduled end' are the only valid reasons.

Projects are structured in a hierarchy with parents and children. The child of a project can never begin before its parent begins. The ancestry of a project could span multiple generations. A parent project could have grandchildren and great-grandchildren. Children should be based on subject matter relevant to the parent project.  

Prompt ends here. I'll be sure to save my prompts in the future LOL. 

I took the added step of opening the CSV in Excel and saving it as XLSX. Just a preference. 


(2) Run the SQL Server Import and Export Wizard to import legacy-project-table.xlsx into a table called xlsx_projects.
------------------------------
Since there are countless ways an SQL Server database, its tables, and user access could be configured, I won't get into a detailed step-by-step process of how to use this wizard to import data into SQL Server. I am using SQL Server Developer Edition for this and pretty much have unlimited or near-unlimited rights over the tables I am populating. 

However you have your database setup, the end result is to have a table called xlsx_projects that conceptually is a clone of legacy-project_table.xlsx. 

In my particular case, I do not have the staging table xlsx_projects setup ahead of time. If it exists at the time I start the wizard I drop it before going on. I have had enough hassles with existing tables mucking up this wizard import process that I found it easier to just get rid of them before running the wizard. 

I also do not put any effort into configuring xlsx_projects. There is a step which sets the name of the destination to match the worksheet name from the source and puts a dollar sign in the name. I don't like that. Instead, I use 'xlsx_' as a prefix, followed by the name of the destination table, which will be 'projects'. 
