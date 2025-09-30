@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interfaz Fligth'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_FLIGHT_AGS78
  as select from /dmo/flight as Flight
{
  key Flight.carrier_id,
  key Flight.connection_id,
  key Flight.flight_date,

      @Semantics.amount.currencyCode: 'currency_code'
      Flight.price,

      @EndUserText.label: 'Price 2'
      cast(price as abap.dec(15,2)) + 100 as price2,

      Flight.currency_code,
      Flight.plane_type_id,
      Flight.seats_max,
      Flight.seats_occupied

}
