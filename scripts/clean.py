import pandas as pd
import re

# month -> (file path, item sheet name, zone sheet name)
FILES = {
    '2024-11-01': ('/mnt/user-data/uploads/selected_food_Nov_2024.xlsx', 'Selected Food Nov 2024', 'ZONE all item'),
    '2024-12-01': ('/mnt/user-data/uploads/selected_food_Dec_2024.xlsx', 'Selected Food Dec 2024', 'ZONE all item'),
    '2025-01-01': ('/mnt/user-data/uploads/Selected_food_table_Jan25.xlsx', 'Selected Food Jan 2025', 'Zone All item'),
    '2025-02-01': ('/mnt/user-data/uploads/selected_food_table_Feb_25.xlsx', 'Selected Food Feb. 2025', 'Zone All item'),
    '2025-03-01': ('/mnt/user-data/uploads/selected_food_table_Mar_25.xlsx', 'Selected Food Dec 2024', 'Zone All item'),
    '2025-04-01': ('/mnt/user-data/uploads/selected_food_table_Apr25.xlsx', 'Selected Food Dec 2024', 'Zone All item'),
}

def clean_item_name(name):
    # strip whitespace and trailing commas so "Agric hen eggs," == "Agric hen eggs"
    return str(name).strip().rstrip(',').strip()

def parse_state_price(text):
    # "Enugu (325)" -> ("Enugu", 325.0)
    if pd.isna(text):
        return (None, None)
    match = re.match(r'^(.*)\((.*)\)\s*$', str(text).strip())
    if not match:
        return (str(text).strip(), None)
    state = match.group(1).strip()
    try:
        price = float(match.group(2).strip())
    except ValueError:
        price = None
    return (state, price)

item_rows = []
zone_rows = []

for month, (path, item_sheet, zone_sheet) in FILES.items():
    # --- item sheet ---
    df = pd.read_excel(path, sheet_name=item_sheet, header=0)
    for _, row in df.iterrows():
        item_name = clean_item_name(row.iloc[0])
        avg_price = row.iloc[3]  # position 3 = current month's average, regardless of column name
        if pd.isna(avg_price):
            continue  # item wasn't tracked yet this month, skip rather than fake a zero
        high_state, high_price = parse_state_price(row.iloc[6])
        low_state, low_price = parse_state_price(row.iloc[7])
        item_rows.append({
            'item_name': item_name,
            'month': month,
            'avg_price': round(float(avg_price), 2),
            'highest_state': high_state,
            'highest_price': high_price,
            'lowest_state': low_state,
            'lowest_price': low_price,
        })

    # --- zone sheet ---
    zdf = pd.read_excel(path, sheet_name=zone_sheet, header=0)
    zone_cols = zdf.columns[1:]  # everything after item name column
    for _, row in zdf.iterrows():
        item_name = clean_item_name(row.iloc[0])
        for zone_col in zone_cols:
            price = row[zone_col]
            if pd.isna(price):
                continue
            zone_rows.append({
                'item_name': item_name,
                'month': month,
                'zone': zone_col.strip(),
                'avg_price': round(float(price), 2),
            })

item_df = pd.DataFrame(item_rows)
zone_df = pd.DataFrame(zone_rows)

# --- apply the manually-verified name crosswalk so renamed items become one series ---
crosswalk = pd.read_csv('name_crosswalk_updated.csv')
rename_map = {}
for _, r in crosswalk.iterrows():
    rename_map[r['old_name']] = r['canonical_name']
    rename_map[r['new_name']] = r['canonical_name']

item_df['item_name'] = item_df['item_name'].replace(rename_map)
zone_df['item_name'] = zone_df['item_name'].replace(rename_map)

item_df.to_csv('/home/claude/food_prices/item_prices.csv', index=False)
zone_df.to_csv('/home/claude/food_prices/zone_prices.csv', index=False)

print(f"item_prices.csv: {len(item_df)} rows")
print(f"zone_prices.csv: {len(zone_df)} rows")
print(f"\nUnique items: {item_df['item_name'].nunique()}")
print(f"Months covered: {sorted(item_df['month'].unique())}")
