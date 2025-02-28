### setup ###

# clear workspace
rm(list=ls())

# load packages 
packages<-c("data.table", "tidytext", "SnowballC", "cld3", "pscl") # list packages required
install.packages(packages[!packages %in% rownames(installed.packages())]) # install packages if required
invisible(lapply(packages, library, character.only=TRUE)) # load packages

# turn off scientific notation
options(scipen=999)

### Web of Science data ###

# load data from WoS searches 
tool_data<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/WoS_data/all_tool_results.csv") # tool use articles, all species
nest_data<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/WoS_data/all_nest_results.csv") # nest building articles, all species
ape_tool_data<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/WoS_data/ape_tool_results.csv") # tool use articles, great apes only
ape_nest_data<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/WoS_data/ape_nest_results.csv") # nest building articles, great apes only
corvus_tool_data<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/WoS_data/corvus_tool_results.csv") # tool use articles, Corvus species only
corvus_nest_data<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/WoS_data/corvus_nest_results.csv") # nest building articles, Corvus species only

sapply(list(tool_data, nest_data, ape_tool_data, ape_nest_data, corvus_tool_data, corvus_nest_data), nrow) # check number of rows in each file

# add labels for behaviour to prepare for combining tool and nest datasets
tool_data$Behaviour<-"Tool"
nest_data$Behaviour<-"Nest"

# check if any articles are included both tool and nest subsets
sum(tool_data$Article.Title %in% nest_data$Article.Title) # tool use articles in nest data: 28 
sum(nest_data$Article.Title %in% tool_data$Article.Title) # nest building articles in tool data: 28

# check and remove duplicated articles as appropriate 
tool_nest_dupes<-subset(tool_data, tool_data$Article.Title %in% nest_data$Article.Title)$Article.Title # list articles in both datasets for further manual investigation
nest_dupes<-tool_nest_dupes[c(1, 3, 5, 6, 10, 13)] # articles primarily relevant to tool use, to remove from the nest database
tool_dupes<-tool_nest_dupes[c(7, 11, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 26, 27)] # articles primarily relevant to nest building, to remove from the tool database (all remaining duplicates are deliberately included as they are relevant to both nest building and tool use)
nest_data<-subset(nest_data, !(Article.Title %in% nest_dupes)) # remove tool articles from nest data
nrow(nest_data) # 6126 articles remaining
tool_data<-subset(tool_data, !(Article.Title %in% tool_dupes)) # remove nest articles from tool data
nrow(tool_data) # 1688 articles remaining

# combine nest and tool data into a single object
nest_data$Include<-NA # add extra column so rbind can be used to combine files - this column is present only in the tool use dataset because manual checking for irrelevant articles was not necessary for nest searches
tool_data<-tool_data[,c("Include", "Publication.Type", "Article.Title", "Publication.Year", "Abstract", "Source.Title", "Times.Cited..All.Databases", "Behaviour")] # select columns of interest
nest_data<-nest_data[,c("Include", "Publication.Type", "Article.Title", "Publication.Year", "Abstract", "Source.Title", "Times.Cited..All.Databases", "Behaviour")]
all(colnames(tool_data)==colnames(nest_data)) # double check all columns match before using rbind
combined_data<-rbind(tool_data, nest_data) # combine the nest and tool datasets
nrow(combined_data) # 7814 articles total
table(combined_data$Behaviour) # 6126 nest articles, 1688 tool articles

# check for and remove any articles duplicated within each behaviour type
sum(duplicated(paste(combined_data$Article.Title, combined_data$Behaviour, sep=" "))) # 24 duplicates within each behaviour type
combined_data$Duplicated<-ifelse(duplicated(paste(combined_data$Article.Title, combined_data$Behaviour, sep=" ")), 1, 0) # create new column indicating which articles are duplicated
combined_data<-subset(combined_data, Duplicated==0) # remove the duplicates
nrow(combined_data) # 7790 articles remaining
sum(duplicated(combined_data$Article.Title)) # 8 duplicates remain (i.e. articles relevant to both tool use and nest building)
table(combined_data$Behaviour) # 6108 nest building articles, 1682 tool use articles

# remove excluded articles from the great ape/Corvus subsets before adding columns for taxa
ape_tool_data<-subset(ape_tool_data, Include==1) 
ape_nest_data<-subset(ape_nest_data, Include==1)
corvus_nest_data<-subset(corvus_nest_data, Include==1)
corvus_tool_data<-subset(corvus_tool_data, Include==1)

# add column for great ape
combined_data$Ape<-ifelse(combined_data$Article.Title %in% ape_tool_data$Article.Title | combined_data$Article.Title %in% ape_nest_data$Article.Title, "Y", "N") # Y=great ape, N=not great ape

