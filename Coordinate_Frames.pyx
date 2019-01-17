import sys
import re
import tkinter
import matplotlib as plt
import time
import math
import numpy as np
from scipy import stats
from tkinter import filedialog
from mainform import *
from matplotlib import pyplot
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QTableWidget, QTableWidgetItem


class MyWin(QtWidgets.QMainWindow):

    def __init__(self, parent=None):
        QtWidgets.QWidget.__init__(self, parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        root = tkinter.Tk()
        root.withdraw()
        self.ui.pushButton.clicked.connect(self.button_1_click)
        self.ui.pushButton_2.clicked.connect(self.button_2_click)
        self.ui.pushButton_3.clicked.connect(self.button_3_click)
        self.ui.pushButton_4.clicked.connect(self.button_4_click)
        self.ui.pushButton_5.clicked.connect(self.button_5_click)
        self.ui.pushButton_6.clicked.connect(self.button_6_click)
        self.ui.pushButton_7.clicked.connect(self.button_7_click)
        self.belx = []
        self.bely = []
        self.belz = []
        plt.use('QT5Agg')

    def button_1_click(self):
        self.coord_df = MyWin.parser()
        self.ui.tableWidget.setRowCount(len(self.coord_df))
        for i in range(len(self.coord_df)):
            self.belx.append(self.coord_df[i][0])
            self.ui.tableWidget.setItem(i, 0, QTableWidgetItem(str(self.belx[i])))
            self.belx[i] = float(self.belx[i])
            self.belx[i] = round(self.belx[i])
            self.bely.append(self.coord_df[i][1])
            self.ui.tableWidget.setItem(i, 1, QTableWidgetItem(str(self.bely[i])))
            self.bely[i] = float(self.bely[i])
            self.bely[i] = round(self.bely[i])
            self.belz.append(self.coord_df[i][2])
            self.ui.tableWidget.setItem(i, 2, QTableWidgetItem(str(self.belz[i])))
            self.belz[i] = float(self.belz[i])
            self.belz[i] = round(self.belz[i])
        else:
            pass

    def button_2_click(self):
        gkde = stats.gaussian_kde(self.belx)
        ind = np.linspace(min(self.belx), max(self.belx), 100)
        kdepdf = gkde.evaluate(ind)
        plt.pyplot.figure()
        plt.pyplot.hist(self.belx, bins=200, density=1)
        plt.pyplot.plot(ind, kdepdf, color='g')
        plt.pyplot.show()

    def button_3_click(self):
        gkde = stats.gaussian_kde(self.bely)
        ind = np.linspace(min(self.bely), max(self.bely), 100)
        kdepdf = gkde.evaluate(ind)
        plt.pyplot.figure()
        plt.pyplot.hist(self.bely, bins=200, density=1)
        plt.pyplot.plot(ind, kdepdf, color='g')
        plt.pyplot.show()

    def button_4_click(self):
        gkde = stats.gaussian_kde(self.belz)
        ind = np.linspace(min(self.belz), max(self.belz), 100)
        kdepdf = gkde.evaluate(ind)
        plt.pyplot.figure()
        plt.pyplot.hist(self.belz, bins=200, density=1)
        plt.pyplot.plot(ind, kdepdf, color='g')
        plt.pyplot.show()

    def button_5_click(self):
        n, h, labels = MyWin.sturges_rule(len(self.coord_df), max(self.belx), min(self.belx))
        fig, ax = plt.pyplot.subplots()
        counts, bins, patches = ax.hist(self.belx, bins=n)
        ax.set_xticks(bins)
        bin_centers = 0.5 * np.diff(bins) + bins[:-1]
        plt.pyplot.xticks(bin_centers, labels)
        plt.pyplot.show()

    def button_6_click(self):
        n, h, labels = MyWin.sturges_rule(len(self.coord_df), max(self.bely), min(self.bely))
        fig, ax = plt.pyplot.subplots()
        counts, bins, patches = ax.hist(self.bely, bins=n)
        ax.set_xticks(bins)
        bin_centers = 0.5 * np.diff(bins) + bins[:-1]
        plt.pyplot.xticks(bin_centers, labels)
        plt.pyplot.show()

    def button_7_click(self):
        n, h, labels = MyWin.sturges_rule(len(self.coord_df), max(self.belz), min(self.belz))
        fig, ax = plt.pyplot.subplots()
        counts, bins, patches = ax.hist(self.belz, bins=n)
        ax.set_xticks(bins)
        bin_centers = 0.5 * np.diff(bins) + bins[:-1]
        plt.pyplot.xticks(bin_centers, labels)
        plt.pyplot.show()

    @staticmethod
    def parser():
        file_path = filedialog.askopenfilename()
        start_time = time.time()
        coord = open(file_path, 'r')
        coord = coord.read()
        pattern = r"(\d+.\d{2})\s{3}(\d+.\d{2})\s{2}(\d+.\d{2})"
        match = re.findall(pattern, coord)
        print("--- %s seconds ---" % (time.time() - start_time))
        return match

    @staticmethod
    def sturges_rule(N, max, min):
        labels = []
        n = 1 + math.floor(math.log2(N))
        h = (max - min) / n
        for i in range(n):
            label = str(min) + '...' + str(math.floor(min + h))
            min += math.floor(h)
            labels.append(label)
        return n, h, labels

    # Back up the reference to the exceptionhook
    sys._excepthook = sys.excepthook

    def my_exception_hook(exctype, value, traceback):
        # Print the error and traceback
        print(exctype, value, traceback)
        # Call the normal Exception hook after
        sys._excepthook(exctype, value, traceback)
        sys.exit(1)

    # Set the exception hook to our wrapping function
    sys.excepthook = my_exception_hook


if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    myapp = MyWin()
    myapp.show()
    try:
        sys.exit(app.exec_())
    except:
        print("Exiting")

