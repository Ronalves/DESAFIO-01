*&---------------------------------------------------------------------*
*& Report ZDESAFIO1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdesafio1.
TABLES:sscrfields.
DATA:flag      TYPE i,
     vl_result TYPE i,
     vl_erro   TYPE abap_bool.

SELECTION-SCREEN BEGIN OF BLOCK 1 WITH FRAME.
PARAMETERS: val1 TYPE i,
            val2 TYPE i.
SELECTION-SCREEN END OF BLOCK 1.

SELECTION-SCREEN: BEGIN OF BLOCK 2,
BEGIN OF LINE,
  PUSHBUTTON 2(10) btn_soma USER-COMMAND btn1,
  PUSHBUTTON 13(10) btn_subt USER-COMMAND btn2,
  PUSHBUTTON 24(10) btn_mult USER-COMMAND btn3,
  PUSHBUTTON 34(10) btn_divi USER-COMMAND btn4,
END OF LINE.
SELECTION-SCREEN END OF BLOCK 2.

CLASS calculadora DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      faz_soma RETURNING VALUE(resultado) TYPE i EXCEPTIONS erro_soma,
      faz_subtracao RETURNING VALUE(resultado) TYPE i EXCEPTIONS erro_subtracao,
      faz_multiplicacao RETURNING VALUE(resultado) TYPE i EXCEPTIONS erro_multiplicacao,
      faz_divisao RETURNING VALUE(resultado) TYPE i EXCEPTIONS erro_divisao.
ENDCLASS.

CLASS calculadora IMPLEMENTATION.
  METHOD faz_soma.
    TRY.
        resultado = val1 + val2.
      CATCH cx_static_check.
        RAISE erro_soma.
    ENDTRY.
  ENDMETHOD.
  METHOD faz_subtracao.
    TRY.
        resultado = val1 - val2.
      CATCH cx_static_check.
        RAISE erro_subtracao.
    ENDTRY.
  ENDMETHOD.
  METHOD faz_multiplicacao.
    TRY.
        resultado = val1 * val2.
      CATCH cx_static_check.
        RAISE erro_multiplicacao.
    ENDTRY.
  ENDMETHOD.
  METHOD faz_divisao.
    TRY.
        resultado = val1 / val2.
      CATCH cx_sy_zerodivide.
        MESSAGE e001(00) WITH 'No Divide By Zero' RAISING erro_divisao.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
CLASS calculadora_aunit DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS:
      teste_soma_value FOR TESTING,
      teste_subt_value FOR TESTING,
      teste_mut_value  FOR TESTING,
      teste_div_value  FOR TESTING.
ENDCLASS.
CLASS calculadora_aunit IMPLEMENTATION.
  METHOD teste_soma_value.
    DATA:vl_result TYPE i.
    val1 = 8.
    val2 = 7.
    vl_result = NEW calculadora( )->faz_soma( ).

    cl_abap_unit_assert=>assert_equals( act = vl_result
    exp = 15
    msg = 'Soma não confere'
    ).
  ENDMETHOD.
  METHOD teste_subt_value.
    DATA:vl_result TYPE i.
    val1 = 8.
    val2 = 7.
    vl_result = NEW calculadora( )->faz_subtracao( ).

    cl_abap_unit_assert=>assert_equals( act = vl_result
    exp = 1
    msg = 'Subtração não confere'
    ).
  ENDMETHOD.
  METHOD teste_mut_value.
    DATA:vl_result TYPE i.
    val1 = 8.
    val2 = 7.
    vl_result = NEW calculadora( )->faz_multiplicacao( ).

    cl_abap_unit_assert=>assert_equals( act = vl_result
    exp = 56
    msg = 'Multiplicação não confere'
    ).
  ENDMETHOD.
  METHOD teste_div_value.
    DATA:vl_result TYPE i.
    val1 = 8.
    val2 = 8.
    vl_result = NEW calculadora( )->faz_divisao( ).

    cl_abap_unit_assert=>assert_equals( act = vl_result
    exp = 1
    msg = 'Divisão não confere'
    ).
  ENDMETHOD.
ENDCLASS.

INITIALIZATION.
  btn_soma = '+'.
  btn_subt = '-'.
  btn_mult = 'x'.
  btn_divi = '/'.

AT SELECTION-SCREEN.
  cl_demo_output=>display( SWITCH string( sscrfields-ucomm
  WHEN 'BTN1' THEN |Resultado: { NEW calculadora( )->faz_soma( ) }|
  WHEN 'BTN2' THEN |Resultado: { NEW calculadora( )->faz_subtracao( ) }|
  WHEN 'BTN3' THEN |Resultado: { NEW calculadora( )->faz_multiplicacao( ) }|
  WHEN 'BTN4'  THEN |Resultado: { NEW calculadora( )->faz_divisao( ) }| ) ).
