CLASS lhc_suplemento_reserva DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculoTotalPrecioReservaSupl FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Suplemento_Reserva~calculoTotalPrecioReservaSupl.

ENDCLASS.

CLASS lhc_suplemento_reserva IMPLEMENTATION.

  METHOD calculoTotalPrecioReservaSupl.
    IF keys IS NOT INITIAL.
      zcl_viaje_auxiliar_ags78=>calculate_price(
      it_travel_id = VALUE #( FOR GROUPS <booking_suppl> OF booksuppl_key IN keys
      GROUP BY booksuppl_key-ViajeId WITHOUT MEMBERS ( <booking_suppl> ) ) ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_save DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PUBLIC SECTION.
    CONSTANTS: create TYPE string VALUE 'C',
               update TYPE string VALUE 'U',
               delete TYPE string VALUE 'D'.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
ENDCLASS.

CLASS lcl_save IMPLEMENTATION.

  METHOD save_modified.

    DATA: lt_supplements TYPE STANDARD TABLE OF ztb_sup_rese_ags,
          lv_op_type     TYPE zde_tipo_operacion,
          lv_updated     TYPE zde_exito.

    IF NOT create-suplemento_reserva IS INITIAL.
      lt_supplements = CORRESPONDING #( create-suplemento_reserva ).
      lv_op_type = lcl_save=>create.
    ENDIF.
    IF NOT update-suplemento_reserva IS INITIAL.
      lt_supplements = CORRESPONDING #( update-suplemento_reserva ).
      lv_op_type = lcl_save=>update.
    ENDIF.

    IF NOT delete-suplemento_reserva IS INITIAL.
      lt_supplements = CORRESPONDING #( delete-suplemento_reserva ).
      lv_op_type = lcl_save=>delete.
    ENDIF.
    IF NOT lt_supplements IS INITIAL.

      CALL FUNCTION 'ZMF_SUPLEMENTOS_AGS78'
        EXPORTING
          values     = lt_supplements
          operation  = lv_op_type
        IMPORTING
          ev_updated = lv_updated.

      IF lv_updated EQ abap_true.
      ENDIF.

    ENDIF.


  ENDMETHOD.

ENDCLASS.
