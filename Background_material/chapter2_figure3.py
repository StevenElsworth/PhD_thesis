import matplotlib.pyplot as plt
from pandas import read_csv
import numpy as np
from statsmodels.tsa.arima_model import ARIMA

series = read_csv('shampoo_sales.csv', header=0, index_col=0)
X = series.values
size = int(len(X) * 0.8)
train, test = X[0:size], X[size:len(X)]
model = ARIMA(train, order=(3,1,3))
fitted_model = model.fit(disp=0)

prediction = fitted_model.forecast(len(X)-size)
plt.plot(train, 'k')
plt.plot(np.arange(size-1, size+len(test)), [train[-1]]+test.tolist())
plt.plot(np.arange(size-1, size+len(test)), [train[-1]]+prediction[0].tolist(), color='red')
plt.show()
