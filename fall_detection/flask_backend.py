from flask import Flask, jsonify, request
import sklearn
import pandas as pd
import numpy as np
import math
import os
import pickle
import json

def load_model():
    model_path = os.path.join(relative_path, 'svm')
    scaler_path = os.path.join(relative_path, 'scaler')
    f = open(model_path,'rb')
    s = f.read()
    svm = pickle.loads(s)
    f.close()
    g = open(scaler_path,'rb')
    s = g.read()
    scaler = pickle.loads(s)
    g.close()
    return svm, scaler

def parse(csv_str:str):
    f = open('{}/window.csv'.format(relative_path), 'w')
    f.write(csv_str)
    f.close()
    sample = pd.read_csv('{}/window.csv'.format(relative_path))
    df = pd.DataFrame(columns=['mean_ax','mean_ay','mean_az',
                                'mean_smv', 'std_smv', 'std_mless',
                               'max_smv', 'min_smv', 'slope', 'duration'])
    
    smv_list = []
    for line in range(0, sample.shape[0]):
        acc_x = sample['a_x'][line]
        acc_y = sample['a_y'][line]
        acc_z = sample['a_z'][line]
        smv_list.append(math.sqrt(pow(acc_x,2) + pow(acc_y,2) + pow(acc_z,2)))
    smv_list = np.asarray(smv_list)
    min_idx = np.argmin(smv_list)
    max_idx = np.argmax(smv_list)
    mean_ax = np.mean(sample['a_x'])
    mean_ay = np.mean(sample['a_y'])
    mean_az = np.mean(sample['a_z'])
    mean_smv = np.mean(smv_list)
    std_ax = np.std(sample['a_x'])
    std_ay = np.std(sample['a_y'])
    std_az = np.std(sample['a_z'])
    std_smv = np.std(smv_list)
    std_motionless_smv = np.std(smv_list[min_idx:])
    max_smv = np.max(smv_list)
    min_smv = np.min(smv_list)
    duration = (min_idx - max_idx) * 10
    max_line = sample.iloc[max_idx]
    min_line = sample.iloc[min_idx]
    max_smv_x = max_line['a_x']
    max_smv_y = max_line['a_y']
    max_smv_z = max_line['a_z']
    min_smv_x = min_line['a_x']
    min_smv_y = min_line['a_y']
    min_smv_z = min_line['a_z']
    slope = math.sqrt(pow(max_smv_x - min_smv_x, 2)
                   + pow(max_smv_y - min_smv_y, 2)
                   + pow(max_smv_z - min_smv_z, 2))

    parsed_sample = np.array([mean_ax, mean_ay, mean_az, mean_smv,
                             std_ax, std_ay, std_az, std_smv, std_motionless_smv, 
                            max_smv, min_smv, slope, duration])

    return parsed_sample.reshape(1,-1)



app = Flask(__name__)
@app.route('/', methods = ['POST'])
def predict():
    csv_str = request.json['csv']
    svm, scaler = load_model()
    sample = parse(csv_str)
    print('-'*69)
    print('Sample Vector: {}'.format(sample[0]))
    sample_nm = scaler.transform(sample)
    result = svm.predict(sample_nm)[0]
    if result == 1:
        print('This is a fall event')
        print('-'*69)
        return jsonify({'result': 'Fall'})
    elif result == 0:
        print('This is a normal event')
        print('-'*69)
        return jsonify({'result': 'Normal'})
    else:
        raise Exception("Did not get correct prediction!")

if __name__ == '__main__':
    relative_path = os.path.dirname(os.path.abspath(__file__))
    app.run(host='0.0.0.0', debug=True, port=5000)
