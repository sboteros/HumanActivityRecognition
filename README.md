# HumanActivityRecognition
Human Activity Recognition - Tidying a data set from cellphone accelerometers

# Reference

We used [Aguita, Ghio, Oneto, Parra and Reyes-Ortiz's (2013) data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
about Human Activity Recognition Using Smartphones.

# Contents

It downloads the data set refered previously and merges each type of information
in one dataset. The resulting datasets are named:

+ `database`: Contains the information about the features meassured for both the
training and the test datasets. This database has descriptive activity names to
the activities performed by the subjects when meassured, and descriptive
variable names as described in the section "Training and test database" of the
[CodeBook](CodeBook.md).
+ `signals`: Contains the raw meassurements about the signals taken from each
subject, used to compute the features shown in the `database`; the signals are
explained in the file `features_info.txt` of the data explained
[previosly](#Reference) and in the section "Signals database" of the
[CodeBook](CodeBook.md). This database has descriptive variable names about the
meassurements (`body_acc`, `body_gyro`, and `total_acc`) and the identificator
of each one (`subject`, `id`, `dataset`, `axe`, and `reading`).

Then, we computed two additional databases:

+ `moments`: The variable `feature` in `database` has 561 different features.
Those features corresponds to 17 computations on the data, listed in lines 33 to
49 of the `features_info.txt` file in the downloaded data. The first two
moments (`mean` and `sd`), denoted `mean()` and `std()` are of particular
interest; so there has been  extracted in the database `moments`. This database
has the same variables as the `database`.
+ `averages`: It shows the `mean` value of each feature meassurement available
in the `database`, by subject and activity. 

# Autorship
+ **Name**: Santiago Botero Sierra
+ **Correo-e**: sboteros@unal.edu.co
+ **Date**: 2019/06/24
