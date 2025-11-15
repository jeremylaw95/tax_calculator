# spec/system/tax_calculator_spec.rb
require 'rails_helper'

RSpec.describe 'Tax calculator', type: :system do
  it 'renders the form with default values', :aggregate_failures do
    visit root_path

    expect(page).to have_content('Tax Calculator')
    expect(page).to have_field('Yearly Income')
    expect(page).to have_select('Tax year:', selected: '2025/26')
    expect(page).to have_button('Calculate')
  end

  it 'calculates tax and shows result', :aggregate_failures do
    visit root_path

    select '2025/26', from: 'Tax year:'
    fill_in 'Yearly Income', with: '10000'
    click_button 'Calculate'

    expect(page).to have_content('Tax to be paid:')
    expect(page).to have_content('$1,050.00')
    expect(page).to have_field('Yearly Income', with: '10000')
    expect(page).to have_select('Tax year:', selected: '2025/26')
  end

  it 'does not show a result for negative input' do
    visit root_path

    fill_in 'Yearly Income', with: '-1000'
    click_button 'Calculate'

    expect(page).not_to have_content('Tax to be paid:')
  end

  it 'shows a result for a valid decimal input' do
    visit root_path

    fill_in 'Yearly Income', with: '25000.40'
    click_button 'Calculate'

    expect(page).to have_content('Tax to be paid:')
    expect(page).to have_content('$3,283.07')
    expect(page).to have_field('Yearly Income', with: '25000.40')
    expect(page).to have_select('Tax year:', selected: '2025/26')
  end
end
