CLASS lhc_Viaje DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Viaje RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Viaje RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Viaje RESULT result.

    METHODS aceptar_viaje FOR MODIFY
      IMPORTING keys FOR ACTION Viaje~aceptar_viaje RESULT result.

    METHODS crear_viaje_con_plantilla FOR MODIFY
      IMPORTING keys FOR ACTION Viaje~crear_viaje_con_plantilla RESULT result.

    METHODS rechazar_viaje FOR MODIFY
      IMPORTING keys FOR ACTION Viaje~rechazar_viaje RESULT result.

    METHODS calculoTotalPrecioVuelo FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Viaje~calculoTotalPrecioVuelo.

    METHODS validarcliente FOR VALIDATE ON SAVE
      IMPORTING keys FOR Viaje~validarcliente.

    METHODS validarestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Viaje~validarestatus.

    METHODS validarfecha FOR VALIDATE ON SAVE
      IMPORTING keys FOR Viaje~validarfecha.

ENDCLASS.

CLASS lhc_Viaje IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITY z_i_viaje_ags78
    FROM VALUE #( FOR keyval IN keys ( %key = keyval-%key ) )
    RESULT DATA(lt_travel_result).
    result = VALUE #( FOR ls_travel IN lt_travel_result (
    %key = ls_travel-%key
    %field-ViajeId = if_abap_behv=>fc-f-read_only
    %features-%action-rechazar_viaje = COND #( WHEN ls_travel-EstatusGeneral = 'X'
    THEN if_abap_behv=>fc-o-disabled
    ELSE if_abap_behv=>fc-o-enabled )
    %features-%action-aceptar_viaje = COND #( WHEN ls_travel-EstatusGeneral = 'A'
    THEN if_abap_behv=>fc-o-disabled
    ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

    DATA(lv_auth) = COND #( WHEN cl_abap_context_info=>get_user_technical_name( ) EQ 'CB9980002978'
                    THEN if_abap_behv=>auth-allowed
                    ELSE if_abap_behv=>auth-unauthorized ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).
      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<ls_result>).
      <ls_result> = VALUE #( %key = <ls_keys>-%key
      %op-%update = lv_auth
      %delete = lv_auth
      %action-crear_viaje_con_plantilla = lv_auth
      %action-aceptar_viaje = lv_auth
      %action-rechazar_viaje = lv_auth
      %assoc-_Reserva = lv_auth ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD aceptar_viaje.

    MODIFY ENTITIES OF z_i_viaje_ags78 IN LOCAL MODE
    ENTITY viaje
    UPDATE FIELDS ( EstatusGeneral )
    WITH VALUE #( FOR key IN keys ( ViajeId = key-ViajeId
    EstatusGeneral = 'A' ) ) " Aceptado
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF z_i_viaje_ags78 IN LOCAL MODE
    ENTITY Viaje
    FIELDS ( AgenciaId
             ClienteId
             FechaDesde
             FechaHasta
             TarifaReserva
             PrecioTotal
             Moneda
             EstatusGeneral
             Descripcion
             CreadoPor
             CreadoEl
             ModificadoEl
             ModificadoPor )
    WITH VALUE #( FOR key IN keys ( ViajeId = key-ViajeId ) )
    RESULT DATA(lt_viaje).
    result = VALUE #( FOR viaje IN lt_viaje ( ViajeId = viaje-ViajeId
    %param = viaje ) ).

    LOOP AT lt_viaje ASSIGNING FIELD-SYMBOL(<fs_viajes>).
      APPEND VALUE #( viajeid = <fs_viajes>-ViajeId
                      %msg = new_message( id       = 'ZCM_MENSAJES'
                                          number   = '001'
                                          v1       = <fs_viajes>-EstatusGeneral
                                          severity = if_abap_behv_message=>severity-success )
                           %element-EstatusGeneral = if_abap_behv=>mk-on ) TO reported-viaje.
    ENDLOOP.

  ENDMETHOD.

  METHOD crear_viaje_con_plantilla.

    SELECT MAX( viaje_id ) FROM ztb_viajes_ags78 INTO @DATA(lv_travel_id).
    READ ENTITY z_i_viaje_ags78
    FIELDS ( ViajeId AgenciaId ClienteId TarifaReserva PrecioTotal Moneda )
    WITH VALUE #( FOR viaje IN keys ( %key = viaje-%key ) )
    RESULT DATA(lt_read_result)
    FAILED failed
    REPORTED reported.

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).
    DATA lt_create TYPE TABLE FOR CREATE z_i_viaje_ags78\\Viaje.

    lt_create = VALUE #( FOR row IN lt_read_result INDEX INTO idx
    ( ViajeId        = lv_travel_id + idx
      AgenciaId      = row-AgenciaId
      ClienteId      = row-ClienteId
      FechaDesde     = lv_today
      FechaHasta     = lv_today + 30
      TarifaReserva  = row-TarifaReserva
      PrecioTotal    = row-PrecioTotal
      moneda         = row-moneda
      Descripcion    = 'Commentar aquí'
      EstatusGeneral = 'O' ) ).

    MODIFY ENTITIES OF z_i_viaje_ags78
    IN LOCAL MODE ENTITY Viaje
    CREATE FIELDS ( ViajeId
                    AgenciaId
                    ClienteId
                    FechaDesde
                    FechaHasta
                    TarifaReserva
                    PrecioTotal
                    moneda
                    Descripcion
                    EstatusGeneral )
             WITH lt_create
             MAPPED mapped
             FAILED failed
             REPORTED reported.
    result = VALUE #( FOR create IN lt_create INDEX INTO idx
    ( %cid_ref = keys[ idx ]-%cid_ref
    %key = keys[ idx ]-ViajeId
    %param = CORRESPONDING #( create ) ) ).

  ENDMETHOD.

  METHOD rechazar_viaje.

    MODIFY ENTITIES OF z_i_viaje_ags78 IN LOCAL MODE
    ENTITY viaje
    UPDATE FIELDS ( EstatusGeneral )
    WITH VALUE #( FOR key IN keys ( ViajeId = key-ViajeId
    EstatusGeneral = 'X' ) ) " Rechazado
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF z_i_viaje_ags78 IN LOCAL MODE
    ENTITY Viaje
    FIELDS ( AgenciaId
             ClienteId
             FechaDesde
             FechaHasta
             TarifaReserva
             PrecioTotal
             Moneda
             EstatusGeneral
             Descripcion
             CreadoPor
             CreadoEl
             ModificadoEl
             ModificadoPor )
    WITH VALUE #( FOR key IN keys ( ViajeId = key-ViajeId ) )
    RESULT DATA(lt_viaje).
    result = VALUE #( FOR viaje IN lt_viaje ( ViajeId = viaje-ViajeId
    %param = viaje ) ).

    LOOP AT lt_viaje ASSIGNING FIELD-SYMBOL(<fs_viajes>).
      APPEND VALUE #( viajeid = <fs_viajes>-ViajeId
                      %msg = new_message( id       = 'ZCM_MENSAJES'
                                          number   = '002'
                                          v1       = <fs_viajes>-EstatusGeneral
                                          severity = if_abap_behv_message=>severity-success )
                           %element-EstatusGeneral = if_abap_behv=>mk-on ) TO reported-viaje.
    ENDLOOP.

  ENDMETHOD.

  METHOD calculoTotalPrecioVuelo.

    IF keys IS NOT INITIAL.
      zcl_viaje_auxiliar_ags78=>calculate_price(
      it_travel_id = VALUE #( FOR GROUPS <booking> OF booking_key IN keys
      GROUP BY booking_key-ViajeId WITHOUT MEMBERS ( <booking> ) ) ).
    ENDIF.

  ENDMETHOD.

  METHOD validarcliente.

    READ ENTITIES OF z_i_viaje_ags78 IN LOCAL MODE
    ENTITY Viaje
    FIELDS ( ClienteId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_viaje).

    DATA lt_cliente TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.
    lt_cliente = CORRESPONDING #( lt_viaje DISCARDING DUPLICATES MAPPING customer_id = ClienteId EXCEPT * ).
    DELETE lt_cliente WHERE customer_id IS INITIAL.
    IF lt_cliente IS NOT INITIAL.
      SELECT FROM /dmo/customer FIELDS customer_id
      FOR ALL ENTRIES IN @lt_cliente
      WHERE customer_id = @lt_cliente-customer_id
      INTO TABLE @DATA(lt_customer_db).
    ENDIF.
    LOOP AT lt_viaje INTO DATA(ls_viaje).
      IF ls_viaje-ClienteId IS INITIAL
      OR NOT line_exists( lt_customer_db[ customer_id = ls_viaje-ClienteId ] ).
        APPEND VALUE #( viajeid = ls_viaje-ClienteId ) TO failed-viaje.
        APPEND VALUE #( viajeid = ls_viaje-ClienteId
        %msg     = new_message( id = '/DMO/CM_FLIGHT_LEGAC'
        number   = '002'
        v1       = ls_viaje-ClienteId
        severity = if_abap_behv_message=>severity-error )
        %element-viajeid = if_abap_behv=>mk-on ) TO reported-viaje.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validarestatus.

    READ ENTITY z_i_viaje_ags78\\Viaje FIELDS ( EstatusGeneral ) WITH
    VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
    RESULT DATA(lt_viaje_result).

    LOOP AT lt_viaje_result INTO DATA(ls_viaje_result).
      CASE ls_viaje_result-EstatusGeneral.
        WHEN 'O'. " Open
        WHEN 'X'. " Cancelled
        WHEN 'A'. " Accepted
        WHEN OTHERS.
          APPEND VALUE #( %key = ls_viaje_result-%key ) TO failed-viaje.
          APPEND VALUE #( %key = ls_viaje_result-%key
          %msg = new_message( id = /dmo/cx_flight_legacy=>status_is_not_valid-msgid
          number = /dmo/cx_flight_legacy=>status_is_not_valid-msgno
          v1 = ls_viaje_result-EstatusGeneral
          severity = if_abap_behv_message=>severity-error )
          %element-EstatusGeneral = if_abap_behv=>mk-on ) TO reported-viaje.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD validarfecha.

    READ ENTITY z_i_viaje_ags78\\Viaje FIELDS ( FechaDesde FechaHasta ) WITH
    VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
    RESULT DATA(lt_viaje_result).

    LOOP AT lt_viaje_result INTO DATA(ls_viaje_result).
      IF ls_viaje_result-FechaHasta < ls_viaje_result-FechaDesde.
        APPEND VALUE #( %key = ls_viaje_result-%key
        viajeid = ls_viaje_result-ViajeId ) TO failed-viaje.
        APPEND VALUE #( %key = ls_viaje_result-%key
        %msg = new_message( id = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgid
        number = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgno
        v1 = ls_viaje_result-FechaDesde
        v2 = ls_viaje_result-FechaHasta
        v3 = ls_viaje_result-ViajeId
        severity = if_abap_behv_message=>severity-error )
        %element-FechaDesde = if_abap_behv=>mk-on
        %element-FechaHasta = if_abap_behv=>mk-on ) TO reported-viaje.
      ELSEIF ls_viaje_result-FechaDesde < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %key = ls_viaje_result-%key
        viajeid = ls_viaje_result-ViajeId ) TO failed-viaje.
        APPEND VALUE #( %key = ls_viaje_result-%key
        %msg = new_message( id = /dmo/cx_flight_legacy=>begin_date_before_system_date-msgid
        number = /dmo/cx_flight_legacy=>begin_date_before_system_date-msgno
        severity = if_abap_behv_message=>severity-error )
        %element-fechadesde = if_abap_behv=>mk-on
        %element-fechahasta = if_abap_behv=>mk-on ) TO reported-viaje.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_I_VIAJE_AGS78 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z_I_VIAJE_AGS78 IMPLEMENTATION.

  METHOD save_modified.

    DATA: lt_viaje_log   TYPE STANDARD TABLE OF ztb_log_ags78,
          lt_viaje_log_u TYPE STANDARD TABLE OF ztb_log_ags78.
    DATA(lv_flag) = cl_abap_behv=>flag_changed.
    DATA(lv_mk_on) = if_abap_behv=>mk-on.
    DATA(lv_user_mod) = cl_abap_context_info=>get_user_technical_name( ).

    IF create-viaje IS NOT INITIAL.

      lt_viaje_log = CORRESPONDING #( create-viaje ).

      LOOP AT lt_viaje_log ASSIGNING FIELD-SYMBOL(<fs_viaje_log_c>).

        GET TIME STAMP FIELD <fs_viaje_log_c>-creado_el.
        <fs_viaje_log_c>-operacion_modificacion = 'CREATE'.

        READ TABLE create-viaje WITH TABLE KEY entity COMPONENTS ViajeId = <fs_viaje_log_c>-viajeid
        INTO DATA(ls_viaje). IF sy-subrc = 0.
          IF ls_viaje-%control-TarifaReserva = lv_flag.
            <fs_viaje_log_c>-campo_modificado = 'TarifaReserva'.
            <fs_viaje_log_c>-valor_modificado = ls_viaje-TarifaReserva.
            <fs_viaje_log_c>-modificado_por = lv_user_mod.
            TRY.
                <fs_viaje_log_c>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
            ENDTRY.
            APPEND <fs_viaje_log_c> TO lt_viaje_log_u.
          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDIF.

    IF update-viaje IS NOT INITIAL.

      lt_viaje_log = CORRESPONDING #( update-viaje ).

      LOOP AT update-viaje ASSIGNING FIELD-SYMBOL(<fs_viaje_log_u>).

        ASSIGN lt_viaje_log[ viajeid = <fs_viaje_log_u>-ViajeId ] TO FIELD-SYMBOL(<fs_viaje_db>).
        IF <fs_viaje_db> IS ASSIGNED.
          GET TIME STAMP FIELD <fs_viaje_db>-creado_el.
          <fs_viaje_db>-operacion_modificacion = 'UPDATE'.
          IF <fs_viaje_log_u>-%control-ClienteId = lv_mk_on.
            <fs_viaje_db>-valor_modificado = <fs_viaje_log_u>-ClienteId.
            <fs_viaje_db>-campo_modificado = 'ClienteId'.
            <fs_viaje_db>-modificado_por = lv_user_mod.
            TRY.
                <fs_viaje_db>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
              CATCH cx_uuid_error.
            ENDTRY.
            APPEND <fs_viaje_db> TO lt_viaje_log_u.
          ENDIF.
        ENDIF.

        UPDATE ztb_viajes_ags78 SET modificado_el = @<fs_viaje_db>-creado_el
                             WHERE viaje_id       = @<fs_viaje_log_u>-ViajeId.

      ENDLOOP.

    ENDIF.

    IF delete-viaje IS NOT INITIAL.
      lt_viaje_log = CORRESPONDING #( delete-viaje ).

      LOOP AT lt_viaje_log ASSIGNING FIELD-SYMBOL(<fs_viaje_log_d>).
        GET TIME STAMP FIELD <fs_viaje_log_d>-creado_el.
        <fs_viaje_log_d>-operacion_modificacion = 'DELETE'.
        <fs_viaje_log_d>-modificado_por = lv_user_mod.
        TRY.
            <fs_viaje_log_d>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
          CATCH cx_uuid_error.
        ENDTRY.
        APPEND <fs_viaje_log_d> TO lt_viaje_log_u.
      ENDLOOP.
    ENDIF.

    INSERT ztb_log_ags78 FROM TABLE @lt_viaje_log_u.


  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
