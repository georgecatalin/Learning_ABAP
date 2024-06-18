*&---------------------------------------------------------------------*
*& Report Z_RECAP_MODULARIZATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_recap_modularization.


* ------------------------------------------------------------------------
* RECAP ON MODULARIZATION
* ------------------------------------------------------------------------

* How to pass by value

DATA: my_var1 TYPE i VALUE 1978.

ULINE.
WRITE: / 'PASS BY VALUE EXAMPLE'.

PERFORM subroutine_1 USING my_var1.

my_var1 = 2011.
WRITE: / 'my_var1 from Calling program = ', my_var1.

ULINE.
WRITE: / 'PASS BY REFERENCE EXAMPLE'.

DATA: my_var2 TYPE i VALUE 1978.


PERFORM subroutine_2 USING my_var2.

WRITE: / 'my_var2 from Calling program = ', my_var2.


ULINE.
WRITE: / 'PASS BY VALUE AND RESULT EXAMPLE'.

DATA my_var3 TYPE i VALUE 1978.

PERFORM subroutine_3 CHANGING my_var3. " The value of the parameter is passed in the initial variable only if the subroutine executes properly

WRITE: / 'my_var3 from Calling program = ', my_var3.


*&---------------------------------------------------------------------*
*& Form subroutine_1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> MY_VAR1
*&---------------------------------------------------------------------*
FORM subroutine_1  USING  VALUE(my_var1).
  WRITE: / 'my_var1 from Subroutine (call be value) = ', my_var1.
ENDFORM.



*&---------------------------------------------------------------------*
*& Form subroutine_2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> MY_VAR2
*&---------------------------------------------------------------------*
FORM subroutine_2  USING p_my_var2.
  p_my_var2 = 1944.
  WRITE: / 'my_var1 from Subroutine (call be reference) = ', p_my_var2.
ENDFORM.





*&---------------------------------------------------------------------*
*& Form subroutine_3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- VALUE(MY_VAR2)
*&      <-- TYPE
*&      <-- ANY
*&---------------------------------------------------------------------*
FORM subroutine_3  CHANGING value(my_var3) TYPE ANY.

  my_var3 = 1977.
  WRITE: / 'my_var3 from Subroutine (call be reference) = ', my_var3. " the subroutine executes properly, hence my_var3 in the caller program takes the value 1977

ENDFORM.
