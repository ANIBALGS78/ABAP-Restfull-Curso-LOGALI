CLASS zcl_virtual_elm_viajes_ags78 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_virtual_elm_viajes_ags78 IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    IF iv_entity = 'Z_C_VIAJE_AGS78'.
      LOOP AT it_requested_calc_elements INTO DATA(ls_calc_elements).
        IF ls_calc_elements = 'DESCUENTO'.
          APPEND 'PRECIOTOTAL' TO et_requested_orig_elements.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA lt_original_data TYPE STANDARD TABLE OF z_c_viaje_ags78 WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).
    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<ls_original_data>).
      <ls_original_data>-descuento = <ls_original_data>-PrecioTotal - ( <ls_original_data>-PrecioTotal * ( 10 / 100 ) ).
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.

ENDCLASS.
