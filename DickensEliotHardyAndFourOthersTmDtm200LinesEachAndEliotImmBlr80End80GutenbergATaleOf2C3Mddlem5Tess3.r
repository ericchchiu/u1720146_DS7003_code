#uel 19/20 DS7003
#WARNING!!! because there is a non-ascii character â in the code, after importing this code to RStudio, one should select File -> Reopen with encoding... then select UTF-8
#Besides the three popular female English novelists I used in the last attempt (17 Helen Mathers 1853-1920 67 (18010- 18669 in csv file), 32 Lucas Malet 1852-1931 79 (33861-34563), 33 Marie Corelli 1855-1924 69 (34564-36305)), I added four novelists, a propular male novelist born in 1850s': 12 Fergue Hume 1859- 1932 73 (12599- 13185), 8 Charles Dickens 1812- 1870 58 (3399- 10312), 14 George Eliot, Real name Mary Ann Evans, author of Middlemarch 1819- 1880 71 (13671- 16366), 45 Thomas Hardy 1840- 1928 88 (48024- 50335)
#Number of words extracted from each of the seven authors' texts: 50 texts of 4000 words each (32 for training and 8 for testing). 

#set working directory and load package tm
setwd(dirname(file.choose()))
getwd()
library(tm)

#input data and form seven dataframes
if(!file.exists('Gungor_2018_VictorianAuthorAttribution_data-train.csv')){
	download.file('http://archive.ics.uci.edu/ml/machine-learning-databases/00454/dataset.zip', 'dataset.zip')
	unzip('dataset.zip')
	file.copy('./dataset/Gungor_2018_VictorianAuthorAttribution_data-train.csv', '.')
#if the working directory does not have the csv file, this if statement
#needs several minutes to run
}
dfVictorianEraAA <- read.table('Gungor_2018_VictorianAuthorAttribution_data-train.csv', header = TRUE, sep = (','))
dfCharles_Dickens3398_3597 <- dfVictorianEraAA[3398:3597,]
dfFergue_Hume12558_12757 <- dfVictorianEraAA[12558:12757,]
dfGeorge_Eliot13670_13869 <- dfVictorianEraAA[13670:13869,]
dfHelen_Mathers18009_18208 <- dfVictorianEraAA[18009:18208,]
dfLucas_Malet33860_34059 <- dfVictorianEraAA[33860:34059,]
dfMarie_Corelli34563_34762 <- dfVictorianEraAA[34563:34762,]
dfThomas_Hardy48023_48222 <- dfVictorianEraAA[48023:48222,]

#form corpa with dataframes. Texts already cleaned
#package tm is required here
dfCharles_Dickens3398_3597_corpus <- VCorpus(VectorSource(dfCharles_Dickens3398_3597$text))
dfCharles_Dickens3398_3597_corpus <- tm_map(dfCharles_Dickens3398_3597_corpus, stripWhitespace)
dfFergue_Hume12558_12757_corpus <- VCorpus(VectorSource(dfFergue_Hume12558_12757$text))
dfFergue_Hume12558_12757_corpus <- tm_map(dfFergue_Hume12558_12757_corpus, stripWhitespace)
dfGeorge_Eliot13670_13869_corpus <- VCorpus(VectorSource(dfGeorge_Eliot13670_13869$text))
dfGeorge_Eliot13670_13869_corpus <- tm_map(dfGeorge_Eliot13670_13869_corpus, stripWhitespace)
dfHelen_Mathers18009_18208_corpus <- VCorpus(VectorSource(dfHelen_Mathers18009_18208$text))
dfHelen_Mathers18009_18208_corpus <- tm_map(dfHelen_Mathers18009_18208_corpus, stripWhitespace)
dfLucas_Malet33860_34059_corpus <- VCorpus(VectorSource(dfLucas_Malet33860_34059$text))
dfLucas_Malet33860_34059_corpus <- tm_map(dfLucas_Malet33860_34059_corpus, stripWhitespace)
dfMarie_Corelli34563_34762_corpus <- VCorpus(VectorSource(dfMarie_Corelli34563_34762$text))
dfMarie_Corelli34563_34762_corpus <- tm_map(dfMarie_Corelli34563_34762_corpus, stripWhitespace)
dfThomas_Hardy48023_48222_corpus <- VCorpus(VectorSource(dfThomas_Hardy48023_48222$text))
dfThomas_Hardy48023_48222_corpus <- tm_map(dfThomas_Hardy48023_48222_corpus, stripWhitespace)

