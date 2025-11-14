require "bigdecimal"

class TaxCalculatorService
  TAX_BANDS = [
    { lower_threshold: 0, higher_threshold: 15600, rate: BigDecimal("0.105") },
    { lower_threshold: 15600, higher_threshold: 53500, rate: BigDecimal("0.175") },
    { lower_threshold: 53500, higher_threshold: 78100, rate: BigDecimal("0.30") },
    { lower_threshold: 78100, higher_threshold: 180000, rate: BigDecimal("0.33") },
    { lower_threshold: 180000, higher_threshold: Float::INFINITY, rate: BigDecimal("0.39") }
  ].freeze

  def call(income)
    @tax_to_be_paid = 0
    # store the bands that the income falls within
    matching_bands = TAX_BANDS.select { |band| band[:lower_threshold] < income }
    # store remaining untaxed income so that we can update it as we tax each band
    remaining = income

    # Loop through each band until remaining tax is smaller than the highest bandwidth
    matching_bands.each { |band|
      bandwidth = band[:higher_threshold] - band[:lower_threshold]
      # If remaining untaxed income is less than bandwidth, tax remaining income and break from loop
      if remaining < bandwidth
        @tax_to_be_paid += remaining * band[:rate]
        break
      end
      @tax_to_be_paid += bandwidth * band[:rate]
      remaining -= bandwidth
    }

    @tax_to_be_paid.round(2)
  end
end
