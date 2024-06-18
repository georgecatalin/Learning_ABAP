*&---------------------------------------------------------------------*
*& Report Z_LEARN_POLYMORPHISM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_learn_polymorphism.


CLASS account DEFINITION ABSTRACT.  " This is an abstract class. it can not be instantianted, although it can be a superclass for other classes
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING i_account_holder TYPE string  " IMPORTING VALUE(something) is passing by value it means that a copy is passed, not the reference. Hence 'something' will not be modified.
                i_amount         TYPE f.

    METHODS withdraw ABSTRACT
      IMPORTING i_money                TYPE f
                i_within_notice_period TYPE string
      EXPORTING e_money                TYPE f.

    METHODS deposit ABSTRACT
      IMPORTING i_money TYPE f
      EXPORTING e_money TYPE f.

    METHODS get_account_holder
      RETURNING VALUE(r_account_holder) TYPE string.

  PROTECTED SECTION.
    DATA: account_holder TYPE string,
          balance        TYPE f.
ENDCLASS.


CLASS current_deposit DEFINITION INHERITING FROM account.
  PUBLIC SECTION.
    METHODS withdraw REDEFINITION.
    METHODS deposit REDEFINITION.
ENDCLASS.

CLASS notice30_deposit DEFINITION INHERITING FROM account.
  PUBLIC SECTION.
    METHODS withdraw REDEFINITION.
    METHODS deposit REDEFINITION.
ENDCLASS.


CLASS account IMPLEMENTATION.
  METHOD constructor.
    account_holder = i_account_holder .
    balance = i_amount.
    WRITE: / 'The account with Holder ', account_holder, ' and balance ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED , ' has been initialized now.'.
  ENDMETHOD.

  METHOD get_account_holder.
    r_account_holder = account_holder.
  ENDMETHOD.
ENDCLASS.

CLASS current_deposit IMPLEMENTATION.
  METHOD withdraw.
    WRITE: / 'Opening Balance ' , balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    IF i_money < balance.
      balance = balance - i_money.
    ELSE.
      WRITE: / 'You do not have sufficient funds for a withdrawal.'.
    ENDIF.
    WRITE: / 'Closing Balance : ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
  ENDMETHOD.

  METHOD deposit.
    WRITE: / 'Opening Balance ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
      balance = balance + i_money.
    e_money = i_money.
    WRITE: / 'Closing Balance : ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
  ENDMETHOD.
ENDCLASS.

CLASS notice30_deposit IMPLEMENTATION.
  METHOD withdraw.
    DATA penalty_balance TYPE f.

    IF i_within_notice_period = 'Y'.
      penalty_balance = balance * '0.95'.
    ELSE.
      penalty_balance = balance.
    ENDIF.

    WRITE: / 'Opening Balance: ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    IF i_money <= penalty_balance.
      balance = balance - ( i_money + ( balance * '0.05' ) ).
      e_money = i_money.

      IF i_within_notice_period = 'Y'.
        WRITE '   - PENALTY APPLIED'.
      ENDIF.
    ELSE.
      WRITE / 'You do not have sufficient funds for a Withdrawal in your account'.
    ENDIF.
    WRITE: / 'Closing Balance: ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
  ENDMETHOD.


  METHOD deposit.
    WRITE: / 'Opening Balance: ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    balance = balance + ( i_money * '1.001' ).
    e_money = i_money * '1.001'.
    WRITE: / 'Closing Balance: ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA: object_account         TYPE REF TO account,
        account_internal_table TYPE TABLE OF REF TO account,
        holder                 TYPE string,
        amount                 TYPE f.

  CREATE OBJECT object_account TYPE current_deposit
    EXPORTING
      i_account_holder = 'Paul Watson'
      i_amount         = 1000.
  APPEND object_account TO account_internal_table.

  CREATE OBJECT object_account TYPE notice30_deposit
    EXPORTING
      i_account_holder = 'James Twain'
      i_amount         = 2500.
  APPEND object_account TO account_internal_table.

  CREATE OBJECT object_account TYPE notice30_deposit
    EXPORTING
      i_account_holder = 'Michael Scorsese'
      i_amount         = 3000.
  APPEND object_account TO account_internal_table.

  CREATE OBJECT object_account TYPE notice30_deposit
    EXPORTING
      i_account_holder = 'Victor Wagner'
      i_amount         = 7500.
  APPEND object_account TO account_internal_table.

  CREATE OBJECT object_account TYPE current_deposit
    EXPORTING
      i_account_holder = 'Nicky Jeremy'
      i_amount         = 4000.
  APPEND object_account TO account_internal_table.

  LOOP AT account_internal_table INTO object_account.


    holder = object_account->get_account_holder( ).

    object_account->deposit( EXPORTING i_money = 500 IMPORTING e_money = amount ). " This is an appliance of polymorphism
    WRITE: / 'Deposit Transaction for ' , holder, ' to the sum of ' , amount EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    SKIP.

    object_account->withdraw( EXPORTING i_money = 250 i_within_notice_period = 'N' IMPORTING e_money = amount ).
    WRITE: / 'Withdrawal transaction for holder ', holder, ' to the sum of ', amount EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.


    holder = object_account->get_account_holder( ).

    object_account->deposit( EXPORTING i_money = 225 IMPORTING e_money = amount ). " This is an appliance of polymorphism
    WRITE: / 'Deposit Transaction for ' , holder, ' to the sum of ' , amount EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    SKIP.

    object_account->withdraw( EXPORTING i_money = 250 i_within_notice_period = 'N' IMPORTING e_money = amount ).
    WRITE: / 'Withdrawal transaction for holder ', holder, ' to the sum of ', amount EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.

    ULINE.

  ENDLOOP.
