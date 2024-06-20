*&---------------------------------------------------------------------*
*& Report Z_LEARN_EVENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_LEARN_EVENTS.

CLASS chef DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.
    METHODS call_service.
    EVENTS call_for_waiter. " this is an event of the class 'chef'  -> another type of class components
ENDCLASS.


CLASS customer DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
              IMPORTING VALUE(i_tablenumber) TYPE i.

    METHODS call_for_assistance.

    EVENTS call_for_waiter EXPORTING VALUE(e_tablenumber) TYPE i. " this is the event of the class 'customer' -> another type of class component

  PROTECTED SECTION.
    DATA tablenumber TYPE i.
ENDCLASS.


CLASS waiter DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
                IMPORTING i_name TYPE string.
    METHODS go_see_the_chef FOR EVENT call_for_waiter of chef. " this is the event handler method specified for class waiter
    METHODS go_see_the_customer FOR EVENT call_for_waiter of customer IMPORTING e_tablenumber. " this is the event handler method specified for class waiter
  PROTECTED SECTION.
    DATA name_of_waiter type string.

ENDCLASS.


CLASS chef IMPLEMENTATION.
  METHOD constructor.
    WRITE: / 'The constructor of the chef class was called.'.
  ENDMETHOD.

  METHOD call_service.
    SKIP 2.
    WRITE: / 'Chef is calling the CALL_FOR_WAITER EVENT.'.
    RAISE EVENT call_for_waiter. " Events are triggered (raised) using the RAISE EVENT statement.
    WRITE: / 'Chef completed calling the CALL_FOR_WAITER EVENT.'.
  ENDMETHOD.
ENDCLASS.

CLASS customer IMPLEMENTATION .
  METHOD constructor.
    tablenumber = i_tablenumber.
    WRITE: / 'The constructor of the customer class was called.'.
  ENDMETHOD.

  METHOD call_for_assistance.
    SKIP 2.
    WRITE: / 'Customer is calling the CALL_FOR_WAITER event.'.
    RAISE EVENT call_for_waiter EXPORTING e_tablenumber = tablenumber.
    WRITE: / 'Customer completed the CALL_FOR_WAITER event.'.
  ENDMETHOD.

ENDCLASS.


CLASS waiter IMPLEMENTATION.
  METHOD constructor.
    name_of_waiter = i_name.
  ENDMETHOD.

  METHOD go_see_the_chef.
    WRITE: / 'Waiter ', name_of_waiter, ' goes to see the chef '.
  ENDMETHOD.


  METHOD go_see_the_customer.
    WRITE: / 'Waiter ', name_of_waiter, ' goes to serve customer at table ', e_tablenumber LEFT-JUSTIFIED.
  ENDMETHOD.

ENDCLASS.

* ------ Global data here ------
DATA: object_chef TYPE REF TO chef,
     object_customer_1 TYPE REF TO customer,
     object_customer_2 TYPE REF TO customer,
     object_waiter_1 TYPE REF TO waiter,
     object_waiter_2 TYPE REF TO waiter.

START-OF-SELECTION.

CREATE OBJECT object_chef.
CREATE OBJECT object_customer_1 EXPORTING i_tablenumber = 21.
CREATE OBJECT object_customer_2 EXPORTING i_tablenumber = 10.

CREATE OBJECT object_waiter_1 EXPORTING i_name = 'The Cornel'.
CREATE OBJECT object_waiter_2 EXPORTING i_name = 'Matei'.


* -- Classes or objects interested in an event must register their event handler methods using the SET HANDLER statement.
SET HANDLER object_waiter_1->go_see_the_chef FOR object_chef.
SET HANDLER object_waiter_2->go_see_the_customer FOR ALL INSTANCES. " this applies for all objects of class customer

* -- Now we are about to execute the methods that raise/trigger the events
object_chef->call_service( ).
object_customer_1->call_for_assistance( ).
object_customer_2->call_for_assistance( ).
