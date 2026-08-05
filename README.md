# NBS Food Prices — SQL Analysis

Six months of Nigeria's official food price data (Nov 2024 – Apr 2025),
cleaned and queried in MySQL, built to fact-check a common claim: **is food
actually more expensive in Northern Nigeria?**

Full episode built from this analysis: *"Is Food Actually More Expensive Up
North?"* — Actually with Marvellous.

## The short answer

No — the opposite. States that hit the cheapest food prices most often are
overwhelmingly Northern (Yobe, Adamawa, Oyo, Taraba, Benue). States hitting
the highest prices most often are overwhelmingly Southern/Southeastern
(Enugu, Imo, Ebonyi, Plateau). Confirmed two independent ways — state-level
frequency counts and zone-level price averages both show the same pattern.

One real exception: **Gombe**, a Northern state, consistently shows up on the
*expensive* list. Flagged as an open anomaly rather than explained away.

## Data source

[NBS Selected Food Prices Watch](https://microdata.nigerianstat.gov.ng/index.php/catalog/162)
— monthly Excel releases, Nov 2024 through Apr 2025 (6 files).

## What's in this repo

```
nbs-food-prices-sql/
├── data/
│   ├── raw/                        # the 6 original NBS Excel files
│   └── processed/
│       ├── item_prices.csv         # cleaned, import-ready
│       └── zone_prices.csv         # cleaned, import-ready
├── sql/
│   ├── schema.sql                  # CREATE TABLE statements
│   └── queries.sql                 # every analysis query, in order
├── crosswalk/
│   └── name_crosswalk.csv          # manual old-name → new-name mapping
├── clean.py                        # raw Excel → clean CSVs
├── charts/
│   ├── make_charts.py              # generates both chart images
│   ├── food_price_extremes_chart.png
│   └── zone_price_chart.png
├── fonts/                          # Bebas Neue + Outfit (brand fonts, OFL licensed)
└── README.md
```

## The real data problem this project solved

NBS changed their item-naming convention between Dec 2024 and Jan 2025 with
no published crosswalk — e.g. `"Beans Brown"` became `"Beans brown,sold
loose"`. Left unfixed, this would silently break any 6-month trend line. A
manual crosswalk (`crosswalk/name_crosswalk.csv`) was built by hand,
cross-checking item names against price levels for confidence — ambiguous
cases (e.g. bread pack sizes changing from 500g to 450g) were deliberately
left unmerged rather than guessed, since merging them would hide a real
shrinkflation story instead of revealing a clean trend.

## Reproducing this

1. Download the 6 raw Excel files into `data/raw/` (links in `clean.py`)
2. `pip install pandas openpyxl`
3. `python3 clean.py` → produces the two processed CSVs
4. Run `sql/schema.sql` in MySQL Workbench to create the tables
5. Import both CSVs via Workbench's Table Data Import Wizard
6. Run `sql/queries.sql` to reproduce every finding
7. `pip install matplotlib` then `python3 charts/make_charts.py` to regenerate the charts

## Tools

MySQL (analysis), Python/pandas (data cleaning), matplotlib (charts).
