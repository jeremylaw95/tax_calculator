require 'rails_helper'

RSpec.describe TaxCalculatorController, type: :request do
  describe 'GET /' do
    it 'renders the index page' do
      get root_path
      expect(response).to have_http_status(:success)
    end

    context 'with valid input' do
      it 'calculates tax correctly', :aggregate_failures do
        get root_path, params: { income: '10000', tax_year: '2025' }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('1,050.00')
      end

      it 'handles decimal values' do
        get root_path, params: { income: '10000.50', tax_year: '2025' }
        expect(response).to have_http_status(:success)
      end

      it 'calculates tax using 2024 bands', :aggregate_failures do
        get root_path, params: { income: '35000', tax_year: '2024' }

        expect(response).to have_http_status(:success)
        expect(response.body).to include('5,070.12')
      end

      it 'shows zero tax for zero income', :aggregate_failures do
        get root_path, params: { income: '0', tax_year: '2025' }

        expect(response).to have_http_status(:success)
        expect(response.body).to include('0.00')
        expect(response.body).to include('Tax to be paid')
      end
    end

    context 'with invalid input' do
      it 'shows error for non-numeric input', :aggregate_failures do
        get root_path, params: { income: 'abc', tax_year: '2025' }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Please enter a valid number')
      end

      it 'shows error for negative income', :aggregate_failures do
        get root_path, params: { income: '-1000', tax_year: '2025' }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Income cannot be negative')
      end

      it 'does not calculate tax when income is missing', :aggregate_failures do
        get root_path, params: { tax_year: '2025' }
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include('Tax to be paid')
      end
    end
  end
end
