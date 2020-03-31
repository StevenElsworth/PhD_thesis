import matplotlib.pyplot as plt
from pandas import read_csv
import numpy as np
from statsmodels.tsa.arima_model import ARIMA, ARMA

colors = ['#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F']

series = read_csv('shampoo_sales.csv', header=0, index_col=0)
X = series.values
size = int(len(X) * 0.9)
train, test = X[0:size].ravel(), X[size:len(X)].ravel()

diff_train = np.diff(train)
fig = plt.figure()
plt.plot(np.diff(X.ravel()), 'k', alpha=0.4)
plt.plot(diff_train, 'k')

model1 = ARMA(diff_train, order=(1,0))
fitted_model1 = model1.fit(disp=0)
prediction1 = fitted_model1.forecast(len(X)-size)
plt.plot(np.arange(size-2, size+len(test)-1), [diff_train[-1]]+prediction1[0].tolist(), color=colors[0], label='ARMA(1,0)')

model2 = ARMA(diff_train, order=(1,1))
fitted_model2 = model2.fit(disp=0)
prediction2 = fitted_model2.forecast(len(X)-size)
plt.plot(np.arange(size-2, size+len(test)-1), [diff_train[-1]]+prediction2[0].tolist(), color=colors[1], label='ARMA(1,1)')

model3 = ARMA(diff_train, order=(3,0))
fitted_model3 = model3.fit(disp=0)
prediction3 = fitted_model3.forecast(len(X)-size)
plt.plot(np.arange(size-2, size+len(test)-1), [diff_train[-1]]+prediction3[0].tolist(), color=colors[2], label='ARMA(3,0)')

model4 = ARMA(diff_train, order=(3,3))
fitted_model4 = model4.fit(disp=0)
prediction4 = fitted_model4.forecast(len(X)-size)
plt.plot(np.arange(size-2, size+len(test)-1), [diff_train[-1]]+prediction4[0].tolist(), color=colors[3], label='ARMA(3,3)')
plt.legend()
plt.savefig('figure3B')


fig = plt.figure()
plt.plot(X.ravel(), 'k', alpha=0.4)
plt.plot(train, 'k')

plt.plot()
plt.plot(np.arange(size-1, size+len(test)), np.hstack([train[-1], train[-1] + np.cumsum(prediction1[0])]), color=colors[0], label='ARMA(1,0)')
plt.plot(np.arange(size-1, size+len(test)), np.hstack([train[-1], train[-1] + np.cumsum(prediction2[0])]), color=colors[1], label='ARMA(1,1)')
plt.plot(np.arange(size-1, size+len(test)), np.hstack([train[-1], train[-1] + np.cumsum(prediction3[0])]), color=colors[2], label='ARMA(3,0)')
plt.plot(np.arange(size-1, size+len(test)), np.hstack([train[-1], train[-1] + np.cumsum(prediction4[0])]), color=colors[3], label='ARMA(3,3)')
plt.legend()
plt.savefig('figure3A')
