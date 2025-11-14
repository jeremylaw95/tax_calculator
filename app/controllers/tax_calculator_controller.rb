class TaxCalculatorController < ApplicationController
  def index; end

  def calculate
    income = BigDecimal(params[:income])

    if income.negative?
      render json: { error: 'Income cannot be negative' }, status: :unprocessable_content
      return
    end

    result = TaxCalculatorService.new.call(income)
    render partial: 'result', locals: { tax: result }
  rescue ArgumentError, TypeError
    render json: { error: 'Please enter a valid number' }, status: :unprocessable_content
  end
end
