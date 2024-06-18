*&---------------------------------------------------------------------*
*& Report Z_RECAP_INTERNAL_TABLES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_recap_internal_tables.


* -----------------------------------------------------------------------
* STANDARD TABLES
* -----------------------------------------------------------------------

* How to define the structure
TYPES: BEGIN OF str_employee,
         surname  TYPE c LENGTH 40,
         forename TYPE c LENGTH 40,
         id       TYPE n LENGTH 8,
       END OF str_employee.


* How to define the internal table type
TYPES: ee1_tbl_type TYPE STANDARD TABLE OF str_employee. " we defined a table type without keys
TYPES: ee2_tbl_type TYPE STANDARD TABLE OF str_employee WITH NON-UNIQUE KEY surname forename. " we defined a table with non-unique keys

* How to instantiate the types
DATA: ee1_tbl1 TYPE ee1_tbl_type.
DATA: ee2_tbl2 TYPE ee2_tbl_type.


* --------------------------------------------------------------------------
* SORTED TABLES
* --------------------------------------------------------------------------

* How to define the structure
TYPES: BEGIN OF str_employee_1,
         surname  TYPE c LENGTH 40,
         forename TYPE c LENGTH 40,
         id       TYPE n LENGTH 8,
       END OF str_employee_1.

* How to define the table type
TYPES: ee_s_tbl_type TYPE SORTED TABLE OF str_employee_1 WITH UNIQUE KEY id.

* How to instantiate the table type
DATA ee_s_tbl TYPE ee_s_tbl_type.


* -----------------------------------------------------------------------------
* HASH TABLES
* -----------------------------------------------------------------------------

* How to define the structure
TYPES: BEGIN OF str2_employee,
         surname  TYPE c LENGTH 40,
         forename TYPE c LENGTH 40,
         id       TYPE n LENGTH 8,
       END OF str2_employee.


* How to define the table type
TYPES: ee_h_tbl_type TYPE HASHED TABLE OF str2_employee WITH UNIQUE KEY id.

* How to instantiate the table type
DATA ee_h_tbl TYPE ee_h_tbl_type.
