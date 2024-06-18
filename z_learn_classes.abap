*&---------------------------------------------------------------------*
*& Report Z_LEARN_CLASSES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_learn_classes.


CLASS student DEFINITION.

  PUBLIC SECTION.
    DATA: name   TYPE c LENGTH 50,
          age    TYPE i,
          gender TYPE c LENGTH 1 READ-ONLY,
          status TYPE c LENGTH 1.

    CLASS-DATA counter TYPE i.  " this is a shared attributed that is available for all instances of the class


    METHODS set_name
      IMPORTING namein TYPE c.

    METHODS get_name
      EXPORTING nameout TYPE c.

    METHODS change_status
      CHANGING newstatus TYPE c.

* This is a functional method -> it returns a single value
    METHODS get_status_text
      IMPORTING VALUE(statuscode) TYPE c
      RETURNING VALUE(statustext)     TYPE string.



  PRIVATE SECTION.
    DATA: loginid  TYPE c LENGTH 20,
          password TYPE c LENGTH 40.

    " private methods go here if needed

ENDCLASS.

CLASS student IMPLEMENTATION.

  " here goes the logic for each method declared in the Class definition.

  METHOD set_name.
    name = namein. " the attribute takes the value of the parameter that is fed to the methods
  ENDMETHOD.


  METHOD get_name.
    nameout = name.
  ENDMETHOD.


  METHOD change_status.
    IF status CO 'MF'.
      status = newstatus.
      newstatus = '1'.
    ELSE.
      newstatus = '2'.
    ENDIF.
  ENDMETHOD.


   METHOD get_status_text.
     CASE statuscode.
     	WHEN '1'.
        statustext = 'Male'.
     	WHEN '2'.
        statustext = 'Female'.
     	WHEN OTHERS.
        statustext = 'Unknown'.
     ENDCASE.
   ENDMETHOD.


ENDCLASS.
