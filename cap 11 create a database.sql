/* -------------CREATE A DATABASE-------------------*/

/*SYNTAX: CREATE A DATABASE*/
CREATE DATABASE IF NOT EXISTS db_name;

/*SYNTAX DROP A DATABASE*/

DROP DATABASE IF EXISTS db_name;

/*SYNTAX: USE A DATABASE*/
/*The USE staten1ent selects the L pecified database and n1ak.e it the current database.*/
USE db_name;

/*SYNTAX: CREATE A TABLE*/
/*By default, this statement creates a new table in the current database.*/

CREATE TABLE data_base_name.name_table(
		column_name_1 data_type [column_attributes]
        [, column_name_2 data_type [column_attributes]]
        [, table_level_constrains];
        
/*EX*/

CREATE TABLE ex.vendors(
		vendor_id INT,
        vendor_name VARCHAR(50)
        );
        
CREATE TABLE ex.vendors(
		vendor_id INT    NOT NULL  UNIQUE AUTO_INCREMENT, /*no olvidar la coma. estamos enlistando*/
        vendor_name VARCHAR(50)    UNIQUE,
        invoice_total DECIMAL(9,2) NOT NULL
        );



