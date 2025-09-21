CLASS zcl_viaje_commit_ent_ags78 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_viaje_commit_ent_ags78 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lv_travel_id) = '00000011'.
    DATA(lv_description) = 'Changed Travel Agency'.
    DATA(lv_new_agency_id) = '070017'. " Valid agency ID

    MODIFY ENTITY z_i_viaje_ags78
    UPDATE FIELDS ( AgenciaId Descripcion )
    WITH VALUE #( ( ViajeId = lv_travel_id
    AgenciaId = lv_new_agency_id
    Descripcion = lv_description ) )
    FAILED DATA(ls_failed)
    REPORTED DATA(ls_reported).

    CLEAR: ls_reported, ls_failed.

    READ ENTITY z_i_viaje_ags78
    FIELDS ( AgenciaId Descripcion )
    WITH VALUE #( ( ViajeId = lv_travel_id ) )
    RESULT DATA(lt_received_travel_data)
    FAILED ls_failed.

    out->write( lt_received_travel_data ).

    COMMIT ENTITIES.

    IF sy-subrc = 0.
      out->write( 'Successful COMMIT!' ).
    ELSE.
      out->write( 'COMMIT failed!' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.

