@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo - Aprovador de Viajes'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_C_AVIAJE_AGS78
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
      _Reserva : redirected to composition child Z_C_ARESERVA_AGS78,
      _Agencia,
      _Cliente,
      _Moneda
}