# add column for Corvus
combined_data$Corvus<-ifelse(combined_data$Article.Title %in% corvus_tool_data$Article.Title | combined_data$Article.Title %in% corvus_nest_data$Article.Title, "Y", "N") # Y=Corvus, N=not Corvus

table(subset(combined_data, Ape=="Y")$Behaviour) # 74 nest articles, 566 tool articles for apes
table(subset(combined_data, Corvus=="Y")$Behaviour) # 75 nest articles, 104 tool articles for Corvus

# check for and remove excluded articles in the main datasets
sum(combined_data$Include==0, na.rm=T) # 140 articles to remove due to irrelevance 
combined_data<-subset(combined_data, Include==1 | is.na(Include)) # remove irrelevant articles 
nrow(combined_data) # 7650 articles remaining
table(combined_data$Behaviour) # 6108 nest building articles, 1542 tool use articles
table(subset(combined_data, Ape=="Y")$Behaviour) # 74 nest building articles, 566 tool use articles for apes
table(subset(combined_data, Corvus=="Y")$Behaviour) # 75 nest building articles, 104 tool use articles for Corvus

### Journal Citation Reports data ###

# identify which journals are included in the combined data
journals<-unique(subset(combined_data, Publication.Type=="J")$Source.Title) # unique source titles included in the combined data, selecting only articles with type J i.e. journal
length(journals) # 1823 unique journal names included in the searches
journals<-as.data.frame(journals) # convert the journal list to a data frame
colnames(journals)<-"Name" # change column name

# import impact factors and subject category data from searches of Clarivate's  Journal Citation Reports (note: multiple searches had to be run for different categories of journal, because you can only export 600 results at a time)
JCR_anthro<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_anthro.csv") # anthropology journals
JCR_arch<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_arch.csv") # archaeology journals
JCR_beh_sci<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_beh_sci.csv") # behavioural science journals
JCR_biodiv<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_biodiv.csv") # biodiversity journals
JCR_biology<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_biology.csv") # biology journals
JCR_ecology<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_ecology.csv") # ecology journals
JCR_ento<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_ento.csv") # entomology journals
JCR_env_sci<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_env_sci.csv") # environmental sciences journals
JCR_evo_devo<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_evo_devo.csv") # evolutionary and developmental biology journals
JCR_fish<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_fish.csv") # fisheries journals
JCR_multi<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_multi.csv") # multidisciplinary journals
JCR_orni<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_orni.csv") # ornithology journals
JCR_palaeo<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_palaeo.csv") # palaeontology journals
JCR_psych<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_psych.csv") # psychology journals
JCR_top600<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_top600.csv") # top 600 journals by IF
JCR_toxi<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_toxi.csv") # toxicology journals
JCR_vet<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_vet.csv") # veterinary sciences journals
JCR_zoology<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/JCR_zoology.csv") # zoology journals

JCR_journals<-rbindlist(list(JCR_anthro, JCR_arch, JCR_beh_sci, JCR_biology, JCR_biodiv, JCR_ecology, JCR_ento, JCR_env_sci, JCR_evo_devo, JCR_fish, JCR_multi, JCR_orni, JCR_palaeo, JCR_psych, JCR_top600, JCR_toxi, JCR_vet,  JCR_zoology)) # combine JCR search results into a single dataframe

length(JCR_journals$Journal.name) # 3968 JCR search results
length(unique(JCR_journals$Journal.name)) # 3004 unique journal names - some are duplicates due to journals belonging to multiple categories and appearing in multiple searches

journals_info<-merge(journals, JCR_journals[,c("Category", "X2023.JIF", "Journal.name")], by.x="Name", by.y="Journal.name", all.x=TRUE) # merge info from JCR searches with list of journals in the nest and tool data

sum(!is.na(journals_info$X2023.JIF)) # only 108 journals could be automatically matched

# merge journal info with data after manual data collection and subject categorisation
journals_manual<-read.csv("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/JCR_data/journals_manual.csv") # journal information with manually added categories 
str(journals_manual) # all 1823 journals now checked
sum(!is.na(journals_manual$X2023.JIF)) # info available for 595 journals 
length(unique(journals_manual$Name)) # no duplicates remaining

# add journal information to the combined data
combined_data<-merge(combined_data, journals_manual, by.x="Source.Title", by.y="Name", all.x=TRUE) 
nrow(combined_data) # 7650 articles
sum(combined_data$Publication.Type=="J") # of which 7360 are journal articles
sum(!is.na(combined_data$X2023.JIF)) # JCR info available for 4277 articles
table(subset(combined_data, !is.na(X2023.JIF))$Behaviour) # JCR info available for 2948 nest building articles and 1329 tool use articles
table(subset(combined_data, !is.na(X2023.JIF) & Ape=="Y")$Behaviour) # JCR info available for 50 nest building articles and 475 tool use articles for apes
table(subset(combined_data, !is.na(X2023.JIF) & Corvus=="Y")$Behaviour) # JCR info available for 15 nest building articles and 97 tool use articles for Corvus

