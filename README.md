# Hierarchy-building

Code to build hierearchies and lineages when given rows of data with a child and parent element in each row. This is like a project I have worked on in the past, but the data, table names and column names are different. All data in the table is fictitious and not meant to represent project data in any real company. 

I will run you through the steps I took to import the data and build the hierarchy table. You are free to customize this to your situation as needed. Just because I did something one way doesn't mean you have to. 


(1) Creating Sample Data - I used AI to create legacy-project-table.xlsx from scratch. I do not have a copy of the original prompt, but I believe I did it in Claude.ai. 
------------------------------

The following paraphrases what I asked the AI to do for creating the data for legacy-project-table.xlsx and is my best recollection of what I did. If you used this prompt verbatim, it might not get you the same data that is in the file, but should get you close to where you could tweak it to get what you wanted. 

The prompt:

Create a CSV called legacy-project-table.csv (IIRC, Claude won't save to XLSX) of random project IDs based on a four-letter abbreviation for the departments: 'DLVY' for delivery; 'SHIP' for shipping; 'RCVG' for receiving; 'ACCT' for accounting; 'HRPR' for HR/Payroll; 'SALE' for Sales; and 'TECH' for IT.

The next six characters should be a date in yyyymm format, followed by a dash, then followed by a three-digit sequence with leading zeros. The sequence should impose uniqueness on the numbering. If there was already a DLVY202401-001 
indicating it is the first delivery project for January 2024, then the next delivery project would be DLVY202401-002. 

The project description should be a subject appropriate to the department. You would not have 'DOT compliance training' for an accountant for example. 

Project start dates are in yyyymmdd format and can be random dates in 2024 to 2025. The project end date must be after the project start date and is in the same yyyymmdd format. If a project has an end date, its project active flag is 0, otherwise it is 1. 

If a project is no longer active, a project end reason must be provided: 'executive decision', 'funding', 'obsolete', 'scheduled end' are the only valid reasons.

Projects are structured in a hierarchy with parents and children. The child of a project can never begin before its parent begins. The ancestry of a project could span multiple generations. A parent project could have grandchildren and great-grandchildren. Children should be based on subject matter relevant to the parent project.  

Prompt ends here. I'll be sure to save my prompts in the future LOL. 

I took the added step of opening the CSV in Excel and saving it as XLSX. Just a preference. 


(2) Run the SQL Server Import and Export Wizard to import legacy-project-table.xlsx into a table called xlsx_projects.
------------------------------
The final stop for the Excel data is a table named 'projects' but first it will be put in a staging table called 'xlsx_projects'. This is a convention based on personal preference that I follow. 

Since there are countless ways an SQL Server database, its tables, and user access could be configured, I won't get into a detailed step-by-step process of how to use this wizard to import data into SQL Server. 

My setup uses SQL Server Developer Edition for this and there are few, if any access rights limitations. 

However you have your database setup, the end result is to have a table called xlsx_projects that is structurally a clone of legacy-project_table.xlsx. 

The staging table xlsx_projects setup was not setup ahead of time. If it exists at the time I start the wizard I drop it before going on. 

I have had enough hassles with existing destination tables mucking up this wizard import process that it seemed easier to just get rid of them before running the wizard. 

I also don't do much configuration within the wizard other than to make sure all columns in the destination table (in this case xlsx_projects) are nullable and that the destination table name follows my naming conventions. This prevents data errors between legacy-project-table.xlsx and xlsx_projects from adding NULL values. If the data needs additional cleaning, it's better to do it in xlsx_projects than the Excel file. 


(3) Create the projects table using Step-01-CREATE-TABLE-projects.sql
-----------------------------
This creates the projects table where the staged data will eventually go. There is a CREATE TABLE statement without constraints and one with them that is commented out. 


(4) Run Step-02-XLSX-Wizard-Import-Conversion-and-Insert.sql
----------------------
There are some data issues that this script addresses. First, the PROJECT_START_DATE and PROJECT_END_DATE in xlsx_projects are in yyyymm format but treated as floats because the wizard in (2) converts data that appears to be numeric to float by default. As stated earlier, my preference is to do minimal conversion settings changes before completing the import and resolving the issue when the data gets moved from the staging table to the regular table. 

The project structure needs a little tweak too. Before this tweak, there are several top-level projects with no parent. I refer to this as an 'oligarchy' in the code's comments. It's better to have a sole monarchy for recursion IMHO, so this code adds a lone top level project that serves as an anchor project for the recursive CTE to be setup.

Then all the so-called oligarchs have their parent project set to the anchor project. 
