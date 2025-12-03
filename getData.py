import fastf1 as f1
import pandas as pd

filepath = './data/'

def build_csv(year, driver, lap, filename):
    session = f1.get_session(year, 'Silverstone', 'R')
    session.load()

    laps = session.laps.pick_driver(driver)
    curr_lap = laps.pick_lap(lap)
    car = curr_lap.get_car_data().add_distance()
    pos = curr_lap.get_pos_data()
    tel = pd.merge_asof(car, pos, on='Time')

    data = pd.DataFrame({
        'Driver': driver,
        'Lap': lap,
        'Time': tel['Time'],
        'X': tel['X'],
        'Y': tel['Y'],
        'Speed': tel['Speed'],
        'Throttle': tel['Throttle'],
        'Braking': tel['Brake']
    })

    data.to_csv(filename, index=False)

build_csv(2021, 'HAM', 11, filepath + 'hamilton_dry.csv')
build_csv(2025, 'HAM', 11, filepath + 'hamilton_wet.csv')
build_csv(2021, 'LEC', 11, filepath + 'leclerc_dry.csv')
build_csv(2025, 'LEC', 11, filepath + 'leclerc_wet.csv')
build_csv(2021, 'TSU', 11, filepath + 'tsunoda_dry.csv')
build_csv(2025, 'TSU', 11, filepath + 'tsunoda_wet.csv')