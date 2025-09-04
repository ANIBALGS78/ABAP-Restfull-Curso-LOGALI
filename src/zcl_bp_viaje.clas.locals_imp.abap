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
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD aceptar_viaje.
  ENDMETHOD.

  METHOD crear_viaje_con_plantilla.
  ENDMETHOD.

  METHOD rechazar_viaje.
  ENDMETHOD.

  METHOD calculoTotalPrecioVuelo.
  ENDMETHOD.

  METHOD validarcliente.
  ENDMETHOD.

  METHOD validarestatus.
  ENDMETHOD.

  METHOD validarfecha.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_I_VIAJE_AGS78 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z_I_VIAJE_AGS78 IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
