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
