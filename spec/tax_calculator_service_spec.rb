require 'spec_helper'
require './app/services/tax_calculator_service'

RSpec.describe TaxCalculatorService, type: :service do
  # Create a shared service instance
  let(:service) { described_class.new }

  describe '#call' do
    {
      10_000 => 1_050.00,
      35_000 => 5_033.00,
      100_000 => 22_877.50,
      220_000 => 64_877.50
    }.each do |income, expected|
      it "returns correct tax for income #{income}" do
        expect(service.call(income)).to eq(BigDecimal(expected.to_s))
      end
    end

    it 'returns 0 for zero income' do
      expect(service.call(0)).to eq(BigDecimal('0'))
    end

    it 'returns 0 for negative income' do
      expect(service.call(-10_000)).to eq(BigDecimal('0'))
    end

    it 'handles decimal inputs' do
      result = service.call(10_000.50)
      expect(result).to be_within(0.01).of(BigDecimal('1050.05'))
    end

    describe 'boundary values' do
      it 'handles exact threshold values correctly', :aggregate_failures do
        expect(service.call(15_600)).to eq(BigDecimal('1638'))
        expect(service.call(53_500)).to eq(BigDecimal('8270.5'))
        expect(service.call(78_100)).to eq(BigDecimal('15650.5'))
        expect(service.call(180_000)).to eq(BigDecimal('49277.5'))
      end

      it 'handles values just above thresholds', :aggregate_failures do
        expect(service.call(15_601)).to eq(BigDecimal('1638.18'))
        expect(service.call(53_501)).to eq(BigDecimal('8270.8'))
      end

      it 'handles values just below thresholds', :aggregate_failures do
        expect(service.call(15_599)).to eq(BigDecimal('1637.90'))
        expect(service.call(53_499)).to eq(BigDecimal('8270.33'))
      end

      it 'handles very large incomes' do
        expect(service.call(1_000_000)).to eq(BigDecimal('369077.5'))
      end
    end
  end
end
