from flask import Flask, jsonify, request
import sklearn
import pandas as pd
import numpy as np
import os
import pickle
import json

def load_model():
    model_path = os.path.join(relative_path, 'clf_pickle')
    f = open(model_path,'rb')
    s = f.read()
    classifier=pickle.loads(s)
    f.close()
    return classifier

def parse(csv_str:str):
    f = open('{}/window.csv'.format(relative_path), 'w')
    f.write(csv_str)
    f.close()
    sample = pd.read_csv('{}/window.csv'.format(relative_path))
    df = pd.DataFrame(columns=['mean_smv', 'std_smv', 'std_mless',
                               'max_smv', 'min_smv', 'slope', 'duration'])
    # total_frames = sample.shape[0]
    smv_list = np.array([])
    for line in range(0, sample.shape[0]):
        acc_x = sample['a_x']
        acc_y = sample['a_y']
        acc_z = sample['a_z']
        smv_list = np.append(smv_list,
                             np.sqrt(pow(acc_x,2) + pow(acc_y,2) + pow(acc_z,2)))

    min_idx = np.argmin(smv_list)
    max_idx = np.argmax(smv_list)

    mean_smv = np.mean(smv_list)
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
    slope = np.sqrt(pow(max_smv_x - min_smv_x, 2)
                   + pow(max_smv_y - min_smv_y, 2)
                   + pow(max_smv_z - min_smv_z, 2))

    parsed_sample = np.array([mean_smv, std_smv, std_motionless_smv, max_smv, min_smv, slope, duration])

    return parsed_sample.reshape(1,-1)



app = Flask(__name__)
@app.route('/', methods = ['POST'])
def predict():
    csv_str = request.json['csv']
    clf = load_model()
    sample = parse(csv_str)
    print(sample)
    result = clf.predict(sample)[0]
    if result == 1:
        print('This is a fall event')
        return jsonify({'result': 'Fall'})
    elif result == 0:
        print('This is a normal event')
        return jsonify({'result': 'Normal'})
    else:
        raise Exception("Did not get correct prediction!")

if __name__ == '__main__':
    relative_path = os.path.dirname(os.path.abspath(__file__))
    app.run(host='0.0.0.0', debug=True, port=5000)
