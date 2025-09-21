CLASS zcl_viaje_auxiliar_ags78 DEFINITION
PUBLIC
FINAL
CREATE PUBLIC .
  PUBLIC SECTION.
    TYPES tt_travel_id TYPE TABLE OF /dmo/travel_id.
    TYPES tt_travel_reported TYPE TABLE FOR REPORTED z_i_viaje_ags78.
    TYPES tt_booking_reported TYPE TABLE FOR REPORTED Z_I_reserva_AGS78.
    TYPES tt_bookingsupplement_reported TYPE TABLE FOR REPORTED z_i_reservasupl_ags78.
    CLASS-METHODS calculate_price IMPORTING it_travel_id TYPE tt_travel_id.
ENDCLASS.

CLASS zcl_viaje_auxiliar_ags78 IMPLEMENTATION.

  METHOD calculate_price.

    DATA: total_book_price_by_trav_curr  TYPE /dmo/total_price,
          total_suppl_price_by_trav_curr TYPE /dmo/total_price.

    IF it_travel_id IS INITIAL.
      RETURN.
    ENDIF.

    READ ENTITIES OF z_i_viaje_ags78
    ENTITY viaje
    FROM VALUE #( FOR lv_travel_id IN it_travel_id (
    ViajeId = lv_travel_id
    %control-Moneda = if_abap_behv=>mk-on ) )
    RESULT DATA(lt_read_travel).

    READ ENTITIES OF z_i_viaje_ags78
    ENTITY Viaje BY \_Reserva
    FROM VALUE #( FOR lv_travel_id IN it_travel_id (
    ViajeId = lv_travel_id
    %control-PrecioVuelo = if_abap_behv=>mk-on
    %control-ReservaId = if_abap_behv=>mk-on
    %control-moneda = if_abap_behv=>mk-on ) )
    RESULT DATA(lt_read_booking_by_travel).

    LOOP AT lt_read_booking_by_travel INTO DATA(ls_booking)
    GROUP BY ls_booking-ViajeId INTO DATA(ls_travel_key).

      ASSIGN lt_read_travel[ KEY entity COMPONENTS ViajeId = ls_travel_key ]
      TO FIELD-SYMBOL(<ls_travel>).

      LOOP AT GROUP ls_travel_key INTO DATA(ls_booking_result)
      GROUP BY ls_booking_result-Moneda INTO DATA(lv_curr).

        total_book_price_by_trav_curr = 0.
        LOOP AT GROUP lv_curr INTO DATA(ls_booking_line).
          total_book_price_by_trav_curr += ls_booking_line-PrecioVuelo.
        ENDLOOP.

        IF lv_curr = <ls_travel>-Moneda.
          <ls_travel>-PrecioTotal += total_book_price_by_trav_curr.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
          EXPORTING
          iv_amount = total_book_price_by_trav_curr
          iv_currency_code_source = lv_curr
          iv_currency_code_target = <ls_travel>-Moneda
          iv_exchange_rate_date = cl_abap_context_info=>get_system_date( )
          IMPORTING
          ev_amount = DATA(total_book_price_per_curr) ).
          <ls_travel>-PrecioTotal += total_book_price_per_curr.
        ENDIF.

      ENDLOOP.
    ENDLOOP.

    READ ENTITIES OF z_i_viaje_ags78
    ENTITY Reserva BY \_SuplementoReserva
    FROM VALUE #( FOR ls_travel IN lt_read_booking_by_travel (
    ViajeId = ls_travel-ViajeId
    ReservaId = ls_travel-ReservaId
    %control-Precio = if_abap_behv=>mk-on
    %control-Moneda = if_abap_behv=>mk-on ) )
    RESULT DATA(lt_read_booksuppl).

    LOOP AT lt_read_booksuppl INTO DATA(ls_booking_suppl)
    GROUP BY ls_booking_suppl-ViajeId INTO ls_travel_key.

      ASSIGN lt_read_travel[ KEY entity COMPONENTS ViajeId = ls_travel_key ] TO <ls_travel>.

      LOOP AT GROUP ls_travel_key INTO DATA(ls_bookingsuppl_result)
      GROUP BY ls_bookingsuppl_result-Moneda INTO lv_curr.

        total_suppl_price_by_trav_curr = 0.

        LOOP AT GROUP lv_curr INTO DATA(ls_booking_suppl2).
          total_suppl_price_by_trav_curr += ls_booking_suppl2-Precio.
        ENDLOOP.
        IF lv_curr = <ls_travel>-Moneda.
          <ls_travel>-PrecioTotal += total_suppl_price_by_trav_curr.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency( EXPORTING
          iv_amount = total_suppl_price_by_trav_curr
          iv_currency_code_source = lv_curr
          iv_currency_code_target = <ls_travel>-Moneda
          iv_exchange_rate_date = cl_abap_context_info=>get_system_date( )
          IMPORTING
          ev_amount = DATA(total_suppl_price_per_curr) ).
          <ls_travel>-PrecioTotal += total_suppl_price_per_curr.
        ENDIF.

      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF z_i_viaje_ags78
    ENTITY Viaje
    UPDATE FROM VALUE #( FOR travel IN lt_read_travel (
    ViajeId = travel-ViajeId
    PrecioTotal = travel-PrecioTotal
    %control-PrecioTotal = if_abap_behv=>mk-on ) )
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

  ENDMETHOD.
ENDCLASS.

