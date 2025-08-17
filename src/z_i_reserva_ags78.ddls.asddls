@AbapCatalog.sqlViewName: 'ZV_RESERVA_AGS78'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Reservas'
@Metadata.ignorePropagatedAnnotations: true
define view Z_I_RESERVA_AGS78
  as select from ztb_reserva_ags as Reserva
  composition [0..*] of Z_I_RESERVASUPL_AGS78  as _SuplementoReserva
  association        to parent Z_I_VIAJE_AGS78 as _Viaje       on $projection.ViajeId      = _Viaje.ViajeId
  association [1..1] to /DMO/I_Customer        as _Cliente     on $projection.ClienteId    = _Cliente.CustomerID
  association [1..1] to /DMO/I_Carrier         as _transporte  on $projection.TransporteId = _transporte.AirlineID
  association [1..*] to /DMO/I_Connection      as _Conexion    on $projection.ConexionId   = _Conexion.ConnectionID
{
  key viaje_id        as ViajeId,
  key reserva_id      as ReservaId,
      fecha_reserva   as FechaReserva,
      cliente_id      as ClienteId,
      transporte_id   as TransporteId,
      conexion_id     as ConexionId,
      fecha_vuelo     as FechaVuelo,
      @Semantics.amount.currencyCode:
      'Moneda'
      precio_vuelo    as PrecioVuelo,
      @Semantics.currencyCode: true
      moneda          as Moneda,
      estatus_reserva as EstatusReserva,
      modificado_el   as ModificadoEl,
      _SuplementoReserva,
      _Viaje,
      _Cliente,
      _transporte,
      _Conexion
}
