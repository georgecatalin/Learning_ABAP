*&---------------------------------------------------------------------*
*& Report Z_PRACTICE_CLASSES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_practice_classes.

CLASS Car DEFINITION.

  PUBLIC SECTION.
    CLASS-DATA: number_of_cars TYPE i.  " this is a static attribute for counting the number of objects

    CLASS-METHODS class_constructor.  " this is a static constructor -> Note down the use of the fixed name "class_constructor" . A static constructor gets invoked anytime when an object is created, a static attribute or static method is called in

    METHODS constructor   " this is the implementation of the object's constructor -> Note down the use of the fixed name "CONSTRUCTOR" for the name of the constructor.
      IMPORTING
        make            TYPE c
        model           TYPE c
        number_of_seats TYPE i
        max_speed       TYPE i.

    METHODS view. "  create a method to display the values of the attribute to validate visually the operations

    METHODS SetNumSeats
      IMPORTING numSeat TYPE i.

    METHODS GoFaster
      IMPORTING: increment TYPE i
      EXPORTING result TYPE i.

    METHODS GoSlower
      IMPORTING increment     TYPE i
      RETURNING VALUE(result) TYPE i.

  PRIVATE SECTION.
    DATA: make            TYPE c LENGTH 30,
          model           TYPE c LENGTH 30,
          number_of_seats TYPE i,
          speed           TYPE i,
          max_speed       TYPE i.

    CLASS-DATA varlog TYPE c LENGTH 50.

ENDCLASS.



CLASS Car IMPLEMENTATION.

  METHOD class_constructor.
    varlog = 'The static constructor was called in'.
    WRITE: / varlog.

  ENDMETHOD.

  METHOD constructor.
    me->make = make.
    me->model = model.
    me->number_of_seats = number_of_seats.
    me->max_speed = max_speed.

    number_of_cars = number_of_cars + 1. " increment the static attribute to count up each time a new object is created

  ENDMETHOD.

  METHOD view.
    WRITE: / 'Make = ',  make LEFT-JUSTIFIED.
    WRITE: / 'Model = ', model LEFT-JUSTIFIED.
    WRITE: / 'Number of seats = ', number_of_seats LEFT-JUSTIFIED.
    WRITE: / 'Max speed = ', max_speed LEFT-JUSTIFIED.
    WRITE: / 'Current speed = ', speed LEFT-JUSTIFIED.

    WRITE: / 'Number of objects created so far = ' , number_of_cars LEFT-JUSTIFIED.
  ENDMETHOD.



  METHOD SetNumSeats.
    number_of_seats = numSeat.
  ENDMETHOD.

  METHOD GoFaster.
    IF speed < max_speed.
      speed = speed + increment.
    ELSE.
      " do nothing
    ENDIF.
    result = speed.

  ENDMETHOD.


  METHOD GoSlower.
    IF speed > 0.
      speed = speed - increment.
    ELSE.
      " Do nothing
    ENDIF.
    result = speed.
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION. " this is an event to mark the execution of code from here downwards

  DATA: thisresult      TYPE i,
        returned_result TYPE i. " this variable is for showing the use of functional methods

  DATA: car1 TYPE REF TO Car, " declare an object reference variable here
        car2 TYPE REF TO Car.
  CREATE OBJECT car1        " create the object car1 here passing values to the parameters
    EXPORTING
      make            = 'Dacia'
      model           = 'Duster'
      number_of_seats = 4
      max_speed       = 180.

  car1->view( ). " this way to appeal to an instance method that has no parameters

  ULINE.

  CREATE OBJECT car2
    EXPORTING
      make            = 'Renault'
      model           = 'Espace'
      number_of_seats = 7
      max_speed       = 230.
  car2->view( ).

  ULINE.

  WRITE: / 'At this point, the total number of objects instantiated is ', car=>number_of_cars LEFT-JUSTIFIED. " this way we use static (public) attributes of a class


  car1->setnumseats( 5 ). " this manner we can make use of instance methods that have IMPORTING PARAMETERS
  car1->view( ).

  ULINE.

  car1->setnumseats( numseat = 6 ). " this manner we can make use of instance methods that have IMPORTING PARAMETERS
  car1->view( ).


  ULINE.
  WRITE: / 'Down below there are examples how to make use of instance methods that accept parameters and/or return results'.

  " method definition importing => method call exporting, method definition exporting => method call importing, method definition changing => method call changing, method definition returning => method call receiving.

  car2->gofaster( EXPORTING increment = 25 IMPORTING result = thisresult ).
  car2->view( ).

  ULINE.

  car2->goslower( EXPORTING increment = 10 RECEIVING result = thisresult ).
  car2->view( ).

  ULINE.

  returned_result = car2->goslower( 5 ).
  car2->view( ).
