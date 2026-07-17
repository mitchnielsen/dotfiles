---
name: tax-return-sim
description: Simulate Mitchell & Briana's annual federal and MN state tax return using documents in the current working directory. Use when asked to estimate, simulate, or calculate taxes owed or refunded.
---

# Tax Return Simulation

Simulate the federal and Minnesota state tax return for Mitchell Nielsen and Briana Paiewonsky — MFJ, MN full-year residents — using the tax documents in the current working directory and its subdirectories.

## Step 1: Explore All Documents

Use the Explore agent to read every document in the directory tree and extract:
- All W-2s: Box 1 (wages), Box 2 (federal withheld), Box 12 codes, Box 14 (MN withheld)
- All 1099-Rs: Box 1 (gross), **Box 2a (taxable amount — do not use Box 16)**, Box 4 (federal withheld — verify this is not blank before including), Box 14 (state withheld — verify not blank), Box 7 (distribution code), Box 5 (employee contributions/Roth basis)
- All 1099-INTs: Box 1 (interest), Box 4 (federal withheld)
- All 5498s: IRA contributions and fair market values
- Certificates of Rent Paid (CRP): total rent paid, address
- Any charitable contribution receipts
- 1095-C forms (health insurance — for context, not income)

## Step 2: Identify Key Income Items

### Backdoor Roth IRA Conversions
If Fidelity 1099-Rs appear with distribution code 2 (one for Mitchell, one for Briana):
- These are likely backdoor Roth conversions of non-deductible traditional IRA contributions
- The 1099-R Box 2a shows them as fully taxable — but **Form 8606 may reduce the taxable amount to $0** if the contributions were non-deductible and there were no other pre-tax IRA balances
- Present **two scenarios**: (A) 1099-R face value fully taxable, (B) Form 8606 applied, backdoor Roth non-taxable
- The Scenario B reduction = 24% federal + ~7.85% MN on the combined contribution amounts

### Inherited IRA Distributions (code 4)
- Taxable as ordinary income; no early withdrawal penalty
- **Cannot be converted to Roth** — it is simply a required distribution, even if the proceeds are later deposited into a Roth account as a separate contribution

### Designated Roth Plan Rollovers (code 1B)
- Check Box 5 (designated Roth contributions/basis) — this portion is NOT taxable
- Only Box 2a (earnings) is taxable
- **Always verify Box 4 (federal withheld) and Box 14 (state withheld) are not blank before including withholding** — Box 16 (state distribution) is often confused for withholding but is not
- Code 1B may trigger a 10% early withdrawal penalty on the taxable portion; this can often be waived via Form 5329 if rolled directly to a Roth IRA

### TIAA / Out-of-State Plan Distributions
- Check if state withholding went to a state other than MN (e.g., KS)
- As MN residents, retirement income is sourced to MN regardless of where the employer was located
- If KS (or other state) withholding appears, a non-resident return may be needed to recover it — but verify withholding is in Box 14, not Box 16

## Step 3: Federal Calculation

### AGI
- Combined W-2 Box 1 wages (401k deferrals already excluded)
- Taxable IRA/retirement distributions (per 1099-R Box 2a)
- Interest income (1099-INT)
- No above-the-line deductions typically apply at this income level (income too high for deductible IRA, no student loan interest, no HSA visible)

### Standard vs. Itemized
Compare:
- **Standard (MFJ 2025): $30,000**
- Itemized: SALT capped at $10,000 + charitable contributions (only deductible if itemizing; the pandemic-era universal charitable deduction expired after 2021)
- Standard deduction typically wins given renter status (no mortgage interest)

### Tax Brackets (2025 MFJ)
- 10%: $0 – $23,850
- 12%: $23,851 – $96,950
- 22%: $96,951 – $206,700
- 24%: $206,701 – $394,600
- 32%: $394,601 – $501,050
- 35%: $501,051 – $751,600
- 37%: over $751,600

### Additional Federal Taxes
- **NIIT (3.8%)**: on lesser of net investment income or MAGI over $250,000 (MFJ). Interest/dividends count; IRA distributions generally do not.
- **Additional Medicare Tax (0.9%)**: on Medicare wages (W-2 Box 5 combined) over $250,000 (MFJ). Use Box 5, not Box 1 — Medicare wages include 401k deferrals.
  - Credit for additional Medicare already withheld = (total Box 6 withheld) minus (combined Box 5 × 1.45%)
- **Early withdrawal penalty (10%)**: only if distribution code is 1 or 1B and no exception applies. Code 2 (Roth conversion) and code 4 (death) do not trigger the penalty.

### Federal Withholding
Sum of: all W-2 Box 2 + all 1099-R Box 4 (verify not blank) + additional Medicare withheld (Box 6 excess over 1.45%)

## Step 4: Minnesota Calculation

### MN AGI
Start from federal AGI. Key MN adjustments:
- Retirement income subtraction: fully phased out at this income level — assume $0
- No other significant MN-specific additions/subtractions expected

### MN Standard Deduction
**Look up the current year MN MFJ standard deduction from MN DOR** — do not estimate. Search: `site:revenue.state.mn.us minnesota income tax brackets standard deduction [TAX YEAR]`

### MN Tax Brackets
**Look up current year MN MFJ brackets from MN DOR** before calculating. The 2025 brackets were:
- 5.35%: $0 – $47,620
- 6.80%: $47,621 – $189,180
- 7.85%: $189,181 – $330,410
- 9.85%: over $330,410

These are indexed annually — always verify the current year rates.

### MN Credits
- **Marriage Credit (Schedule M1MA)**: applies when both spouses have qualifying income and the lesser earner's income exceeds the minimum threshold. Look up the current year formula — it phases out at higher incomes. Include if applicable.
- **Renter's Property Tax Refund (M1PR)**: separate filing; typically $0 at this income level (phases out well below their AGI)
- **Credit for taxes paid to other states**: only applies if an actual tax liability exists in the other state — not just withholding

### MN Withholding
Sum W-2 Box 14 (MN only) + 1099-R Box 14 (MN only). Exclude any out-of-state withholding.

## Step 5: Present Results

Show clearly:
1. Income table by source (Mitchell / Briana / Combined)
2. Federal calculation with bracket detail
3. MN calculation with bracket detail
4. Summary table: Scenario A (1099-R face value) vs Scenario B (Form 8606 backdoor Roth non-taxable)
5. Flag any items requiring separate action:
   - Form 8606 (non-deductible IRA contributions)
   - Form 5329 (penalty exceptions)
   - Out-of-state returns (if withholding to another state)
   - Underpayment penalty exposure (if balance due > $1,000)

## Key Lessons from Prior Years

- **Always verify 1099-R Box 4 and Box 14 are not zero before including withholding** — Box 16 (state distribution) is commonly misread as withholding
- The MN second bracket is **6.80%**, not 7.05%
- The MN standard deduction has been higher than naive inflation estimates — always look it up
- TurboTax's MN result may differ from the simulation by ~$100-200 due to the marriage credit and exact bracket rounding — this is expected
- If TurboTax shows more tax than the simulation under Scenario B, it likely means Form 8606 has not been entered yet in TurboTax
