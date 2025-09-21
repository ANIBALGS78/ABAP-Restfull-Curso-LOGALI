@AbapCatalog.sqlViewName: 'ZV_VIAJE_AGS78'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Viajes'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view Z_I_VIAJE_AGS78
  as select from ztb_viajes_ags78 as Viaje
  composition [0..*] of Z_I_RESERVA_AGS78 as _Reserva
  association [0..1] to /DMO/I_Agency     as _Agencia on $projection.AgenciaId = _Agencia.AgencyID
  association [0..1] to /DMO/I_Customer   as _Cliente on $projection.ClienteId = _Cliente.CustomerID
  association [0..1] to I_Currency        as _Moneda  on $projection.Moneda    = _Moneda.Currency
{
  key viaje_id        as ViajeId,
      agencia_id      as AgenciaId,
      cliente_id      as ClienteId,
      fecha_desde     as FechaDesde,
      fecha_hasta     as FechaHasta,
      @Semantics.amount.currencyCode: 'Moneda'
      tarifa_reserva  as TarifaReserva,
      @Semantics.amount.currencyCode: 'Moneda'
      precio_total    as PrecioTotal,
      @Semantics.currencyCode: true
      moneda          as Moneda,
      descripcion     as Descripcion,
      estatus_general as EstatusGeneral,
      creado_por      as CreadoPor,
      creado_el       as CreadoEl,
      modificado_por  as ModificadoPor,
      modificado_el   as ModificadoEl,
      _Reserva,
      _Agencia,
      _Cliente,
      _Moneda
}
