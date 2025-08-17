@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo - Reserva'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Z_C_RESERVA_AGS78
  as projection on Z_I_RESERVA_AGS78
{
  key ViajeId,
  key ReservaId,
      FechaReserva,
      ClienteId,
      @ObjectModel.text.element: ['NombreTransporte']
      TransporteId,
      _transporte.Name as NombreTransporte,
      ConexionId,
      FechaVuelo,
      @Semantics.amount.currencyCode: 'Moneda'
      PrecioVuelo,
      @Semantics.currencyCode: true
      Moneda,
      EstatusReserva,
      ModificadoEl,
      /* Associations */
      _Viaje             : redirected to parent Z_C_VIAJE_AGS78,
      _SuplementoReserva : redirected to composition child Z_C_RESERVASUPL_AGS78,
      _Cliente,
      _Conexion,
      _transporte


}
