import fastf1 as f1
import pandas as pd
import numpy as np

filepath = './data/'
num_samples = 300

def build_csv(year, driver, filename, ref_grid=None):
    session = f1.get_session(year, 'Silverstone', 'R')
    session.load()

    laps = session.laps.pick_driver(driver)
    weather = session.weather_data
    clean_laps = laps[(laps['PitInTime'].isnull()) & (laps['PitOutTime'].isnull())]
    if clean_laps.empty:
        print(f"No clean laps for {driver} in {year}")
        return None
    
    # Choose the wettest lap, doesn't apply to 2021 as there was no rain
    clean_laps['RainSamples'] = clean_laps.apply(lambda lap: rain_duration(lap, weather), axis=1)
    curr_lap = clean_laps.loc[clean_laps['RainSamples'].idxmax()]
    car = curr_lap.get_car_data().add_distance()
    pos = curr_lap.get_pos_data()
    tel = pd.merge_asof(car, pos, on='Time')

    if ref_grid is None:
        ref_grid = np.linspace(tel['Distance'].min(), tel['Distance'].max(), num_samples).round(1)

    data = pd.DataFrame({
         'Driver': driver,
        'Distance': ref_grid,
        'Time': np.linspace(tel['Time'].dt.total_seconds().min(), tel['Time'].dt.total_seconds().max(), num_samples).round(3),
        'X': np.interp(ref_grid, tel['Distance'], tel['X']).round(1),
        'Y': np.interp(ref_grid, tel['Distance'], tel['Y']).round(1),
        'Speed': np.interp(ref_grid, tel['Distance'], tel['Speed']).round(1),
        'Throttle': np.interp(ref_grid, tel['Distance'], tel['Throttle']).round(1),
        'Brake': (np.interp(ref_grid, tel['Distance'], tel['Brake']) > 0.5).astype(bool)
    })

    data.to_csv(filename, index=False)
    return ref_grid

def rain_duration(lap, weather):
    start = lap['LapStartTime']
    end = start + lap['LapTime']
    rain = weather[(weather['Time'] >= start) & (weather['Time'] <= end) & (weather['Rainfall'] == True)]
    return len(rain)


ref = build_csv(2021, 'HAM', filepath + 'hamilton_dry.csv')
build_csv(2025, 'HAM', filepath + 'hamilton_wet.csv', ref)
build_csv(2021, 'LEC', filepath + 'leclerc_dry.csv', ref)
build_csv(2025, 'LEC', filepath + 'leclerc_wet.csv', ref)
build_csv(2021, 'TSU', filepath + 'tsunoda_dry.csv', ref)
build_csv(2025, 'TSU', filepath + 'tsunoda_wet.csv', ref)
build_csv(2021, 'RUS', filepath + 'russel_dry.csv', ref)
build_csv(2025, 'RUS', filepath + 'russel_wet.csv', ref)