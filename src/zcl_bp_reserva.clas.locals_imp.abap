CLASS lhc_Reserva DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculoTotalPrecioReserva FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Reserva~calculoTotalPrecioReserva.

    METHODS validarestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Reserva~validarestatus.

ENDCLASS.

CLASS lhc_Reserva IMPLEMENTATION.

  METHOD calculoTotalPrecioReserva.
    IF keys IS NOT INITIAL.
      zcl_viaje_auxiliar_ags78=>calculate_price(
      it_travel_id = VALUE #( FOR GROUPS <booking> OF booking_key IN keys
     GROUP BY booking_key-ViajeId WITHOUT MEMBERS ( <booking> ) ) ).
    ENDIF.
  ENDMETHOD.

  METHOD validarestatus.

    READ ENTITY z_i_viaje_ags78\\Reserva
    FIELDS ( EstatusReserva )
    WITH VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
    RESULT DATA(lt_Reserva_result).

    LOOP AT lt_Reserva_result INTO DATA(ls_Reserva_result).
      CASE ls_Reserva_result-EstatusReserva.
        WHEN 'N'. " New
        WHEN 'X'. " Canceled
        WHEN 'B'. " Booked
        WHEN OTHERS.
          APPEND VALUE #( %key = ls_Reserva_result-%key ) TO failed-reserva.
          APPEND VALUE #( %key = ls_Reserva_result-%key
          %msg = new_message( id = /dmo/cx_flight_legacy=>status_is_not_valid-msgid
          number = /dmo/cx_flight_legacy=>status_is_not_valid-msgno
          v1 = ls_Reserva_result-EstatusReserva
          severity = if_abap_behv_message=>severity-error )
          %element-EstatusReserva = if_abap_behv=>mk-on ) TO reported-reserva.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
