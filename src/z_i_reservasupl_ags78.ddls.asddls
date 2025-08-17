@AbapCatalog.sqlViewName: 'ZV_SUP_RESE_AGS'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Suplemento de Reserva'
@Metadata.ignorePropagatedAnnotations: true
define view Z_I_RESERVASUPL_AGS78
  as select from ztb_sup_rese_ags
  association        to parent Z_I_RESERVA_AGS78 as _Reserva       on  $projection.ViajeId      = _Reserva.ViajeId
                                                                  and  $projection.ReservaId    = _Reserva.ReservaId
  association [1..1] to Z_I_VIAJE_AGS78        as _Viaje           on  $projection.ViajeId      = _Viaje.ViajeId
  association [1..1] to /DMO/I_Supplement      as _Producto        on  $projection.SuplementoId = _Producto.SupplementID
  association [1..*] to /DMO/I_SupplementText  as _TextoSuplemento on  $projection.SuplementoId = _TextoSuplemento.SupplementID
{
  key viaje_id       as ViajeId,
  key reserva_id     as ReservaId,
  key reserva_sup_id as ReservaSupId,
      suplemento_id  as SuplementoId,
      @Semantics.amount.currencyCode: 'Moneda'
      precio         as Precio,
      @Semantics.currencyCode: true
      moneda         as Moneda,
      modificado_el  as ModificadoEl,
      _Reserva,
      _Viaje,
      _Producto,
      _TextoSuplemento
}
