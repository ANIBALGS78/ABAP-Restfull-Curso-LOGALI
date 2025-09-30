@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo - Viajes'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_C_VIAJE_AGS78
  as projection on Z_I_VIAJE_AGS78
{
          @EndUserText.label: 'ID.Vuelo'
  key     ViajeId,
          @ObjectModel.text.element: [ 'NombreAgencia' ]
          @EndUserText.label: 'Agencia'
          AgenciaId,
          _Agencia.Name      as NombreAgencia,
          @ObjectModel.text.element: ['NombreCliente']
          @EndUserText.label: 'Cliente'
          ClienteId,
          _Cliente.FirstName as NombreCliente,
          @EndUserText.label: 'Fe.Desde'
          FechaDesde,
          @EndUserText.label: 'Fe.Hasta'
          FechaHasta,
          @Semantics.amount.currencyCode: 'Moneda'
          @EndUserText.label: 'Tarifa Reserva'
          TarifaReserva,
          @Semantics.amount.currencyCode: 'Moneda'   
          @EndUserText.label: 'Precio Total'
          PrecioTotal,
          @Semantics.currencyCode: true
          @EndUserText.label: 'Moneda'
          Moneda,
          @EndUserText.label: 'Descripcion'
          Descripcion,
          @EndUserText.label: 'Estatus General'
          EstatusGeneral,
          @EndUserText.label: 'Creado Por'
          CreadoPor,
          @EndUserText.label: 'Creado El'
          CreadoEl,
          @EndUserText.label: 'Modificado Por'
          ModificadoPor,
          ModificadoEl,
          @Semantics.amount.currencyCode: 'Moneda'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_VIRTUAL_ELM_VIAJES_AGS78'
          @EndUserText.label: 'Descuento (10%)'
  virtual descuento : /dmo/total_price,
          /* Associations */
          _Agencia,
          _Cliente,
          _Moneda,
          _Reserva : redirected to composition child Z_C_RESERVA_AGS78
}