### abstract language measures ###

# create subsets of data including only articles with abstracts
combined_data_abstracts<-subset(combined_data, Abstract!="") 
nrow(combined_data_abstracts) # 4111 articles with abstracts available
table(combined_data_abstracts$Behaviour) # 2915 nest building and 1196 tool use articles with abstracts
table(subset(combined_data_abstracts, Ape=="Y")$Behaviour) # 48 nest building and 430 tool use articles with abstracts for apes
table(subset(combined_data_abstracts, Corvus=="Y")$Behaviour) # 28 nest building and 87 tool use articles with abstracts for Corvus

# check for non-English language abstracts
combined_data_abstracts$English<-ifelse(detect_language(combined_data_abstracts$Abstract)=="en", 1, 0)
table(combined_data_abstracts$English, useNA="ifany") # 1 not English, 3 NA, rest English
subset(combined_data_abstracts, English==0)$Abstract # 1 abstract in Spanish and English
subset(combined_data_abstracts, is.na(English))$Abstract # NA abstracts are all actually in English, likely misclassified due to use of Latin names/non-English place names
combined_data_abstracts<-subset(combined_data_abstracts, English==1 | is.na(English)) 
str(combined_data_abstracts) # 4110 articles remaining

# add % 'intelligent' words in each article's abstract
dictionary<-read.table("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/Dictionaries/custom_dictionary.txt", header=T, sep="\t") # load dictionary (includes the list of 'intelligent' words for matching)

# convert dictionary words to stems
dictionary_stems <- wordStem(dictionary$word,  language = "english")
length(unique(dictionary_stems)) # check for duplicates

# calculate percentage of 'intelligent' words in each article abstract (i.e. N matches per abstract as a % of total words in each abstract)
combined_data_abstracts$Intel_percent<-NA # create a blank column for results
for (i in 1:length(combined_data_abstracts$Intel_percent)){ # for each article
	tokens<-unnest_tokens(tbl=combined_data_abstracts[i,], output=word, input=Abstract, token="words", to_lower=TRUE)$word # tokenize abstracts by word (i.e. split into individual words)
	stems<-wordStem(tokens,  language = "english") # convert words to stems
	combined_data_abstracts$Intel_percent[i]<-length(which(stems %in% dictionary_stems))/length(stems)*100
	}
	
# repeat using alternative dictionary (just intelligent + 20 synonyms in Collins thesaurus)
alt_dictionary<-read.table("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/Dictionaries/alt_dictionary.txt", header=F, sep="\t") # load alternative dictionary
length(alt_dictionary$V1) # 21 words

alt_dictionary_stems <- wordStem(alt_dictionary$V1,  language = "english") # convert dictionary words to stems
length(unique(alt_dictionary_stems)) # no duplicates

# calculate percentage of matching 'intelligent' words in each article abstract (i.e. N matches per abstract as a % of total words in each abstract)
combined_data_abstracts$Alt_percent<-NA # blank column for results
for (i in 1:length(combined_data_abstracts$Alt_percent)){
	tokens<-unnest_tokens(tbl= combined_data_abstracts[i,], output=word, input=Abstract, token="words", to_lower=TRUE)$word
	stems<-wordStem(tokens,  language = "english")
	combined_data_abstracts$Alt_percent[i]<-length(which(stems %in% alt_dictionary_stems))/length(stems)*100
	}

# create user friendly version of dataset for sharing
sharing_data<-merge(combined_data[,c("Article.Title", "Abstract", "Times.Cited..All.Databases", "Behaviour", "Ape", "Corvus", "X2023.JIF", "Group")], combined_data_abstracts[,c("Article.Title", "Intel_percent", "Alt_percent")], by="Article.Title", all.x=TRUE)
str(sharing_data) # 7660 - 10 rows added during merging
nrow(subset(sharing_data, duplicated(sharing_data$Article.Title))) # 18 duplicates - we should expect 8 remaining (i.e. the legitimate duplicates included in both the nest and tool datasets)
rm_sharing_data<-subset(sharing_data, duplicated(paste(sharing_data$Article.Title, sharing_data$Behaviour))) # select articles to remove
sharing_data<-sharing_data[-as.numeric(rownames(rm_sharing_data)),] # remove the illegitimate duplicates
str(sharing_data) # 7650 rows
sharing_data[sharing_data$Abstract=="",]$Abstract<-NA # replace blanks with NAs for abstracts
colnames(sharing_data)<-c("Article.Title", "Abstract", "Citations", "Behaviour", "Great.Ape", "Corvus", "JIF", 
"Subject", "Intel.percent", "Alt.percent") # rename columns
write.csv(sharing_data, "tool_nest_language_data_sharing.csv", row.names=F) # write to file
