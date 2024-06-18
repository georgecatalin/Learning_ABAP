*&---------------------------------------------------------------------*
*& Report Z_PRACTICE_INTERNAL_TBL_OOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_practice_internal_tbl_oop.

* General Guidelines
* The Class will have 1 attribute - an internal table that replicates all the data found in SPFLI.
* All access to the data must be through object Methods so the attribute should be private.
* Create methods to access all the data in the internal table.
* Create a constructor to fill the internal table from the Database.
*
* Methods:
* constructor - Load the records from SPFLI into the internal table attribute.
* showAllData - write out to the screen all of the data
* showConnidData - take in a connection ID and write out the following:
* City From, Country From, City To, Country to, Flight Time (in minutes), distance in KM/miles
* If no connection ID exists write out “No record found matching connid:” followed by the connection ID value passed in.
* numFlightsTo - take in an airport code (FRA, SFC etc..) and return the number of flights that travel to that airport.
* getConnid - this method will take in 2 airport codes, 1 representing the departure airport
*    and 1 representing the arrival airport.
*    Return the connection ID of the flight that matches.
*    If the parameter combination has no matching records return 0.
* getFlightTime - accepts a connection ID and returns the number of minutes in flight time.
* getAllConnectionFacts - take in a connection ID and return a structure that contains all the information
*     about that connection. This structure should correspond to a row in the table.

CLASS flights DEFINITION.

  PUBLIC SECTION.

    METHODS constructor. " implemented

    METHODS showAllData. " implemented

    METHODS showConnidData " implemented
      IMPORTING connection_id TYPE S_CONN_ID. " S_CONN_ID s the Data Element corresponding to the field 'connid' in SE11 for SPFLI

    METHODS numFlightsTo " implememented
      IMPORTING airport_code TYPE S_TOAIRP
      RETURNING VALUE(number_of_flights) TYPE i.

    METHODS getConnid  " implemented
       IMPORTING airport_departure TYPE S_FROMAIRP " S_FROMAIRP is the Data Element corresponding to the field 'airpfrom' in SE11 for SPFLI
                 airport_destination TYPE S_TOAIRP " S_TOAIRP is the Data Element corresponding to the field 'airpto' in SE11 for SPFLI
       RETURNING VALUE(connection_id) TYPE S_CONN_ID. " S_CONN_ID s the Data Element corresponding to the field 'connid' in SE11 for SPFLI

    METHODS getFlightTime " implemented
      IMPORTING connection_id TYPE S_CONN_ID
      RETURNING VALUE(minutes_flight_time) TYPE i.

    METHODS getAllConnectionFacts " implemented
      IMPORTING connection_id TYPE S_CONN_ID
      RETURNING VALUE(my_structure) TYPE SPFLI. " The structure returned is something similar to the work_area, except it is not the work area we are using to work with the Internal Table


  PRIVATE SECTION.
    TYPES: flights_table_type TYPE STANDARD TABLE OF spfli. " similarly working with Internal Tables in Procedural ABAP. At first define the type
    DATA:  flight_internal_table TYPE flights_table_type. " Create the internal table using the newly created type


ENDCLASS.



CLASS flights IMPLEMENTATION.

  METHOD constructor.
    SELECT * FROM spfli INTO TABLE flight_internal_table.

    IF sy-subrc <> 0.
      WRITE: / 'I have encountered an error while reading from the SPFLI database table.'.
    ENDIF.

ENDMETHOD.


METHOD showAllData.
  DATA: work_area TYPE SPFLI. " We use work_areas at all times when working with internal tables as it is the new way. We declare a work area of the same type as the database table SPFLI because it will hold the same fields

  LOOP AT flight_internal_table INTO work_area.
    " take the field names from SE11 ABAP Dictionary definion of the SPFLI database table
    WRITE: / work_area-carrid, 5 work_area-connid, 10 work_area-countryfr, 14 work_area-cityfrom, 36 work_area-airpfrom, 40 work_area-countryto,
      44 work_area-cityto, 66 work_area-airpto, 69 work_area-fltime, 77 work_area-deptime, 87 work_area-arrtime, 97 work_area-distance, 107 work_area-distid,
      110 work_area-fltype, 115 work_area-period.
  ENDLOOP.
  ULINE.

