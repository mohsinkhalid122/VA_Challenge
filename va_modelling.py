#!/usr/bin/env python

import pandas as pd
from teradataml.dataframe.copy_to import copy_to_sql
from teradataml.context.context import *
from sklearn.ensemble import RandomForestRegressor,RandomForestClassifier
import numpy as np

#Load Cykotine Data

train=pd.read_csv('train.csv')
test=pd.read_csv('test.csv')


train = train.dropna()
test = test.fillna(0)


# ## Train Cykotine Model

regr = RandomForestRegressor(n_estimators=50,max_depth=25, random_state=0)
regr.fit(X_train, y_train)


# ## Generate Cykotine Forecasted Scores

file = open("final_ds.csv","w")
file.write('Date,Patient,Encounter,cs_score_pred')
file.write('\n')
for i in X_test:
    pat_data = (i[:3])
    pred_res = regr.predict([i[-144:]])
    s = np.concatenate([pat_data,pred_res])
    for j in s:
        file.write(str(j)+",")
    file.write('\n')


test=pd.read_csv('final_ds.csv')
test = test.fillna(0)
X_test=test.values


# ## Preprocess Mortality Data

train=pd.read_csv('mort_train.csv')


train1 = train.loc[train['Mortality_Label'] == 0]
train2 = train.loc[train['Mortality_Label'] == 1]

train2 = train2.sort_values(by=['cs_score'])


train2 = train2.tail(1700)


train = train1.append(train2)


X_train = train.drop(['patient','Mortality_Label'],axis=1).values
y_train = train['Mortality_Label'].values


# ## Train Mortality Model

regr = RandomForestClassifier(n_estimators=50,max_depth=25, random_state=0)
regr.fit(X_train, y_train)


# ## Generate Mortality Probabilities

file = open("final_mort_ds_probs.csv","w")
file.write('Date,Patient,Encounter,mort_prob')
file.write('\n')
for i in X_test:
    pat_data = (i[:3])
    pred_res = regr.predict_proba([i[-1:]])
    s = np.concatenate([pat_data,[pred_res[0][1]]])
    for j in s:
        file.write(str(j)+",")
    file.write('\n')


# ## Preprocess ICU Days Data

train=pd.read_csv('icu_train.csv')


train1 = train.loc[train['Days_In_ICU'] == 0]
train2 = train.loc[train['Days_In_ICU'] > 0]


train1 = train1.sort_values(by=['cs_score'])


train1 = train1.tail(1700)


train = train1.append(train2)


X_train = train.drop(['patient','Days_In_ICU'],axis=1).values
y_train = train['Days_In_ICU'].values


# ## Train ICU Days Model

regr = RandomForestRegressor(max_depth = 10, max_features = 'sqrt', n_estimators = 10)
regr.fit(X_train, y_train)


# ## Generate ICU Days

file = open("final_icu_ds_probs.csv","w")
file.write('Date,Patient,Encounter,icu_prob')
file.write('\n')
for i in X_test:
    pat_data = (i[:3])
    pred_res = regr.predict_proba([i[-1:]])
    s = np.concatenate([pat_data,[pred_res[0][1]]])
    for j in s:
        file.write(str(j)+",")
    file.write('\n')


# ## Preprocess Covid19 +/- Data


train=pd.read_csv('covid_model.csv')


train1 = train.loc[train['test_result'] == 1]
train2 = train.loc[train['test_result'] == 0]



train2 = train2.sort_values(by=['cs_score'])


train2 = train2.tail(1700)


train = train1.append(train2)


X_train = train.drop(['patient','test_result'],axis=1).values
y_train = train['test_result'].values


# ## Train Covid19 +/- Data


regr = RandomForestClassifier()
regr.fit(X_train, y_train)


# ## Generate Covid19 +/- Probabilities


file = open("final_covid_ds_probs.csv","w")
file.write('Date,Patient,Encounter,covid_prob')
file.write('\n')
for i in X_test:
    pat_data = (i[:3])
    pred_res = regr.predict_proba([i[-1:]])
    s = np.concatenate([pat_data,[pred_res[0][1]]])
    for j in s:
        file.write(str(j)+",")
    file.write('\n')


# ## Preprocess Ventilator Data


train=pd.read_csv('vent_train.csv')


train1 = train.loc[train['Vent_Status'] == 1]
train2 = train.loc[train['Vent_Status'] == 0]


train2 = train2.sort_values(by=['cs_score'])


train2 = train2.tail(1700)


train = train1.append(train2)


X_train = train.drop(['patient','Vent_Status'],axis=1).values
y_train = train['Vent_Status'].values


# ## Train Ventilator Model

regr = RandomForestClassifier(n_estimators=50,max_depth=25, random_state=0)
regr.fit(X_train, y_train)


# ## Generate Ventilator Probabilities

file = open("final_vent_ds_probs.csv","w")
file.write('Date,Patient,Encounter,vent_prob')
file.write('\n')
for i in X_test:
    pat_data = (i[:3])
    pred_res = regr.predict_proba([i[-1:]])
    s = np.concatenate([pat_data,[pred_res[0][1]]])
    for j in s:
        file.write(str(j)+",")
    file.write('\n')


# ## Preprocess Hospitalized Days Data


train=pd.read_csv('host_train.csv')


train1 = train.loc[train['Days_Hospitalized'] > 0]
train2 = train.loc[train['Days_Hospitalized'] == 0]


train2 = train2.sort_values(by=['cs_score'])


train2 = train2.tail(200)


train = train1.append(train2)


X_train = train.drop(['patient','Days_Hospitalized'],axis=1).values
y_train = train['Days_Hospitalized'].values


# ## Train Hospitalize Days Model


regr = RandomForestRegressor()
regr.fit(X_train, y_train)


# ## Generate Hospitalized Days

file = open("final_host_ds_probs.csv","w")
file.write('Date,Patient,Encounter,host_prob')
file.write('\n')
for i in X_test:
    pat_data = (i[:3])
    pred_res = regr.predict_proba([i[-1:]])
    s = np.concatenate([pat_data,[pred_res[0][1]]])
    for j in s:
        file.write(str(j)+",")
    file.write('\n')


# ## Parameter Tuning 

from sklearn.model_selection import GridSearchCV
estimator = RandomForestRegressor()
param_grid = { 
        "n_estimators"      : [10,50,100],
        "max_features"      : ["auto", "sqrt", "log2"],
        "max_depth" : [2,10,15]
        }
grid = GridSearchCV(estimator, param_grid, n_jobs=-1, cv=5)

grid.fit(X_train, y_train)

