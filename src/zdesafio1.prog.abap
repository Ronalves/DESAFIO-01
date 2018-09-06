*&---------------------------------------------------------------------*
*& Report ZDESAFIO1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdesafio1.
TABLES:sscrfields.

DATA:flag      TYPE i,
     vl_result TYPE i.

SELECTION-SCREEN: BEGIN OF BLOCK 2 WITH FRAME.
PARAMETERS: num1 TYPE i,
            num2 TYPE i.
SELECTION-SCREEN END OF BLOCK 2.

SELECTION-SCREEN: BEGIN OF BLOCK 1,
   BEGIN OF LINE,
  PUSHBUTTON 2(10)  but_soma  USER-COMMAND cli1,
  PUSHBUTTON 13(10) but_subt  USER-COMMAND cli2,
  PUSHBUTTON 24(10) but_mut   USER-COMMAND cli3,
  PUSHBUTTON 34(10) but_div   USER-COMMAND cli4
  VISIBLE LENGTH 10,
  END OF LINE,
END OF BLOCK 1.

INITIALIZATION.
  but_soma = '+'.
  but_subt = '-'.
  but_mut  = 'X'.
  but_div  = '/'.

AT SELECTION-SCREEN.

  CASE sscrfields-ucomm.
    WHEN 'CLI1'.
      flag = '1'.
      PERFORM soma USING num1 num2
             CHANGING vl_result.

      PERFORM show_result.
    WHEN 'CLI2'.
      flag = '2'.
      PERFORM subt USING num1 num2
                 CHANGING vl_result.

      PERFORM show_result.
    WHEN 'CLI3'.
      flag = '3'.
      PERFORM mut USING num1 num2
                   CHANGING vl_result.

      PERFORM show_result.
    WHEN 'CLI4'.
      flag = '4'.
      PERFORM div USING num1 num2
                 CHANGING vl_result.

      PERFORM show_result.
  ENDCASE.

CLASS zdesafio1_testes DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS: teste_soma_value FOR TESTING,
      teste_subt_value FOR TESTING,
      teste_mut_value FOR TESTING,
      teste_div_value FOR TESTING.

ENDCLASS.


START-OF-SELECTION.



END-OF-SELECTION.
CLASS zdesafio1_testes IMPLEMENTATION.

  METHOD teste_soma_value.

    DATA:vl_num1   TYPE i,
         vl_num2   TYPE i,
         vl_result TYPE i.

    vl_num1 = 5.
    vl_num2 = 7.

    PERFORM soma USING vl_num1 vl_num2
              CHANGING vl_result.

    cl_abap_unit_assert=>assert_equals( act = vl_result
                                        exp = 12
                                        msg = 'Soma não confere'
                                       ).

  ENDMETHOD.

  METHOD teste_subt_value.

    DATA:vl_num1   TYPE i,
         vl_num2   TYPE i,
         vl_result TYPE i.

    vl_num1 = 3.
    vl_num2 = 2.

    PERFORM subt USING vl_num1 vl_num2
                 CHANGING vl_result.

    cl_abap_unit_assert=>assert_equals( act = vl_result
                                        exp = 1
                                        msg = 'Subtração não confere'
                                        ).


  ENDMETHOD.

  METHOD teste_mut_value.

    DATA:vl_num1   TYPE i,
         vl_num2   TYPE i,
         vl_result TYPE i.

    vl_num1 = 2.
    vl_num2 = 4.

    PERFORM mut USING vl_num1 vl_num2
                CHANGING vl_result.


    cl_abap_unit_assert=>assert_equals( act = vl_result
                                        exp = 8
                                        msg = 'Multiplicação não confere'

    ).

  ENDMETHOD.

  METHOD teste_div_value.

    DATA:vl_num1   TYPE i,
         vl_num2   TYPE i,
         vl_result TYPE i.

    vl_num1 = 4.
    vl_num2 = 2.

    PERFORM div USING vl_num1 vl_num2
                CHANGING vl_result.

    cl_abap_unit_assert=>assert_equals( act = vl_result
                                        exp = 2
                                        msg = 'Divisão não Confere'
     ).

  ENDMETHOD.
ENDCLASS.
*&---------------------------------------------------------------------*
*& Form SOMA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM soma USING i_num1 i_num2
          CHANGING i_vl_result.

  i_vl_result = i_num1 + i_num2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SUBT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM subt USING i_num1 i_num2
CHANGING i_vl_result.

  i_vl_result = i_num1 - i_num2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM mut USING i_num1 i_num2
CHANGING i_vl_result.

  i_vl_result = i_num1 * i_num2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DIV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM div USING i_num1 i_num2
CHANGING i_vl_result.
  IF i_num2 <> 0.
    i_vl_result = i_num1 / i_num2.
  ELSE.
    WRITE: / 'Não dividir por zero'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_RESULT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
FORM show_result .

  cl_demo_output=>display( vl_result ).


ENDFORM.