ENDMETHOD.

METHOD showConnidData.
  DATA: work_area TYPE SPFLI.

  READ TABLE flight_internal_table INTO work_area WITH KEY connid = connection_id. " the name of the field 'connid' is taken from SE11 ABAP Dictionary, structure of SPFLI

  IF sy-subrc = 0.
    WRITE: / work_area-cityfrom, 22 work_area-airpfrom, 27 work_area-countryto, 49 work_area-fltime, 54 work_area-distance. " the names of the fields are taken from the structure of SPFLI
  ELSE.
    WRITE: / 'No record was found for ', connection_id.
  ENDIF.

ENDMETHOD.

METHOD numFlightsTo.

  LOOP AT flight_internal_table TRANSPORTING NO FIELDS WHERE airpto = airport_code. " 'airpto' is the name of the field taken from SE11 ABAP Dictionary in SPFLI database table
    number_of_flights = number_of_flights + 1.
  ENDLOOP.

ENDMETHOD.

METHOD getConnid.
  DATA: work_area TYPE SPFLI.

  connection_id = 0.
  READ TABLE flight_internal_table INTO work_area WITH KEY airpfrom = airport_departure  airpto = airport_destination.

  connection_id = work_area-connid.

ENDMETHOD.

METHOD getFlightTime.
  DATA: work_area TYPE SPFLI.

  minutes_flight_time = 0.
  READ TABLE flight_internal_table INTO work_area WITH KEY connid = connection_id.

  minutes_flight_time = work_area-fltime.

ENDMETHOD.

METHOD getAllConnectionFacts.
  DATA: work_area TYPE SPFLI.

  CLEAR my_structure. " clear the structure to ensure it is empty
  READ TABLE flight_internal_table INTO my_structure WITH KEY connid = connection_id.

ENDMETHOD.


ENDCLASS.


START-OF-SELECTION.

DATA my_flight_object TYPE REF TO flights. " declare the object reference variable
CREATE OBJECT my_flight_object. " create the object

DATA temporary TYPE i.
DATA work_area TYPE spfli.

ULINE.
WRITE: / ' object->showalldata()'.

my_flight_object->showalldata( ).

ULINE.
WRITE: / ' object->showConnidData(connid)'.

my_flight_object->showconniddata( 1699 ).

ULINE.
WRITE: / ' object->numFlightsTo("JFK") '.

temporary = my_flight_object->numflightsto( 'JFK' ).
WRITE: / ' The number of flights to the set destination is ' , temporary.

ULINE.
WRITE: / ' object->getConnid( airport_departure = ..  airport_destination = ..)'.

temporary = my_flight_object->getconnid( airport_departure = 'JFK'  airport_destination = 'FRA').
WRITE: / ' The connection id of the flight between the two selected airports is ', temporary.

ULINE.
WRITE: / ' object->getFlightTime( connid )'.

temporary =  my_flight_object->getflighttime( 1984 ).
WRITE: / ' The flight time for the set connection id is ' , temporary.

ULINE.
WRITE: / ' object->getAllConnectionFacts( connID )'.

work_area = my_flight_object->getallconnectionfacts( 3504 ).
WRITE: / work_area-carrid, 5 work_area-connid, 10 work_area-countryfr, 14 work_area-cityfrom, 36 work_area-airpfrom, 40 work_area-countryto,
  44 work_area-cityto, 66 work_area-airpto, 69 work_area-fltime, 77 work_area-deptime, 87 work_area-arrtime, 97 work_area-distance, 107 work_area-distid,
  110 work_area-fltype, 115 work_area-period.
