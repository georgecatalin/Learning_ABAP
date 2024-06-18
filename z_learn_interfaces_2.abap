*&---------------------------------------------------------------------*
*& Report Z_LEARN_INTERFACES_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_LEARN_INTERFACES_2.

* ---------------------------------------------------------------------
* this is an example that shows the use of ALIASES for Interface methods
* ----------------------------------------------------------------------

INTERFACE interface_speed.
  METHODS writespeed.
ENDINTERFACE.

CLASS train DEFINITION.
  PUBLIC SECTION.
    INTERFACES interface_speed.
      ALIASES writespeed FOR interface_speed~writespeed. " aliases are specified for interface methods in the CLASS DEFINITION
    METHODS gofaster.
  PROTECTED SECTION.
    DATA speed TYPE i.
ENDCLASS.


CLASS train IMPLEMENTATION.
   METHOD interface_speed~writespeed.
     WRITE: / 'The speed of the train is ', speed LEFT-JUSTIFIED.
   ENDMETHOD.

   METHOD gofaster.
     speed = speed + 1.
     WRITE: / 'The train has increased its speed. '.
   ENDMETHOD.

ENDCLASS.

* --- Program execution starts here ---

DATA object_train TYPE REF TO  train.

START-OF-SELECTION.

CREATE OBJECT object_train.

object_train->gofaster( ).

"WRITE: / 'Here the interface method is appealed normally. '.
"object_train->interface_speed~writespeed( ).

SKIP 2.

WRITE: / 'Here the interface method is appealed with its alias. '.
object_train->writespeed( ).
