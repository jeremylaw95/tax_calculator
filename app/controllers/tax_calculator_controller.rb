# app/controllers/tax_calculator_controller.rb
class TaxCalculatorController < ApplicationController
  def index
    @income_input = params[:income]
    @selected_tax_year = params[:tax_year].presence || '2025'

    return if @income_input.blank?

    income = BigDecimal(@income_input)

    if income.negative?
      @error = 'Income cannot be negative'
      return
    end

    @tax = TaxCalculatorService.new(year: @selected_tax_year).call(income)
  rescue ArgumentError, TypeError
    @error = 'Please enter a valid number'
  end
end