#form dtm. Each line(1000 words) a document
#change minimum word length to 1 from 3
dfCharles_Dickens3398_3597_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfCharles_Dickens3398_3597_corpus, control=list(wordLengths = c(1, Inf)))))
dfFergue_Hume12558_12757_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfFergue_Hume12558_12757_corpus, control=list(wordLengths = c(1, Inf)))))
dfGeorge_Eliot13670_13869_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfGeorge_Eliot13670_13869_corpus, control=list(wordLengths = c(1, Inf)))))
dfHelen_Mathers18009_18208_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfHelen_Mathers18009_18208_corpus, control=list(wordLengths = c(1, Inf)))))
dfLucas_Malet33860_34059_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfLucas_Malet33860_34059_corpus, control=list(wordLengths = c(1, Inf)))))
dfMarie_Corelli34563_34762_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfMarie_Corelli34563_34762_corpus, control=list(wordLengths = c(1, Inf)))))
dfThomas_Hardy48023_48222_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfThomas_Hardy48023_48222_corpus, control=list(wordLengths = c(1, Inf)))))

#retain columns of words which can found in every of the seven authors' texts
common_cols <- Reduce(intersect, list(colnames(dfCharles_Dickens3398_3597_dtDf), colnames(dfFergue_Hume12558_12757_dtDf), colnames(dfGeorge_Eliot13670_13869_dtDf), colnames(dfHelen_Mathers18009_18208_dtDf), colnames(dfLucas_Malet33860_34059_dtDf), colnames(dfMarie_Corelli34563_34762_dtDf), colnames(dfThomas_Hardy48023_48222_dtDf)))
BindAll7NoOfWdsInAll7UniqWdLst <- rbind(dfCharles_Dickens3398_3597_dtDf[common_cols], dfFergue_Hume12558_12757_dtDf[common_cols], dfGeorge_Eliot13670_13869_dtDf[common_cols], dfHelen_Mathers18009_18208_dtDf[common_cols], dfLucas_Malet33860_34059_dtDf[common_cols], dfMarie_Corelli34563_34762_dtDf[common_cols],
dfThomas_Hardy48023_48222_dtDf[common_cols])

#further retain columns of words each of which appearing in the texts at least
#700 times(50 x 4000 x 7 x 0.05% = 700)
SevenAuthsTtl700OrMore <- BindAll7NoOfWdsInAll7UniqWdLst[, colSums(BindAll7NoOfWdsInAll7UniqWdLst) >=700] #230

#after inspection of the dataframe,
#remove columns â, o (but not t(can't), m(i'm), etc.)
#be careful! â is not an ascii character
SevenAuthsTtl700OrMore[,c('â', 'o')] <- list(NULL) #228

#add textNo column
#aggreate and sum every four lines (reduce to 350 lines from 1400 lines)
#delete column textNO
SevenAuthsTtl700OrMore$textNo <- rep(1:350, each = 4)
dfAll7WdFeqDf <- aggregate(. ~ textNo, SevenAuthsTtl700OrMore, sum)
dfAll7WdFeqDf$textNo <- NULL

