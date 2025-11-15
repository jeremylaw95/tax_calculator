Rails.application.routes.draw do
  root "tax_calculator#index"
  get "tax_calculator", to: "tax_calculator#index"
end
