from flask import Flask, jsonify, request
import pandas as pd
import numpy as np
import pickle
import json

def load_model():
    f = open('clf_pickle','rb')
    s = f.read()
    classifier=pickle.loads(s)
    f.close()
    return classifier

def parse(filePath:str)->np.array:
    sample = pd.read_csv(filePath)
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
    max_smv_x = max_line['acc_x']
    max_smv_y = max_line['acc_y']
    max_smv_z = max_line['acc_z']
    min_smv_x = min_line['acc_x']
    min_smv_y = min_line['acc_y']
    min_smv_z = min_line['acc_z']
    slope = np.sqrt(pow(max_smv_x - min_smv_x, 2)
                   + pow(max_smv_y - min_smv_y, 2)
                   + pow(max_smv_z - min_smv_z, 2))

    parsed_sample = np.array([mean_smv, std_smv, std_motionless_smv, max_smv, min_smv, slope, duration])

    return parsed_sample



app = Flask(__name__)

@app.route('/', methods = ['POST'])
def predict():
    content = json.load(request.body)
    filePath = content['path']
    clf = load_model()
    sample = parse(filePath)
    result = clf.predict(sample)

    if result == 1:
        return jsonify({'result':1})
    else:
        return jsonify({'result':0})

if __name__ == '__main__':
    app.run()