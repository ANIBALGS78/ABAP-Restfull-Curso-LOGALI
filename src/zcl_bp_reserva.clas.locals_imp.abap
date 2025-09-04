CLASS lhc_Reserva DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculoTotalPrecioReserva FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Reserva~calculoTotalPrecioReserva.

    METHODS validarestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reserva~validarestatus.

ENDCLASS.

CLASS lhc_Reserva IMPLEMENTATION.

  METHOD calculoTotalPrecioReserva.
  ENDMETHOD.

  METHOD validarestatus.
  ENDMETHOD.

ENDCLASS.
