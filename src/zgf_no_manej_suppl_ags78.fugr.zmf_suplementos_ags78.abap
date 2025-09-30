FUNCTION zmf_suplementos_ags78.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(VALUES) TYPE  ZTT_SUPPL_AGS78
*"     REFERENCE(OPERATION) TYPE  ZDE_TIPO_OPERACION
*"  EXPORTING
*"     REFERENCE(EV_UPDATED) TYPE  ZDE_EXITO
*"----------------------------------------------------------------------
  CASE operation.
    WHEN 'C'. INSERT ztb_sup_rese_ags FROM TABLE @values.
    WHEN 'U'. UPDATE ztb_sup_rese_ags FROM TABLE @values.
    WHEN 'D'. DELETE ztb_sup_rese_ags FROM TABLE @values.
  ENDCASE.
  IF sy-subrc EQ 0.
    ev_updated = abap_true.
  ENDIF.

ENDFUNCTION.
