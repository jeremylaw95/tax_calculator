# Future Improvements

Given additional time, here are improvements I would implement; each item is intentionally scoped to a few hours of work:

## 1. Enhanced Tax Breakdown
- Show tax paid per bracket (e.g., "$1,638 at 10.5%, $6,632.50 at 17.5%...")
- Display effective tax rate (total tax / income)
- Calculate net income after tax

## 2. Input Flexibility
- Support different pay periods (convert weekly/fortnightly/monthly to annual)
- Add quick example buttons (e.g., "Try $50,000", "Try $100,000")
- Remember last calculation using browser session storage

## 3. Better User Feedback
- Show which tax brackets the income falls into
- Add a simple visual indicator such as a progress bar

## 4. Historical Comparison & Tax Band Management
- Extract tax bands to a YAML config file (e.g., `config/tax_bands.yml`)
- Extend current year selector dropdown
- Support secondary tax rates for users with more than one source of income
- Simple year selector dropdown
- Show "how much more/less tax compared to last year"

## 5. Additional Testing
- Add tests for custom tax bands or jurisdictions
- Add boundary/property tests around band edges and general rules (e.g. higher income never reduces tax, tax is never negative)
- Add year-comparison tests for the same income across different years

## 6. Documentation
- Document the tax calculation algorithm with examples
- Create a simple architecture diagram

## 7. Styling
- Move inline CSS to css file

---

**Impact:** Items 1-3 improve immediate user value, 4 adds practical functionality, 5-6 improve maintainability. All achievable in a few hours each.