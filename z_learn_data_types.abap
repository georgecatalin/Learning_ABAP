*&---------------------------------------------------------------------*
*& Report Z_LEARN_DATA_TYPES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_learn_data_types.


* How to declare a constant
CONSTANTS pi TYPE f VALUE '3.14'.
CONSTANTS country_code TYPE c VALUE 'GB'.

* How to declare a variable
DATA my_var TYPE i VALUE 45.
DATA my_name TYPE c LENGTH 30 VALUE 'Paul'.
DATA my_mark TYPE p LENGTH 7 DECIMALS 2 VALUE '9.40'.


* How to Declare a Complex Type
TYPES: BEGIN OF struct_employee,
         surname  TYPE c LENGTH 30,
         forename TYPE c LENGTH 30,
       END OF struct_employee.

* -------------------------------------------------------------------------------------------------------------------------------------
* up until this point we are not able to store data in this type, we must create an object using this type for this purpose
* -------------------------------------------------------------------------------------------------------------------------------------

DATA this_employee TYPE struct_employee.

this_employee-surname = 'Ion'.
this_employee-forename = 'Popescu'.
