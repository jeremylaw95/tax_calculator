# NZ Tax Calculator

A Ruby on Rails application that calculates income tax for New Zealand's 2025 tax rates.

## Prerequisites
- Ruby 3.x
- Rails 8.x

## Setup

```bash
bundle install
```

## Running the Application

```bash
rails s
```

Visit `http://localhost:3000/tax_calculator`

## Running Tests

```bash
rspec 
```

## Tax Rates (2025)

- Up to $15,600: 10.5%
- $15,601 - $53,500: 17.5%
- $53,501 - $78,100: 30%
- $78,101 - $180,000: 33%
- $180,001 and over: 39%

## Architecture

- **Service**: `TaxCalculatorService` handles progressive tax calculations using BigDecimal for precision
- **Controller**: `TaxCalculatorController` manages and validates user input and coordinates with the service
- **Views**: Simple form interface to display result

## Key Design Decisions

- **BigDecimal**: Used for all financial calculations to avoid floating-point precision errors
- **Progressive Tax Calculation**: Iterates through tax bands, calculating tax owed for each bracket
- **Constants**: Tax bands defined as frozen constants for immutability and performance