#add labels and move the label column to the first column
dfAll7WdFeqDf$Label = c(rep('CD', 50), rep('FH', 50), rep('GE', 50), rep('HM', 50), rep('LM', 50), rep('MC', 50), rep('TH', 50)) # ?228+1 = 229
dfAll7WdFeqDfLabled = dfAll7WdFeqDf[,c(229,1:228)]

# shuffling rows:
set.seed(12345)
rrowNos <- sample(nrow(dfAll7WdFeqDfLabled))
dfAll7WdFeqDfLabledRandm <- dfAll7WdFeqDfLabled[rrowNos,]
#normalisation:
data_norm <- function(x) {(x- min(x))/ (max(x)- min(x))}
dfAll7WdFeqDfLabledRandm_norm <- as.data.frame(lapply(dfAll7WdFeqDfLabledRandm[,-1], data_norm))
summary(dfAll7WdFeqDfLabledRandm_norm[,1:4]) #see whether normalised

#KNN!
#number of k: usually start from sqrt of data points of
#the training set. So sqrt(280): 18
#then trial and error
library(class)
dfAll7WdFeqDfLabledRandm_norm_train <- dfAll7WdFeqDfLabledRandm_norm[1:280,]
dfAll7WdFeqDfLabledRandm_norm_test <- dfAll7WdFeqDfLabledRandm_norm[281:350,]
whichOfThe7_pred <- knn(dfAll7WdFeqDfLabledRandm_norm_train, dfAll7WdFeqDfLabledRandm_norm_test, dfAll7WdFeqDfLabledRandm[1:280,1], k= 18)
table(pred = whichOfThe7_pred, true_7Authors_KNN = dfAll7WdFeqDfLabledRandm[281:350,1])#mistake rate 1/70

#SVM!
library("e1071")
# simple: no tunning
whichOfThe7_svm_model <- svm(dfAll7WdFeqDfLabledRandm_norm_train, dfAll7WdFeqDfLabledRandm[1:280,1], type = 'C')
pred <- predict(whichOfThe7_svm_model, dfAll7WdFeqDfLabledRandm_norm_test)
table(pred, true_7Authors_SVM = dfAll7WdFeqDfLabledRandm[281:350,1]) #all correct

#use tunning to find costs
dfAll7WdFeqDfLabledRandmLabel1To280AsFactors = as.factor(dfAll7WdFeqDfLabledRandm[1:280,1])
set.seed(12345)
svm_tune <- tune(svm, train.x = dfAll7WdFeqDfLabledRandm_norm_train,
						train.y = dfAll7WdFeqDfLabledRandmLabel1To280AsFactors,
						kernel = 'linear',
						#type = 'C',
						ranges = list(cost = c(.001,.01,.1,1,5,10,100)))
print(svm_tune) 
svm_tune$best.model
#besides best cost, also best number of support vectors, etc.
pred_svm_after_tune <- predict(svm_tune$best.model, dfAll7WdFeqDfLabledRandm_norm_test)
table(pred = pred_svm_after_tune, true_7Authors_tunedSVM = dfAll7WdFeqDfLabledRandm[281:350,1]) #all correct

#---------------------------------------------------------------
#Check whether the knn and svm models developed above (using the first 200 lines of each of the seven authors) can recognise the 20 documents (each x 4000 words) complied with George Eliot's lines extracted from end of her lines were written by her.
#need to use package tm
dfGeorge_Eliot16286_16365End <- dfVictorianEraAA[16286:16365,]
dfGeorge_Eliot16286_16365End_corpus <- VCorpus(VectorSource(dfGeorge_Eliot16286_16365End$text))
dfGeorge_Eliot16286_16365End_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfGeorge_Eliot16286_16365End_corpus, control=list(wordLengths = c(1, Inf)))))
dfGeorge_Eliot16286_16365End_dtDf$textNo <- rep(1:20, each = 4)

