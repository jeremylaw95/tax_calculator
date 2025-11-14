class TaxCalculatorController < ActionController::Base
  def index
  end

  def calculate
    income = params[:income].to_f

    result = TaxCalculatorService.new.call(income)
    
    @tax_result = result
    
    render partial: "result", locals: { tax: @tax_result }
  end
end
