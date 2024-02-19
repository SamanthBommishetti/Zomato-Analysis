# Zomato-analysis
## Zomato SQL Database Readme

Welcome to the Zomato SQL Database repository! This repository contains a series of SQL scripts and queries that demonstrate various data analysis and exploration techniques on a sample dataset.
## Prerequisites
To use this repository, you will need a SQL database management system  (MySQL) and the ability to create and manipulate databases and tables.
## Database Setup
Create a new database named samanth
Import the Zomato.sql file into the samanth database.
## Database Structure
The database consists of the following tables:
### goldusers_signup: Stores the gold user signup dates.
### users: Stores the user signup dates.
### sales: Stores the sales data, including user ID, sale date, and product ID.
### product: Stores the product information, including product ID, product name, and price.
##Queries
The repository includes a variety of SQL queries that demonstrate different data analysis techniques. These queries are organized into sections:
Basic queries: Selecting all data from tables.
Data analysis: Calculating total amount spent by customers, number of days visited, first purchased product, most purchased item, and more.
Advanced queries: Using window functions (RANK() and DENSE_RANK()) and variables to perform more complex analysis.
