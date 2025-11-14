Rails.application.routes.draw do
  get "tax_calculator", to: "tax_calculator#index"
  post 'calculate', to: 'tax_calculator#calculate', as: :calculate
end
