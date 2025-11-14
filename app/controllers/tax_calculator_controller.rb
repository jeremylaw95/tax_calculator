class TaxCalculatorController < ApplicationController
  def index; end

  def calculate
    income = BigDecimal(params[:income])

    if income.negative?
      render json: { error: 'Income cannot be negative' }, status: :unprocessable_content
      return
    end

    @income_input = params[:income]
    @tax = TaxCalculatorService.new.call(income)
    render :index
  rescue ArgumentError, TypeError
    render json: { error: 'Please enter a valid number' }, status: :unprocessable_content
  end
end
