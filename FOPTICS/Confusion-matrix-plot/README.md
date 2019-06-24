## Confusion matrix
This function plots the confusion matrix.


### How to run
Call plot_confusion_matrix(cm, classes, precision, normalize=True, title='Confusion matrix', cmap=plt.cm.Blues), where

* *cm* is an n x n numpy array representing the confusion matrix with on the y-axis the true labels and x-axis predicted labels;
* *classes* is a list of length n with the class labels in the same order as cm;
* *precision* is the precision to be displayed;
* *normalize* determines whether the matrix has to be normalized or not;
* *title* is the title of the plot;
* *cmap* is the color map


### References:
* https://scikit-learn.org/stable/auto_examples/model_selection/plot_confusion_matrix.html#sphx-glr-auto-examples-model-selection-plot-confusion-matrix-py