dfGeEndWdFeqAll4000WrdsDf <- aggregate(. ~ textNo, dfGeorge_Eliot16286_16365End_dtDf, sum)
dfGeEndWdFeqAll4000WrdsDf$textNo <- NULL
dfGeEndWdFeqAll4000WrdsDf[setdiff(colnames(dfAll7WdFeqDfLabled), colnames(dfGeEndWdFeqAll4000WrdsDf))] <- 0
dfGeEndWdFeqDf <- dfGeEndWdFeqAll4000WrdsDf[colnames(dfAll7WdFeqDfLabled)]
dfGeEndWdFeqDf$Label <- NULL #delete Label col

#'normalisation': use max and min values of the data for building the models
dfGeEndWdFeqDf_addMaxMin = rbind(dfGeEndWdFeqDf, apply(dfAll7WdFeqDfLabledRandm[,-1], 2, max), apply(dfAll7WdFeqDfLabledRandm[,-1], 2, min))
normGeEtc = function(x, y) {
for (i in 2: (nrow(y)-2)) {
x = rbind(x, (y[i,] - y[nrow(y),]) / (y[(nrow(y)-1),] - y[nrow(y),]))
}
return(x)
}
#'normalise' the first row
dfGeEndWdFeqDf_normNotReal = (dfGeEndWdFeqDf_addMaxMin[1,] - dfGeEndWdFeqDf_addMaxMin[22,]) / (dfGeEndWdFeqDf_addMaxMin[21,] - dfGeEndWdFeqDf_addMaxMin[22,])
#'normalise' the rest 
dfGeEndWdFeqDf_normNotReal = normGeEtc(dfGeEndWdFeqDf_normNotReal, dfGeEndWdFeqDf_addMaxMin)

#KNN! 
set.seed(12345)
all20GeEnd_knn_pred <- knn(dfAll7WdFeqDfLabledRandm_norm_train, dfGeEndWdFeqDf_normNotReal, dfAll7WdFeqDfLabledRandm[1:280,1], k= 18)
table(pred = all20GeEnd_knn_pred, true_GeorgeEliotEnd_KNN = rep('GE', 20)) #mistake rate 4/20

#svm_no_tune
pred_svm_GeEnd <- predict(whichOfThe7_svm_model, dfGeEndWdFeqDf_normNotReal)
table(pred = pred_svm_GeEnd, true_GeorgeEliotEnd_SVM = rep('GE', 20)) #mistake rate 1/20
#svm_tuned
pred_svm_after_tune_GeEnd <- predict(svm_tune$best.model, dfGeEndWdFeqDf_normNotReal)
table(pred = pred_svm_after_tune_GeEnd, true_GeorgeEliotEnd_tunedSVM = rep('GE', 20)) #mistake rate 2/20

#---------------------------------------------------------------
#Check whether the knn and svm models developed above (using the first 200 lines of each of the seven authors) can recognise that the 20 documents (each x 4000 words) complied with George Eliot's lines extracted from immediately below the first 200 lines were written by her. 
#need to use package tm
#(no comment lines below. For explanations, see the above part)

dfGeorge_Eliot13870_13949ImmBlw <- dfVictorianEraAA[13870:13949,]
dfGeorge_Eliot13870_13949ImmBlw_corpus <- VCorpus(VectorSource(dfGeorge_Eliot13870_13949ImmBlw$text))
dfGeorge_Eliot13870_13949ImmBlw_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfGeorge_Eliot13870_13949ImmBlw_corpus, control=list(wordLengths = c(1, Inf)))))
dfGeorge_Eliot13870_13949ImmBlw_dtDf$textNo <- rep(1:20, each = 4)

dfGeImmBlwWdFeqAll4000WrdsDf <- aggregate(. ~ textNo, dfGeorge_Eliot13870_13949ImmBlw_dtDf, sum)
dfGeImmBlwWdFeqAll4000WrdsDf$textNo <- NULL
dfGeImmBlwWdFeqAll4000WrdsDf[setdiff(colnames(dfAll7WdFeqDfLabled), colnames(dfGeImmBlwWdFeqAll4000WrdsDf))] <- 0
dfGeImmBlwWdFeqDf <- dfGeImmBlwWdFeqAll4000WrdsDf[colnames(dfAll7WdFeqDfLabled)]
dfGeImmBlwWdFeqDf$Label <- NULL #delete Label col

