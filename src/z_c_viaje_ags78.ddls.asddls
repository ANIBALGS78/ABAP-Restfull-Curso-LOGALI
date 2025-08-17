@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo - Viajes'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_C_VIAJE_AGS78
  as projection on Z_I_VIAJE_AGS78
{
  key ViajeId,
      @ObjectModel.text.element: [ 'NombreAgencia' ]
      AgenciaId,
      _Agencia.Name      as NombreAgencia,
      @ObjectModel.text.element: ['NombreCliente']
      ClienteId,
      _Cliente.FirstName as NombreCliente,
      FechaDesde,
      FechaHasta,
      @Semantics.amount.currencyCode: 'Moneda'
      TarifaReserva,
      @Semantics.amount.currencyCode: 'Moneda'
      PrecioTotal,
      @Semantics.currencyCode: true
      Moneda,
      Descripcion,
      EstatusGeneral,
      CreadoPor,
      CreadoEl,
      ModificadoPor,
      ModificadoEl,
      /* Associations */
      _Agencia,
      _Cliente,
      _Moneda,
      _Reserva : redirected to composition child Z_C_RESERVA_AGS78 
}
