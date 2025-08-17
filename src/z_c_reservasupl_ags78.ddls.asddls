@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo - Suplemento de Reserva'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Z_C_RESERVASUPL_AGS78
  as projection on Z_I_RESERVASUPL_AGS78
{
  key ViajeId,
  key ReservaId,
  key ReservaSupId,
      @ObjectModel.text.element: ['TextoSuplemento']
      SuplementoId,
      _TextoSuplemento.Description as TextoSuplemento : localized,
      @Semantics.amount.currencyCode: 'Moneda'
      Precio,
      @Semantics.currencyCode: true
      Moneda,
      ModificadoEl,
      /* Associations */
      _Viaje   : redirected to Z_C_VIAJE_AGS78,
      _Reserva : redirected to parent Z_C_RESERVA_AGS78,
      _Producto,
      _TextoSuplemento

}
