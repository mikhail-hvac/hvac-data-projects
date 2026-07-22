import numpy as np
import pandas as pd
print("OK: numpy", np.__version__)
print("OK: pandas", pd.__version__)
import numpy as np
import pandas as pd

# Параметры профиля (под ASHRAE 90.1 TSPR)
duration_hours = 24
dt_seconds = 300  # 5 минут — стандартный шаг для TSPR
time_s = np.arange(0, duration_hours * 3600, dt_seconds)

# Пример ИТ‑нагрузки: синусоида + база (имитация реальной динамики ЦОД)
base_load_kw = 150.0
peak_load_kw = 200.0
it_load_kw = base_load_kw + (peak_load_kw - base_load_kw) * 0.5 * (1 + np.sin(2 * np.pi * time_s / (24 * 3600) - np.pi/2))

# Температура окружающей среды (упрощённо)
ambient_temp_c = 22.0 + 8.0 * np.sin(2 * np.pi * time_s / (24 * 3600))

df = pd.DataFrame({
    "time_s": time_s,
    "it_load_kw": it_load_kw,
    "ambient_temp_c": ambient_temp_c
})

# Сохраняем CSV (для Modelica TimeTable)
csv_path = "../data/it_load_profile_tspr.csv"
df.to_csv(csv_path, index=False)
print(f"CSV профиль сохранён: {csv_path}")
print(df.head())