dfGeImmBlwWdFeqDf_addMaxMin = rbind(dfGeImmBlwWdFeqDf, apply(dfAll7WdFeqDfLabledRandm[,-1], 2, max), apply(dfAll7WdFeqDfLabledRandm[,-1], 2, min))
normGeEtc = function(x, y) {
for (i in 2: (nrow(y)-2)) {
x = rbind(x, (y[i,] - y[nrow(y),]) / (y[(nrow(y)-1),] - y[nrow(y),]))
}
return(x)
}
dfGeImmBlwWdFeqDf_normNotReal = (dfGeImmBlwWdFeqDf_addMaxMin[1,] - dfGeImmBlwWdFeqDf_addMaxMin[22,]) / (dfGeImmBlwWdFeqDf_addMaxMin[21,] - dfGeImmBlwWdFeqDf_addMaxMin[22,])
dfGeImmBlwWdFeqDf_normNotReal = normGeEtc(dfGeImmBlwWdFeqDf_normNotReal, dfGeImmBlwWdFeqDf_addMaxMin)

all20GeImmBlw_knn_pred <- knn(dfAll7WdFeqDfLabledRandm_norm_train, dfGeImmBlwWdFeqDf_normNotReal, dfAll7WdFeqDfLabledRandm[1:280,1], k= 18)
table(pred = all20GeImmBlw_knn_pred, true_GeorgeEliotImmBlw_KNN = rep('GE', 20)) #mistake rate 1/20  

#svm_no_tune
pred_svm_GeImmBlw <- predict(whichOfThe7_svm_model, dfGeImmBlwWdFeqDf_normNotReal)
table(pred = pred_svm_GeImmBlw, true_GeorgeEliotImmBlw_SVM = rep('GE', 20)) #all correct

#svm_tuned
pred_svm_after_tune_GeImmBlw <- predict(svm_tune$best.model, dfGeImmBlwWdFeqDf_normNotReal)
table(pred = pred_svm_after_tune_GeImmBlw, true_GeorgeEliotImmBlw_tunedSVM = rep('GE', 20)) #mistake rate: 1/20

#---------------------------------------------------------------
#The data file contains Charles Dickens's masterpiece A Tale of Two Cities, George Eliot's Middlemarch (300000+ words),  and Thomas Hardy's Tess of the d'Urbervilles. However, they have not been used in the above experiments. Therefore, copies of these three novels were obtained from the famous Gutenberg book corpus and from which 3 portions of words were extracted from A Tale of Two Cities, 5 from Middlemarch and 3 from Tess of the d'Urbervilles for doing the below experiment (Each portion contains 4000 words, all words are in lowercase and all punctuation were deleted)
#data file names: GutenbergATaleOf2C_3PortionsEach4000Words.csv, GutenbergMiddlemarch_5PortionsEach4000Words.csv and GutenbergTessOfTheDUrb_3PortionsEach4000Words.csv
#The KNN and SVM models produced above can recognise who wrote the 11 portions of words with 100% accuracy. 

