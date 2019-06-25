# Human Activity Recognition
# Getting and cleaning data course project
# Data science specialization
# Santiago Botero S.
# sboteros@unal.edu.co
# 2019/06/24
# Encoding: UTF-8

# General settings
  directory <- "C:/Users/sbote/OneDrive/Documentos/DataScienceSpecialization/3 Getting and cleaning data/HumanActivityRecognition"
  setwd(directory)
  if (!dir.exists("./data/")) {dir.create("./data/")}
  
# Packages
  packages <- c("dplyr", "tidyr", "readr")
  for (i in packages) {
    if (!require(i, character.only = TRUE)) {
      install.packages(i)
    }
    library(i, character.only = TRUE)
  }
  rm(list = c("i", "packages"))
  
# 1. Getting data
  if (!file.exists("./data/dataset.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  "./data/dataset.zip")
    unzip("./data/dataset.zip", exdir = "./data")
  }

# 2. Merged datasets
  # 2.1. Features
    features <- read.table(file.path(".", "data", "UCI HAR Dataset",
                                     "features.txt"), 
                           col.names = c("meassurement", "feature"),
                           stringsAsFactors = FALSE) %>%
      tbl_df
  
  # 2.2. Activities
    activities <- read.table(file.path(".", "data", "UCI HAR Dataset",
                                       "activity_labels.txt"), 
                             col.names = c("label", "activity"),
                             stringsAsFactors = FALSE) %>%
      tbl_df
  
  # 2.3. Dataset
  database <- NULL
  for (dataset in c("test", "train")) {
    l <- read.table(file.path(".", "data", "UCI HAR Dataset", dataset,
                              paste("Y_", dataset, ".txt", sep = ""))) %>%
      tbl_df %>%
      select(label = V1) %>%
      merge(activities) %>%
      select(activity)
    m <- read.table(file.path(".", "data", "UCI HAR Dataset", dataset,
                              paste("subject_", dataset, ".txt", sep = ""))) %>%
      tbl_df %>%
      select(subject = V1)
    n <- read.table(file.path(".", "data", "UCI HAR Dataset", dataset,
                              paste("X_", dataset, ".txt", sep = ""))) %>%
      tbl_df
    n <- cbind(l, m, n) %>%
      tbl_df %>%
      gather(key = "meassurement", value = "meassure", -(1:2)) %>%
      mutate(dataset = dataset, meassurement = parse_number(meassurement)) %>%
      merge(features) %>%
      select(subject, activity, dataset, feature, meassure)
    
    database <- rbind(database, n)
  }
  rm(list = c("dataset", "l", "m", "n", "activities", "features"))
  
# 3. Signals database
  signals <- NULL
  for (dataset in c("test", "train")) {
     for (meassure in c("body_acc", "body_gyro", "total_acc")) {
      for (axe in c("x", "y", "z")) {
        l <- read.table(file.path(".", "data", "UCI HAR Dataset", dataset,
                                  paste("subject", "_", dataset, ".txt", 
                                        sep = ""))) %>%
          tbl_df %>%
          select(subject = V1) %>%
          mutate(id = row_number())
        m <- c(dataset, meassure, axe) %>%
          rep(nrow(l)) %>% 
          matrix(ncol = 3, byrow = TRUE, 
                 dimnames = list(1:nrow(l),c("dataset", "meassure", "axe"))) %>% 
          as.data.frame %>%
          tbl_df
        n <- read.table(file.path(".", "data", "UCI HAR Dataset", dataset,
                                  "Inertial Signals", 
                                  paste(meassure, "_", axe, "_", dataset,
                                        ".txt", sep = ""))) %>%
          tbl_df
        n <- cbind(l, m, n) %>%
          gather(key = "reading", value = "meassurement", -c(1:5)) %>%
          mutate(reading = parse_number(reading))
        signals <- rbind(signals, n) %>% tbl_df
      }
    }
  }
  rm(list = c("dataset", "meassure", "axe", "l", "m", "n"))
  signals <- spread(signals, meassure, meassurement)
  
# 4. Mean and standar deviations
  moments <- database %>%
    filter(grepl("mean()|std()", feature))

# 5. Average features, by activity and subject
  averages <- database %>%
    group_by(subject, activity, feature) %>%
    summarize(average = mean(meassure))
  