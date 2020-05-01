import matplotlib.pyplot as plt
from pandas import read_csv
import numpy as np
from statsmodels.tsa.arima_model import ARIMA, ARMA
import matplotlib as mpl

def myfigure(nrows=1, ncols=1, fig_ratio=0.71, fig_scale=1): # pragma: no cover
    """
    Parameters
    ----------
    nrows - int
        Number of rows (subplots)
    ncols - int
        Number of columns (subplots)
    fig_ratio - float
        Ratio between height and width
    fig_scale - float
        Scaling which magnifies font size
    Returns
    -------
    fig - matplotlib figure handle
    ax -  tuple of matplotlib axis handles
    Example
    -------
    from util import myfigure
    fig, (ax1, ax2) = myfigure(nrows=2, ncols=1)
    """
    size = 7

    l = 13.2/2.54
    fig, ax = mpl.pyplot.subplots(nrows=nrows, ncols=ncols, figsize=(l/fig_scale, l*fig_ratio/fig_scale), dpi=80*fig_scale, facecolor='w', edgecolor='k')
    mpl.pyplot.subplots_adjust(left=0.11*fig_scale, right=1-0.05*fig_scale, bottom=0.085*fig_scale/fig_ratio, top=1-0.05*fig_scale/fig_ratio)

    # Use tex and correct font

    mpl.rcParams['font.serif'] = ['computer modern roman']
    mpl.rcParams['mathtext.fontset'] = 'custom'
    mpl.rcParams['mathtext.rm'] = 'Bitstream Vera Sans'
    mpl.rcParams['mathtext.it'] = 'Bitstream Vera Sans:italic'
    mpl.rcParams['mathtext.bf'] = 'Bitstream Vera Sans:bold'
    mpl.rcParams['font.size'] = size

    # MATLAB default (see MATLAB Axes Properties documentation)
    mpl.rcParams['legend.fontsize'] = size

    # remove margine padding on axis
    mpl.rcParams['axes.xmargin'] = 0
    mpl.rcParams['axes.ymargin'] = 0

    mpl.pyplot.tight_layout(pad=1.3) # padding

    # Save fig with transparent background
    mpl.rcParams['savefig.transparent'] = True

    # Make legend frame border black and face white
    mpl.rcParams['legend.edgecolor'] = 'k'
    mpl.rcParams['legend.facecolor'] = 'w'
    mpl.rcParams['legend.framealpha'] = 1

    # Change colorcycle to MATLABS
    c = mpl.cycler(color=['#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F'])

    if isinstance(ax, np.ndarray):
        ax = ax.ravel()
        for axi in ax:
            axi.set_prop_cycle(c) # color cycle
            axi.xaxis.label.set_size(1.1*size) # xaxis font size
            axi.yaxis.label.set_size(1.1*size) # yaxis font size
            axi.tick_params(axis='both', which='both', labelsize=size, direction='in') # fix ticks
    else:
        ax.set_prop_cycle(c) # color cycle
        ax.tick_params(axis='both', which='both', labelsize=size, direction='in') # fix ticks
        ax.xaxis.label.set_size(1.1*size) # xaxis font size
        ax.yaxis.label.set_size(1.1*size) # yaxis font size
    return fig, ax




colors = ['#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F']

series = read_csv('shampoo_sales.csv', header=0, index_col=0)
X = series.values
size = int(len(X) * 0.9)
train, test = X[0:size].ravel(), X[size:len(X)].ravel()

fig, ax = myfigure(fig_scale=1.8)
ax.plot(X.ravel(), 'k')
plt.savefig('figure5A.png')
plt.savefig('figure5A.pdf')

fig, ax = myfigure(fig_scale=1.8)
ax.plot(np.diff(X.ravel()), 'k')
plt.savefig('figure5B.png')
plt.savefig('figure5B.pdf')

diff_train = np.diff(train)
fig, ax = myfigure(fig_scale=1.8)
ax.plot(np.diff(X.ravel()), 'k', alpha=0.4, label='truth')
ax.plot(diff_train, 'k')

model1 = ARMA(diff_train, order=(1,0))
fitted_model1 = model1.fit(disp=0)
prediction1 = fitted_model1.forecast(len(X)-size)
ax.plot(np.arange(size-2, size+len(test)-1), [diff_train[-1]]+prediction1[0].tolist(), color=colors[0], linestyle='-', label='ARMA(1,0)')

model2 = ARMA(diff_train, order=(1,1))
fitted_model2 = model2.fit(disp=0)
prediction2 = fitted_model2.forecast(len(X)-size)
ax.plot(np.arange(size-2, size+len(test)-1), [diff_train[-1]]+prediction2[0].tolist(), color=colors[1], linestyle='--', label='ARMA(1,1)')

model3 = ARMA(diff_train, order=(3,0))
fitted_model3 = model3.fit(disp=0)
prediction3 = fitted_model3.forecast(len(X)-size)
ax.plot(np.arange(size-2, size+len(test)-1), [diff_train[-1]]+prediction3[0].tolist(), color=colors[2], linestyle='-.', label='ARMA(3,0)')

model4 = ARMA(diff_train, order=(3,3))
fitted_model4 = model4.fit(disp=0)
prediction4 = fitted_model4.forecast(len(X)-size)
ax.plot(np.arange(size-2, size+len(test)-1), [diff_train[-1]]+prediction4[0].tolist(), color=colors[3], linestyle=':', label='ARMA(3,3)')
#plt.legend()
ax.set_xlim([25, 35])
plt.savefig('figure5C.png')
plt.savefig('figure5C.pdf')

fig, ax = myfigure(fig_scale=1.8)
ax.plot(X.ravel(), 'k', alpha=0.4, label='truth')
ax.plot(train, 'k')
ax.plot(np.arange(size-1, size+len(test)), np.hstack([train[-1], train[-1] + np.cumsum(prediction1[0])]), color=colors[0], linestyle='-', label='ARMA(1,0)')
ax.plot(np.arange(size-1, size+len(test)), np.hstack([train[-1], train[-1] + np.cumsum(prediction2[0])]), color=colors[1], linestyle='--', label='ARMA(1,1)')
ax.plot(np.arange(size-1, size+len(test)), np.hstack([train[-1], train[-1] + np.cumsum(prediction3[0])]), color=colors[2], linestyle='-.', label='ARMA(3,0)')
ax.plot(np.arange(size-1, size+len(test)), np.hstack([train[-1], train[-1] + np.cumsum(prediction4[0])]), color=colors[3], linestyle=':', label='ARMA(3,3)')
plt.legend()
ax.set_xlim([25, 35])
plt.savefig('figure5D.png')
plt.savefig('figure5D.pdf')
