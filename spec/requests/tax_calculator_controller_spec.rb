require 'rails_helper'

RSpec.describe TaxCalculatorController, type: :request do
  describe 'GET /tax_calculator' do
    it 'renders the index page' do
      get tax_calculator_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /calculate' do
    context 'with valid input' do
      it 'calculates tax correctly', :aggregate_failures do
        post calculate_path, params: { income: '10000' }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('1,050.00')
      end

      it 'handles decimal values' do
        post calculate_path, params: { income: '10000.50' }
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid input' do
      it 'returns error for non-numeric input', :aggregate_failures do
        post calculate_path, params: { income: 'abc' }
        expect(response).to have_http_status(:unprocessable_content)
        json = response.parsed_body
        expect(json['error']).to eq('Please enter a valid number')
      end

      it 'returns error for negative income', :aggregate_failures do
        post calculate_path, params: { income: '-1000' }
        expect(response).to have_http_status(:unprocessable_content)
        json = response.parsed_body
        expect(json['error']).to eq('Income cannot be negative')
      end

      it 'returns error for missing parameter' do
        post calculate_path, params: {}
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
