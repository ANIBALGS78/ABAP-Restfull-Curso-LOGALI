@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo - Viajes'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_FLIGHT_AGS78
  provider contract transactional_query
  as projection on ZI_FLIGHT_AGS78
{
  key carrier_id,
  key connection_id,
  key flight_date,

      @Semantics.amount.currencyCode: 'currency_code'
      price,

      price2,
      currency_code,
      plane_type_id,
      seats_max,
      seats_occupied

}