#dfGutenbergATaleOf2C <- read.table('GutenbergATaleOf2C_3PortionsEach4000Words.csv', header = TRUE, sep = (','))
#dfGutenbergMiddlemarch <- read.table('GutenbergMiddlemarch_5PortionsEach4000Words.csv', header = TRUE, sep = (','))
#dfGutenbergTessOfTheDUrb <- read.table('GutenbergTessOfTheDUrb_3PortionsEach4000Words.csv', header = TRUE, sep = (','))
dfGutenberg2CitiesMddlemarchTess <- read.table('GutenbergATaleOf2C3Middlemarch5TessOfTheDUrb3Each4000Words.csv', header = TRUE, sep = (','), comment.char = "#")
dfGutenberg2CitiesMddlemarchTess <- rbind(dfGutenbergATaleOf2C, dfGutenbergMiddlemarch, dfGutenbergTessOfTheDUrb)
dfGutenberg2CitiesMddlemarchTess_corpus <- VCorpus(VectorSource(dfGutenberg2CitiesMddlemarchTess$text))
dfGutenberg2CitiesMddlemarchTess_dtDf <- as.data.frame(as.matrix(DocumentTermMatrix(dfGutenberg2CitiesMddlemarchTess_corpus, control=list(wordLengths = c(1, Inf)))))
#dfGutenberg2CitiesMddlemarchTess_dtDf$textNo <- NULL
dfGutenberg2CitiesMddlemarchTess_dtDf[setdiff(colnames(dfAll7WdFeqDfLabled), colnames(dfGutenberg2CitiesMddlemarchTess_dtDf))] <- 0
dfGutenberg2CitiesMddlemarchTessWdFeqDf <- dfGutenberg2CitiesMddlemarchTess_dtDf[colnames(dfAll7WdFeqDfLabled)]
dfGutenberg2CitiesMddlemarchTessWdFeqDf$Label <- NULL #delete Label col
dfGutenberg2CitiesMddlemarchTessWdFeqDf_addMaxMin = rbind(dfGutenberg2CitiesMddlemarchTessWdFeqDf, apply(dfAll7WdFeqDfLabledRandm[,-1], 2, max), apply(dfAll7WdFeqDfLabledRandm[,-1], 2, min))
dfGutenberg2CitiesMddlemarchTessWdFeqDf_normNotReal = (dfGutenberg2CitiesMddlemarchTessWdFeqDf_addMaxMin[1,] - dfGutenberg2CitiesMddlemarchTessWdFeqDf_addMaxMin[13,]) / (dfGutenberg2CitiesMddlemarchTessWdFeqDf_addMaxMin[12,] - dfGutenberg2CitiesMddlemarchTessWdFeqDf_addMaxMin[13,])
dfGutenberg2CitiesMddlemarchTessWdFeqDf_normNotReal <- normGeEtc(dfGutenberg2CitiesMddlemarchTessWdFeqDf_normNotReal, dfGutenberg2CitiesMddlemarchTessWdFeqDf_addMaxMin)

#KNN! 
set.seed(12345)
pred_knn_3TwoCities5Mddlemarch3Tess <- knn(dfAll7WdFeqDfLabledRandm_norm_train, dfGutenberg2CitiesMddlemarchTessWdFeqDf_normNotReal, dfAll7WdFeqDfLabledRandm[1:280,1], k= 18)
table(pred = pred_knn_3TwoCities5Mddlemarch3Tess, true_3TwoCities5Mddlemarch3Tess_KNN = dfGutenberg2CitiesMddlemarchTess$label) #all correct

#svm_no_tune
pred_svm_3TwoCities5Mddlemarch3Tess <- predict(whichOfThe7_svm_model, dfGutenberg2CitiesMddlemarchTessWdFeqDf_normNotReal)
table(pred = pred_svm_3TwoCities5Mddlemarch3Tess, true_3TwoCities5Mddlemarch3Tess_SVM = dfGutenberg2CitiesMddlemarchTess$label) #all correct
#svm_tuned
pred_svm_after_tune_3TwoCities5Mddlemarch3Tess <- predict(svm_tune$best.model, dfGutenberg2CitiesMddlemarchTessWdFeqDf_normNotReal)
table(pred = pred_svm_after_tune_3TwoCities5Mddlemarch3Tess, true_3TwoCities5Mddlemarch3Tess_tunedSVM = dfGutenberg2CitiesMddlemarchTess$label) #all correct