import matplotlib.pyplot as plt
import matplotlib.font_manager as fm

# --- register brand fonts ---
bebas = fm.FontProperties(fname='/home/claude/fonts/BebasNeue.ttf')
outfit = fm.FontProperties(fname='/home/claude/fonts/Outfit-Regular.ttf')

# --- brand colors ---
ORANGE = '#E8630A'
BLACK = '#0D0D0D'
OFFWHITE = '#f5f4f0'

# --- data: top 8 each side, from your query results ---
cheapest = [
    ('Yobe', 29), ('Adamawa', 21), ('Oyo', 18), ('Taraba', 17),
    ('Benue', 16), ('Borno', 15), ('Niger', 13), ('Kogi', 13),
]
priciest = [
    ('Enugu', 25), ('Imo', 22), ('Ebonyi', 19), ('Plateau', 19),
    ('Gombe', 15), ('Ogun', 14), ('Akwa Ibom', 11), ('Kwara', 11),
]

fig, axes = plt.subplots(1, 2, figsize=(12, 7), facecolor=BLACK)

for ax, data, title, highlight in [
    (axes[0], cheapest, 'MOST OFTEN CHEAPEST', None),
    (axes[1], priciest, 'MOST OFTEN PRICIEST', 'Gombe'),
]:
    names = [d[0] for d in data][::-1]
    values = [d[1] for d in data][::-1]
    colors = [ORANGE if n == highlight else OFFWHITE for n in names]

    ax.set_facecolor(BLACK)
    bars = ax.barh(names, values, color=colors, height=0.6)

    ax.set_title(title, fontproperties=bebas, fontsize=26, color=ORANGE, pad=15)
    ax.tick_params(colors=OFFWHITE, labelsize=13)
    for label in ax.get_yticklabels():
        label.set_fontproperties(outfit)
    for label in ax.get_xticklabels():
        label.set_fontproperties(outfit)

    for spine in ax.spines.values():
        spine.set_visible(False)
    ax.set_xticks([])

    # value labels at bar ends
    for bar, val in zip(bars, values):
        ax.text(val + 0.4, bar.get_y() + bar.get_height()/2, str(val),
                 va='center', color=OFFWHITE, fontproperties=outfit, fontsize=12)

fig.suptitle('WHICH STATES HIT NIGERIA\'S FOOD PRICE EXTREMES?',
             fontproperties=bebas, fontsize=22, color=OFFWHITE, y=1.02)
fig.text(0.5, -0.02, 'NBS Selected Food Prices Watch, Nov 2024 – Apr 2025  |  Actually with Marvellous',
          ha='center', fontproperties=outfit, fontsize=11, color='#888888')

plt.tight_layout()
plt.savefig('/home/claude/food_prices/states_extremes_chart.png', dpi=200,
            facecolor=BLACK, bbox_inches='tight')
print("saved")
