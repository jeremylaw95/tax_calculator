# Calculates NZ income tax using IRD marginal bands for 2024/25 and 2025/26 using BigDecimal.
# The tax year is selected via the `year` argument.
class TaxCalculatorService
  NZ_2025_TAX_BANDS = [
    { lower_threshold: 0, higher_threshold: 15_600, rate: BigDecimal('0.105') },
    { lower_threshold: 15_600, higher_threshold: 53_500, rate: BigDecimal('0.175') },
    { lower_threshold: 53_500, higher_threshold: 78_100, rate: BigDecimal('0.30') },
    { lower_threshold: 78_100, higher_threshold: 180_000, rate: BigDecimal('0.33') },
    { lower_threshold: 180_000, higher_threshold: Float::INFINITY, rate: BigDecimal('0.39') }
  ].freeze

  #  From 1 April 2024 to 31 March 2025
  NZ_2024_TAX_BANDS = [
    { lower_threshold: 0, higher_threshold: 14_000, rate: BigDecimal('0.105') },
    { lower_threshold: 14_000, higher_threshold: 15_600, rate: BigDecimal('0.1282') },
    { lower_threshold: 15_600, higher_threshold: 48_000, rate: BigDecimal('0.175') },
    { lower_threshold: 48_000, higher_threshold: 53_500, rate: BigDecimal('0.2164') },
    { lower_threshold: 53_500, higher_threshold: 70_000, rate: BigDecimal('0.30') },
    { lower_threshold: 70_000, higher_threshold: 78_100, rate: BigDecimal('0.3099') },
    { lower_threshold: 78_100, higher_threshold: 180_000, rate: BigDecimal('0.33') },
    { lower_threshold: 180_000, higher_threshold: Float::INFINITY, rate: BigDecimal('0.39') }
  ].freeze

  # Map of supported tax years to their marginal band definitions.
  TAX_BANDS = {
    '2024' => NZ_2024_TAX_BANDS,
    '2025' => NZ_2025_TAX_BANDS
  }.freeze

  def initialize(year: '2025')
    @tax_bands = TAX_BANDS[year.to_s] || TAX_BANDS['2025']
  end

  def call(income)
    income_bd = BigDecimal(income.to_s)
    tax_to_be_paid = BigDecimal('0')

    # store remaining untaxed income so that we can update it as we tax each band
    remaining = income_bd

    # store bands where income is above the lower threshold (bands are treated as marginal)
    matching_bands = @tax_bands.select { |band| band[:lower_threshold] < income_bd }

    matching_bands.each do |band|
      tax_for_band, remaining = calculate_tax_for_band(band, remaining)
      tax_to_be_paid += tax_for_band
      break if remaining.zero?
    end

    tax_to_be_paid.round(2)
  end

  private

  def calculate_tax_for_band(band, remaining_income)
    bandwidth = BigDecimal((band[:higher_threshold] - band[:lower_threshold]).to_s)

    # If remaining untaxed income is less than bandwidth, tax remaining income and break from loop
    if remaining_income < bandwidth
      [remaining_income * band[:rate], BigDecimal('0')]
    else
      [bandwidth * band[:rate], remaining_income - bandwidth]
    end
  end
end
