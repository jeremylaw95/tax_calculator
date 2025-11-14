require 'bigdecimal'

class TaxCalculatorService
  NZ_2025_TAX_BANDS = [
    { lower_threshold: 0, higher_threshold: 15_600, rate: BigDecimal('0.105') },
    { lower_threshold: 15_600, higher_threshold: 53_500, rate: BigDecimal('0.175') },
    { lower_threshold: 53_500, higher_threshold: 78_100, rate: BigDecimal('0.30') },
    { lower_threshold: 78_100, higher_threshold: 180_000, rate: BigDecimal('0.33') },
    { lower_threshold: 180_000, higher_threshold: Float::INFINITY, rate: BigDecimal('0.39') }
  ].freeze

  def initialize(tax_bands: NZ_2025_TAX_BANDS)
    @tax_bands = tax_bands
  end

  def call(income)
    income_bd = BigDecimal(income.to_s)
    tax_to_be_paid = BigDecimal('0')

    # store remaining untaxed income so that we can update it as we tax each band
    remaining = income_bd

    # store the bands that the income falls within
    matching_bands = @tax_bands.select { |band| band[:lower_threshold] < income_bd }

    matching_bands.each do |band|
      bandwidth = BigDecimal((band[:higher_threshold] - band[:lower_threshold]).to_s)

      # If remaining untaxed income is less than bandwidth, tax remaining income and break from loop
      if remaining < bandwidth
        tax_to_be_paid += remaining * band[:rate]
        break
      end

      tax_to_be_paid += bandwidth * band[:rate]
      remaining -= bandwidth
    end

    tax_to_be_paid.round(2)
  end
end
