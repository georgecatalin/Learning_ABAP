*&---------------------------------------------------------------------*
*& Report Z_LEARN_INTERFACES_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_LEARN_INTERFACES_1.


INTERFACE interface_speed.
  METHODS writespeed.
ENDINTERFACE.

CLASS train DEFINITION.
  PUBLIC SECTION.
    INTERFACES interface_speed.
    METHODS gofaster.
  PROTECTED SECTION.
    DATA speed TYPE i.
ENDCLASS.


CLASS train IMPLEMENTATION.
  METHOD interface_speed~writespeed.  " this is the implementation of the method in the class it owed to the interface
      WRITE: / 'The speed of the train is ', speed LEFT-JUSTIFIED.
  ENDMETHOD.

  METHOD gofaster.
    speed = speed + 1.
    WRITE: / 'The train has increased its speed.'.
  ENDMETHOD.

ENDCLASS.

* ------------------ Program starts here -------------

DATA object_train TYPE REF TO train.

START-OF-SELECTION.

CREATE OBJECT object_train.

object_train->gofaster( ).
object_train->interface_speed~writespeed( ).  " this is how the methods declared in the interfaces can be used in the program
