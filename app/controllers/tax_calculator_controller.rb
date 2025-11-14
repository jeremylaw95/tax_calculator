class TaxCalculatorController < ApplicationController
  def index; end

  def calculate
    income = BigDecimal(params[:income])

    result = TaxCalculatorService.new.call(income)

    @tax_result = result

    render partial: 'result', locals: { tax: @tax_result }
  end
end
