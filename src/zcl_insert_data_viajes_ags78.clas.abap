CLASS zcl_insert_data_viajes_ags78 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_insert_data_viajes_ags78 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lt_viaje    TYPE TABLE OF ztb_viajes_ags78,
          lt_reserva  TYPE TABLE OF ztb_reserva_ags,
          lt_rese_sup TYPE TABLE OF ztb_sup_rese_ags.

    SELECT travel_id     AS viaje_id,
           agency_id     AS agencia_id,
           customer_id   AS cliente_id,
           begin_date    AS fecha_desde,
           end_date      AS fecha_hasta,
           booking_fee   AS tarifa_reserva,
           total_price   AS precio_total,
           currency_code AS moneda,
           description   AS descripcion,
           status        AS estatus_general,
           createdby     AS creado_por,
           createdat     AS creado_el,
           lastchangedby AS modificado_por,
           lastchangedat AS modificado_el

    FROM /dmo/travel INTO CORRESPONDING FIELDS OF TABLE @lt_viaje
    UP TO 50 ROWS.

    SELECT travel_id     AS viaje_id,
           booking_id    AS reserva_id,
           booking_date  AS fecha_reserva,
           customer_id   AS cliente_id,
           carrier_id    AS transporte_id,
           connection_id AS conexion_id,
           flight_date   AS fecha_vuelo     ,
           flight_price  AS precio_vuelo    ,
           currency_code AS moneda
      FROM /dmo/booking
      FOR ALL ENTRIES IN @lt_viaje
                   WHERE travel_id EQ @lt_viaje-viaje_id
      INTO CORRESPONDING FIELDS OF TABLE @lt_reserva.

    SELECT travel_id             AS viaje_id,
           booking_id            AS reserva_id,
           booking_supplement_id AS reserva_sup_id,
           currency_code         AS moneda
      FROM /dmo/book_suppl
      FOR ALL ENTRIES IN @lt_reserva
                   WHERE travel_id EQ @lt_reserva-viaje_id
                     AND booking_id EQ @lt_reserva-reserva_id
     INTO CORRESPONDING FIELDS OF TABLE @lt_rese_sup.

    DELETE FROM: ztb_viajes_ags78,
                 ztb_reserva_ags,
                 ztb_sup_rese_ags.

    INSERT: ztb_viajes_ags78 FROM TABLE @lt_viaje,
            ztb_reserva_ags FROM TABLE @lt_reserva,
            ztb_sup_rese_ags FROM TABLE @lt_rese_sup.
    out->write( 'DONE!' ).

  ENDMETHOD.

ENDCLASS.

