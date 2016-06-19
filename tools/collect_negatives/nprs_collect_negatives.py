#!/usr/bin/env python

from sklearn import svm
import numpy as np
import json
import random
import sys

def load_data():
    return json.load(sys.stdin)

data = load_data()
train_data = data['train_data']
trace_regions = data['trace_regions']
num_samples = data['num_samples']

clf = svm.OneClassSVM(nu=0.1, kernel="rbf", gamma=0.1)
clf.fit(train_data)

regions = trace_regions.values()
labels = clf.predict(map(lambda f: f['features'], regions))

normals = filter(lambda x: x[0] == 1., zip(labels, trace_regions.keys()))
outliers = filter(lambda x: x[0] == -1., zip(labels, trace_regions.keys()))

negative_samples = map(lambda x: x[1], random.sample(outliers, num_samples))

result = {
    'normals_percent': len(normals) / float(len(regions)) * 100,
    'outliers_percent': len(outliers) / float(len(regions)) * 100,
    'samples': negative_samples
}

print json.dumps(result)
