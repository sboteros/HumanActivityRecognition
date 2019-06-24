# Training and test database

We have the following databases:

+ Two databases, `X_train` and `X_test`, which contains observations on 561
features of each individual (assignes to `train` or `test`, respectively),
labeled according to the activity of the subject when the meassurement was
taken.
+ The information about the label of the activity corresponding to the
meassures is in the databases `Y_train` and `Y_test`, which have one label per
row.
+ The information about the meassured subject is in the databases
`subject_train` and `subject_test`.

The three `train` and the three `test` databases share the same number of rows,
corresponding to the same meassurement. Therefore, those databases where
unified appending the columns.

The original databases where in wide format, so we transformed it to long format,
and added the labels available in `activity_labels.txt` and `features.txt` to
the dataset. Finally, we got one database with the following variables:

+ `subject`: Subject from whic the information was meassured. Integer
identificator ranging from 1 to 30.
+ `activity`: Activity performed by the subject when the meassured was taken; it
can be: "LAYING", "SITTING", "WALKING", "WALKING_DOWNSTAIRS", or
"WALKING_UPSTAIRS".
+ `dataset`: String that indicates wheter the subject is in the test or the
training dataset. It can be: "test" or "training".
+ `feature`: meassured feature; the features are available in the file
`features.txt` of the downloaded data.
+ `meassure`: meassurement of the feature, normalized in the range -1 to 1.
The meaning of each feature is explained in the file `features_info.txt` of the
downloaded data.

# Signals database

## Meassurements

We have 18 datasets, wich are denoted by the cross-product of
meassure * axe * subjects, where:

+ **Meassure**: {"body_acc", "body_gyro", "total_acc"} . Where `acc` means
acceleration, and `gyro` are meassures from the gyroscope. The acceleration
can be de total acceleration, as meassured by the smarphone's accelerometer;
or the body acceleration, wich is the total acceleration minus the gravity.
+ **Axe**: {"x", "y", "z"}. Meassures where taken in a thre-dimensional space:
lineal space (for the acceleration), and angular space (for the gyroscope).
+ **Subjects**: {"train", "test"}. The database where divided randomly in
train and test data, where 70% of participants belongs to the train dataset.

Each of these datasets has 128 windows/readings, which corresponds with
time-spans of 2.56 seconds. Each row corresponds to one observation of one
subject; and each column corresponds to one of the 128 readings of that
observation.

## Subjects

Additionally, we have two datasets denoted `subject_train` and `subject_test`,
with one column corresponding to a subject, an as many rows as the corresponding
data that corresponds to the subject being observed. The rows of `subject_train`
and `subject_test` corresponds possitionally with the rows of the corresponding
dataset.

## Unified database

We read each of the 18 meassurement databases and binded the information with
the individual to which each observation was taken; we added one unique `id` to
each observation (one meassure to one subject). Additionally, we added the
information contained in the filename of each dataset, to the dataset itself.

Then we converted the data from long format to wide format, where the values on
each of the original 128 columns in the meassurement dataset, corresponds to a
new variable named `meassurement`, and the name of the window/reading where
registered in a variable named `reading`. Then, we generated three variables
(`body_acc`, `body_gyro` and `total_acc`), with the `meassurement` of each one
of the corresponding meassures.

So, the unified database is composed of 8 variables:

+ `subject`: corresponds to the observed individual whose information is
reported. It's an integer ranging from 1 to 30.
+ `id`: corresponds to one observation of one subject.
+ `dataset`: is a factor which can be `test` or `train`, indicating the original
dataset where the information came.
+ `axe`: indicates the axis from which the meassurement is taken (X, Y or Z).
+ `reading`: Each individual activity was read 128 times; this is an integer
ranging from 1 to 128 indicating which reading/window is meassured.
+ `total_acc`: The acceleration signal from the smartphone accelerometer, in the
axis `axe`, meassured in standard gravity units 'g'.
+ `body_acc`: The body acceleration signal obtained by subtracting the gravity
from the total acceleration (`total_acc`), meassured in standard gravity units
'g'.
+ `body_gyro`: The angular velocity vector measured by the gyroscope for each
window sample. The units are radians/second.
