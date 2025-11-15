require 'rails_helper'

RSpec.describe 'Tax calculator', type: :system do
  def fill_income_and_submit(amount)
    fill_in 'Yearly Income', with: amount
    click_button 'Calculate'
  end

  def expect_tax_result(tax:, income:)
    expect(page).to have_content('Tax to be paid:')
    expect(page).to have_content(tax)
    expect(page).to have_field('Yearly Income', with: income)
    expect(page).to have_select('Tax year:', selected: '2025/26')
  end

  it 'calculates tax and shows result', :aggregate_failures do
    visit root_path
    select '2025/26', from: 'Tax year:'
    fill_income_and_submit '10000'
    expect_tax_result(tax: '$1,050.00', income: '10000')
  end

  it 'shows a result for a valid decimal input', :aggregate_failures do
    visit root_path
    fill_income_and_submit '25000.40'
    expect_tax_result(tax: '$3,283.07', income: '25000.40')
  end

  it 'shows zero tax for zero income', :aggregate_failures do
    visit root_path
    fill_income_and_submit '0'
    expect_tax_result(tax: '$0.00', income: '0')
  end
end
