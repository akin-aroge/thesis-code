import pandas as pd
from os import listdir
from os.path import isfile, join, basename
import numpy as np


class ExpDataStruct:
    def __init__(self):
        self.curr_dens = 0
        self.temp = 0
        self.humidity = 0
        self.data = 0
        self.params = 0
        self.pol_fwd = 0
        self.pol_rev = 0
        self.name = ''


def get_data(filename):
    """
This method helps to retrieve data from existing
excel file with full pathname "filename"
    """
    dt = pd.read_excel(filename, sheetname=0, header=None, )
    df = pd.DataFrame(data=dt, index=None)

    # check for the file type
    if df.iloc[0, 0] == 'Current density (mA/cm2)':  # this is EIS data

        eis_data = ExpDataStruct()  # initializes the struct for eis_data

        name = basename(filename)
        curr_dens = df.iloc[0, 1]  # grabs the current density for the EIS data
        col_name = df.iloc[1, :].tolist()

        # clean eis data
        data = df
        data.columns = col_name
        data = data.dropna(how='any')
        data = data[1:]
        data = data.reset_index(drop=True)

        # populate the eis_data struct
        eis_data.data = data
        eis_data.curr_dens = curr_dens
        eis_data.name = name

        exp_data = eis_data  # assign populated eis_data struct to return variable

    elif df.iloc[0, 0] == 'Set point values':  # this is polarisation curve data

        pol_data = ExpDataStruct()

        # clean parameter portion of the data
        params = df.iloc[:, 0:2]
        params = params.dropna(how='any')
        params.columns = ['set point', 'value']
        params = params.reset_index(drop=True)

        name = basename(filename)

        # clean pol_fwd portion of the data
        pol_fwd = df.iloc[:, 3:9]
        pol_fwd = pol_fwd.dropna(how='any')
        pol_fwd.columns = ['cell temp C', 'curr_den', 'v1', 'v2', 'v3', 'avg_volt']
        pol_fwd = pol_fwd.reset_index(drop=True)

        # clean pol_reverse portion of the data
        pol_rev = df.iloc[:, 10:16]
        pol_rev = pol_rev.dropna(how='any')
        pol_rev.columns = ['cell temp C', 'curr_den', 'v1', 'v2', 'v3', 'avg_volt']
        pol_rev = pol_rev.reset_index(drop=True)

        # populate the pol_data struct
        pol_data.params = params
        pol_data.pol_fwd = pol_fwd
        pol_data.pol_rev = pol_rev
        pol_data.name = name

        exp_data = pol_data  # assign populated pol_data struct to return variable

    return exp_data


def add_var(eis_data):
    """
    This methods computes other variables from the eis_data.data columns
    The variables extend the number of column if the data.
    """
    # calculate magnitude
    re = np.float64(eis_data.data['Imp Re'])
    img = np.float64(eis_data.data['Imp i'])
    eis_data.data['Mag'] = np.sqrt(re ** 2 + img ** 2)
    eis_data.data['Phase'] = np.arctan(img / re)

    return eis_data

# gets the full paths to the experiment file from the exp_path directory
exp_path = "C:\\Users\Aroogz\Desktop\Work - UCT\PG\Data\\fwd\\"

exp_files = []
for f in listdir(exp_path):
    if isfile(join(exp_path, f)):
        exp_files.append(join(exp_path, f))

# Looking and picking out polarisation and EIS files
exp_files_pol = []
exp_files_eis = []
for path in exp_files:
    if 'polarisation' in path:
        exp_files_pol.append(path)
    elif 'EIS' in path:
        exp_files_eis.append(path)
    else:
        pass

