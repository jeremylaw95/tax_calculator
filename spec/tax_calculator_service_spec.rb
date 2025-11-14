require 'spec_helper'
require './app/services/tax_calculator_service'

RSpec.describe TaxCalculatorService, type: :service do
  describe '#call' do
    {
      10_000 => 1_050.00,
      35_000 => 5_033.00,
      100_000 => 22_877.50,
      220_000 => 64_877.50
    }.each do |income, expected|
      it "returns correct tax for income #{income}" do
        expect(described_class.new.call(income)).to eq(BigDecimal(expected.to_s))
      end
    end

    it 'returns 0 for zero income' do
      expect(described_class.new.call(0)).to eq(BigDecimal('0'))
    end

    it 'returns 0 for negative income' do
      expect(described_class.new.call(-10_000)).to eq(BigDecimal('0'))
    end

    it 'handles decimal inputs' do
      result = described_class.new.call(10_000.50)
      expect(result).to be_within(0.01).of(BigDecimal('1050.05'))
    end
  end
end
