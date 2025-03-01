### setup ###

# clear workspace & load data
rm(list=ls())

# load packages 
packages<-c("data.table", "tidytext", "SnowballC", "cld3", "pscl") # list packages
install.packages(packages[!packages %in% rownames(installed.packages())]) # install packages if required
invisible(lapply(packages, library, character.only=TRUE)) # load packages

# turn off scientific notation
options(scipen=999)

# load data
processed_data<-read.csv("https://github.com/sally-e-street/tool-nest-language/raw/refs/heads/main/tool_nest_language_data_sharing.csv")

# descriptive statistics
nrow(processed_data) # 7650 articles
summary(processed_data$Citations) # median = 4 citations
table(processed_data$Behaviour) # 6108 nest building articles, 1542 tool use articles
table(processed_data$Great.Ape) # 640 great ape articles
table(processed_data$Corvus) # 179 Corvus articles
summary(processed_data$JIF) # median IF = 1.8
table(processed_data$Subject) # journal subject categories
summary(processed_data$Publication.Year) # median = 1999
summary(processed_data$Intel.percent) # median = 0.4%
summary(processed_data$Alt.percent) # median = 0.0%

### exploratory plots ###

# citations & impact factors
par(mfrow=c(1,2))
hist(processed_data$Citations, main="", breaks=50, xlab="Citations", las=1) # right-skewed
hist(processed_data$JIF, main="", breaks=50, xlab="Impact factor", las=1) # right-skewed

par(mfrow=c(1,2))
hist(log10(processed_data$Citations+1), main="", breaks=50, xlab="Citations", las=1) # still skewed after log10 transformation
hist(log10(processed_data$JIF+1), main="", breaks=50, xlab="Impact factor", las=1) # some skew after log10 transformation

# % 'intelligent' terms
par(mfrow=c(1,2))
hist(processed_data$Intel.percent, main="", breaks=30, xlab="% 'intelligent' terms", las=1) # right-skewed
hist(processed_data$Alt.percent, main="", breaks=30, xlab="% alt 'intelligent' terms", las=1) # right-skewed/bimodal

par(mfrow=c(1,2))
hist(log10(processed_data$Intel.percent+1), main="", breaks=30, xlab="% 'intelligent' terms", las=1) # still right-skewed after log transformation
hist(log10(processed_data$Alt.percent+1), main="", breaks=30, xlab="% alt 'intelligent' terms", las=1) # still right-skewed/bimodal after log transformation

par(mfrow=c(1,1))
plot(processed_data[,c("Citations", "JIF", "Intel.percent", "Alt.percent")])

par(mfrow=c(1,1))
plot(log10(processed_data[,c("Citations", "JIF", "Intel.percent", "Alt.percent")]+1))


### citation rates ###

# descriptive statistics 
aggregate(Citations~Behaviour, processed_data, FUN=length) 
aggregate(Citations~Behaviour, processed_data, FUN=quantile)

# wilcox test: citations in nest building versus tool use papers
wilcox.test(Citations~Behaviour, processed_data)

# repeat for great apes
aggregate(Citations~Behaviour, subset(processed_data, Great.Ape=="Y"), FUN=length) 
aggregate(Citations~Behaviour, subset(processed_data, Great.Ape=="Y"), FUN=quantile)
wilcox.test(Citations~Behaviour, subset(processed_data, Great.Ape=="Y"))

# repeat for Corvus
aggregate(Citations~Behaviour, subset(processed_data, Corvus=="Y"), FUN=length)
aggregate(Citations~Behaviour, subset(processed_data, Corvus=="Y"), FUN=quantile)
wilcox.test(Citations~Behaviour, subset(processed_data, Corvus=="Y"))

# compare tool use in great apes vs. Corvus
wilcox.test(subset(processed_data, Great.Ape=="Y" & Behaviour=="Tool")$Citations, subset(processed_data, Corvus=="Y" & Behaviour=="Tool")$Citations)

# compare nest building in agreat pes vs. Corvus
wilcox.test(subset(processed_data, Great.Ape=="Y" & Behaviour=="Nest")$Citations, subset(processed_data, Corvus=="Y" & Behaviour=="Nest")$Citations)

# repeat for general interest journals only
aggregate(Citations~Behaviour, subset(processed_data, Subject=="General"), FUN=length) 
aggregate(Citations~Behaviour, subset(processed_data, Subject =="General"), FUN=quantile)
wilcox.test(Citations~Behaviour, subset(processed_data, Subject =="General"))

# repeat for cognition journals only
aggregate(Citations~Behaviour, subset(processed_data, Subject=="Cognition"), FUN=length) 
aggregate(Citations~Behaviour, subset(processed_data, Subject =="Cognition"), FUN=quantile)
wilcox.test(Citations~Behaviour, subset(processed_data, Subject =="Cognition"))


### journal impact factors & subjects ###

# descriptive statistics 
aggregate(JIF~Behaviour, processed_data, FUN=length) 
aggregate(JIF~Behaviour, processed_data, FUN=quantile)

# wilcox test
wilcox.test(JIF~Behaviour, processed_data)

# repeat for great apes
aggregate(JIF~Behaviour, subset(processed_data, Great.Ape=="Y"), FUN=length) 
aggregate(JIF~Behaviour, subset(processed_data, Great.Ape=="Y"), FUN=quantile)
wilcox.test(JIF~Behaviour, subset(processed_data, Great.Ape=="Y"))

# repeat for Corvus
aggregate(JIF~Behaviour, subset(processed_data, Corvus=="Y"), FUN=length)
aggregate(JIF~Behaviour, subset(processed_data, Corvus=="Y"), FUN=quantile)
wilcox.test(JIF~Behaviour, subset(processed_data, Corvus=="Y"))

# compare tool use in great apes vs. Corvus
wilcox.test(subset(processed_data, Great.Ape=="Y" & Behaviour=="Tool")$JIF, subset(processed_data, Corvus=="Y" & Behaviour=="Tool")$JIF)

# compare nest building in apes vs. Corvus
wilcox.test(subset(processed_data, Great.Ape=="Y" & Behaviour=="Nest")$JIF, subset(processed_data, Corvus=="Y" & Behaviour=="Nest")$JIF)

# repeat for general interest journals only
aggregate(JIF~Behaviour, subset(processed_data, Subject=="General"), FUN=length) 
aggregate(JIF~Behaviour, subset(processed_data, Subject=="General"), FUN=quantile)
wilcox.test(JIF~Behaviour, subset(processed_data, Subject=="General"))

# repeat for cognition journals only
aggregate(JIF~Behaviour, subset(processed_data, Subject=="Cognition"), FUN=length) 
aggregate(JIF~Behaviour, subset(processed_data, Subject=="Cognition"), FUN=quantile)
wilcox.test(JIF~Behaviour, subset(processed_data, Subject=="Cognition"))

# frequency table for journal categories
table(processed_data$Subject, processed_data$Behaviour)

# frequency tables for great apes and Corvus species
table(subset(processed_data, Great.Ape=="Y")$Behaviour, subset(processed_data, Great.Ape=="Y")$Subject)
table(subset(processed_data, Corvus=="Y")$Behaviour, subset(processed_data, Corvus=="Y")$Subject)

# prop table for journal categories (converted to percentages acros rows)
prop.table(table(processed_data$Behaviour, processed_data$Subject), 1)*100

# chi-square test: general interest/not general interest vs. nests/tools
processed_data$General<-ifelse(processed_data$Subject=="General", "Y", "N")
table(processed_data$General, processed_data$Behaviour, useNA="ifany")
prop.table(table(processed_data$General, processed_data$Behaviour), 2)*100 # percentages down columns
chisq.test(table(processed_data$General, processed_data$Behaviour))

# chi-square test: cognition-focused/not cognition-focused vs. nests/tools
processed_data$Cognition<-ifelse(processed_data$Subject=="Cognition", "Y", "N")
table(processed_data$Cognition, processed_data$Behaviour, useNA="ifany")
prop.table(table(processed_data$Cognition, processed_data$Behaviour), 2)*100
chisq.test(table(processed_data$Cognition, processed_data$Behaviour))

# chi-square test: human-focused/not human-focused vs. nests/tools
processed_data$Anthro<-ifelse(processed_data$Subject=="Anthro", "Y", "N")
table(processed_data$Anthro, processed_data$Behaviour, useNA="ifany")
prop.table(table(processed_data$Anthro, processed_data$Behaviour), 2)*100
chisq.test(table(processed_data$Anthro, processed_data$Behaviour))

# chi-square test: ecology-focused/not ecology-focused vs. nests/tools
processed_data$Ecology<-ifelse(processed_data$Subject=="Ecology", "Y", "N")
table(processed_data$Ecology, processed_data$Behaviour, useNA="ifany")
prop.table(table(processed_data$Ecology, processed_data$Behaviour), 2)*100
chisq.test(table(processed_data$Ecology, processed_data$Behaviour))

# chi-square test: taxon-specific/not taxon-specific vs. nests/tools
processed_data$Taxon<-ifelse(processed_data$Subject=="Taxon", "Y", "N")
table(processed_data$Taxon, processed_data$Behaviour, useNA="ifany")
prop.table(table(processed_data$Taxon, processed_data$Behaviour), 2)*100
chisq.test(table(processed_data$Taxon, processed_data$Behaviour))

# chi-square test: applied focus/not applied focus vs. nests/tools
processed_data$Applied<-ifelse(processed_data$Subject=="Applied", "Y", "N")
table(processed_data$Applied, processed_data$Behaviour, useNA="ifany")
prop.table(table(processed_data$Applied, processed_data$Behaviour), 2)*100
chisq.test(table(processed_data$Applied, processed_data$Behaviour))

### abstract language ###

# descriptive statistics 
aggregate(Intel.percent~Behaviour, processed_data, FUN=length) 
aggregate(Intel.percent~Behaviour, processed_data, FUN=quantile)

# wilcox test
wilcox.test(Intel.percent~Behaviour, processed_data)

# repeat for alternative dictionary
aggregate(Alt.percent~Behaviour, processed_data, FUN=length) 
aggregate(Alt.percent~Behaviour, processed_data, FUN=quantile)
wilcox.test(Alt.percent~Behaviour, processed_data)

# repeat for great apes
aggregate(Intel.percent~Behaviour, subset(processed_data, Great.Ape=="Y"), FUN=length) 
aggregate(Intel.percent~Behaviour, subset(processed_data, Great.Ape=="Y"), FUN=quantile)
wilcox.test(Intel.percent~Behaviour, subset(processed_data, Great.Ape=="Y"))

# repeat for Corvus
aggregate(Intel.percent~Behaviour, subset(processed_data, Corvus =="Y"), FUN=length)
aggregate(Intel.percent~Behaviour, subset(processed_data, Corvus =="Y"), FUN=quantile)
wilcox.test(Intel.percent~Behaviour, subset(processed_data, Corvus=="Y"))

# compare tool use in great apes vs. Corvus
wilcox.test(subset(processed_data, Great.Ape=="Y" & Behaviour=="Tool")$Intel.percent, subset(processed_data, Corvus=="Y" & Behaviour=="Tool")$Intel.percent)

# compare nest building in great apes vs. Corvus
wilcox.test(subset(processed_data, Great.Ape=="Y" & Behaviour=="Nest")$Intel.percent, subset(processed_data, Corvus=="Y" & Behaviour=="Nest")$Intel.percent)

# repeat for general interest journals only
aggregate(Intel.percent~Behaviour, subset(processed_data, Subject=="General"), FUN=length) 
aggregate(Intel.percent~Behaviour, subset(processed_data, Subject=="General"), FUN=quantile)
wilcox.test(Intel.percent~Behaviour, subset(processed_data, Subject=="General"))

# repeat for cognition journals only
aggregate(Intel.percent~Behaviour, subset(processed_data, Subject=="Cognition"), FUN=length) 
aggregate(Intel.percent~Behaviour, subset(processed_data, Subject=="Cognition"), FUN=quantile)
wilcox.test(Intel.percent~Behaviour, subset(processed_data, Subject=="Cognition"))

# frequencies of individual stems in tool use vs. nest building papers
tool_tokens<-unnest_tokens(tbl=subset(processed_data, Behaviour=="Tool"), output=word, input=Abstract, token="words", to_lower=TRUE)$word # extract words for tool use papers
length(tool_tokens) # total number of words in tool use abstracts
nest_tokens<-unnest_tokens(tbl=subset(processed_data, Behaviour=="Nest"), output=word, input=Abstract, token="words", to_lower=TRUE)$word # extract words for nest buidling papers
length(nest_tokens) # total number of words in nest building abstracts

# load dictionary
dictionary<-read.table("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/Dictionaries/custom_dictionary.txt", header=T, sep="\t") 

# convert dictionary words to stems
dictionary_stems <- wordStem(dictionary$word,  language = "english")

# convert abstract words to stems for tool use and nest building separately
tool_stems<-wordStem(tool_tokens,  language = "english") 
nest_stems<-wordStem(nest_tokens,  language = "english") 

# remove NAs in stems (articles with no abstracts)
tool_stems<-tool_stems[!is.na(tool_stems)]
nest_stems<-nest_stems[!is.na(nest_stems)]

toolmatch_stems<-as.data.frame(table(tool_stems[which(tool_stems %in% dictionary_stems)])) # frequency table for each matching stem for tool use
colnames(toolmatch_stems)<-c("Stem", "Tool_freq") # change column names for convenience
nestmatch_stems<-as.data.frame(table(nest_stems[which(nest_stems %in% dictionary_stems)])) # frequency table for each matching stem for nest building
colnames(nestmatch_stems)<-c("Stem", "Nest_freq") # change column names for convenience

merged_match_stems<-merge(toolmatch_stems, nestmatch_stems, by="Stem", all=TRUE) # merge the matching stems
merged_match_stems[is.na(merged_match_stems)]<-0 # replace NAs with zeros (so we can include stems found in one dataset but not the other)

merged_match_stems$Tool_percent<-merged_match_stems$Tool_freq/length(tool_stems)*100 # calculate percentage matches for each matching stem for tool use, out of the total number of words in the tool use abstracts 
merged_match_stems$Nest_percent<-merged_match_stems$Nest_freq/length(nest_stems)*100 # calculate percentage matches for each matching stem for nest building, out of the total number of words in the nest building abstracts 

merged_match_stems$Percent_diff<-merged_match_stems$Tool_percent-merged_match_stems$Nest_percent # calculate absolute difference in % matches for tool use vs. nest building papers

merged_match_stems<-merged_match_stems[order(merged_match_stems$Percent_diff, decreasing=T),] # order stems by the difference in % matches between tool use and nest building papers

# repeat for alternative dictionary
alt_dictionary<-read.table("https://raw.githubusercontent.com/sally-e-street/tool-nest-language/refs/heads/main/Dictionaries/alt_dictionary.txt", header=F, sep="\t") # load alternative dictionary
length(alt_dictionary$V1) # 21 words
alt_dictionary_stems <- wordStem(alt_dictionary$V1,  language = "english") # convert dictionary words to stems
length(unique(alt_dictionary_stems)) # no duplicates

toolmatch_alt_stems<-as.data.frame(table(tool_stems[which(tool_stems %in% alt_dictionary_stems)])) 
colnames(toolmatch_alt_stems)<-c("Stem", "Tool_freq")
nestmatch_alt_stems<-as.data.frame(table(nest_stems[which(nest_stems %in% alt_dictionary_stems)])) 
colnames(nestmatch_alt_stems)<-c("Stem", "Nest_freq")

merged_match_alt_stems<-merge(toolmatch_alt_stems, nestmatch_alt_stems, by="Stem", all=TRUE) 
merged_match_alt_stems[is.na(merged_match_alt_stems)]<-0 

merged_match_alt_stems$Tool_percent<-merged_match_alt_stems$Tool_freq/length(tool_stems)*100 
merged_match_alt_stems$Nest_percent<-merged_match_alt_stems$Nest_freq/length(nest_stems)*100

merged_match_alt_stems$Percent_diff<-merged_match_alt_stems$Tool_percent-merged_match_alt_stems$Nest_percent 

merged_match_alt_stems<-merged_match_alt_stems[order(merged_match_alt_stems$Percent_diff, decreasing=T),] 

# FIGURE 1 (panels a-c)
dev.off() 
dev.new(height=3.5, width=10.5, unit="in") # set plot size
par(mfrow=c(1,3)) # box plots for citations, impact factors and % 'intelligent' terms in abstracts
boxplot(log10(Citations+1)~Behaviour, processed_data, col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1, xlab="", yaxt="n", ylab="Citations", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2, ylim=c(0,3))
axis(side=2, at=log10(seq(from=1, to=1001, 10)), labels=rep("", 101)) # set custom axes appropriate for log10(x+1) transformed data
axis(side=2, at=c(0, log10(11),log10(101), log10(1001)), labels=c(0,10,100,1000), las=1)	

boxplot(log10(JIF+1)~Behaviour, processed_data, col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1, yaxt="n", xlab="", ylab="Impact factor", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2)
axis(side=2, at=log10(1:51), labels=rep("", 51))
axis(side=2, at=c(0, log10(2),log10(3), log10(4),log10(6), log10(11), log10(21), log10(51)), labels=c(0,1,2,"",5,10,20,50), las=1)	

boxplot(log10(Intel.percent+1)~Behaviour, processed_data, col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1,  xlab="", yaxt="n", ylab="% 'intelligent' terms", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2)
axis(side=2, at=log10(1:14), labels=rep("", 14))
axis(side=2, at=c(0, log10(2), log10(3), log10(6), log10(11)), labels=c(0, 1, 2, 5, 10), las=1)	

# FIGURE 1 d
dev.off()
dev.new(height=4, width=10.5, unit="in")
par(mfrow=(c(1,1))) # barplot for proportion of nest vs. tool use papers in each journal subject category
processed_data$Subject<-factor(processed_data$Subject, levels=c("Ecology", "Applied", "Taxon", "Other_bio", "Zoology", "General", "Cognition", "Anthro")) # re-order groups for illustrative purposes
xpos_bp_journals<-barplot(prop.table(table(processed_data$Behaviour, processed_data$Subject), 2), border=c("blue", "red"), col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), ylab="Proportion", xlab="", las=1, cex.axis=0.8, cex.lab=0.8, cex.names=0.8, names.arg=c("Ecology", "Applied", "Taxon", "Other bio.", "Zoology", "General", "Cognition", "Anthro")) # create the barplot and save the position of the x axis labels
abline(h=prop.table(table(subset(processed_data, !is.na(Subject))$Behaviour))[1], lty=2) # overall proportion of nest building papers
text(x=xpos_bp_journals, y=0.03, table(processed_data$Behaviour, processed_data$Subject)[1,], col="blue", cex=0.8) # add frequencies for nest building papers
text(x=xpos_bp_journals, y=0.97, table(processed_data$Behaviour, processed_data$Subject)[2,], col="red", cex=0.8) # add frequencies for tool use papers

# FIGURE 1 e
dev.off()
dev.new(height=3.5, width=10.5, unit="in")
par(mfrow=(c(1,1))) # barplot showing % matching stems for nest building and tool use papers
xpos_intel_stems<-barplot(height=merged_match_stems$Tool_percent, names=merged_match_stems$Stem, xaxt="n", cex.names=0.8, las=2, cex.axis=0.8, col=rgb(1,0,0,0.5), border="red", xlab="Stem", ylab="% matches", cex.lab=0.8) # create the barplot and save the position of the x axis labels
text(cex=0.8, x= xpos_intel_stems, y=-0.03, merged_match_stems$Stem, xpd=T, srt=45, adj=1)
barplot(height=merged_match_stems$Nest_percent, add=T, col=rgb(0,0,1,0.5), border="blue", axes=F, yaxt="n", xaxt="n")
legend("topright", legend=c("Nests", "Tools"), pch=22, pt.bg=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), col=c("blue", "red"), cex=0.8)	

# FIGURE S2 
dev.off()
dev.new(height=3.5, width=10.5, unit="in")
par(mfrow=(c(1,1))) # barplot showing % matching stems for nest building and tool use papers, using alternative dictionary
xpos_alt_stems<-barplot(height=merged_match_alt_stems$Tool_percent, names=merged_match_alt_stems$Stem, xaxt="n", cex.names=0.8, las=2, cex.axis=0.8, col=rgb(1,0,0,0.5), border="red", xlab="Stem", ylab="% matches", cex.lab=0.8)
text(cex=0.8, x= xpos_alt_stems, y=-0.005, merged_match_alt_stems$Stem, xpd=T, srt=45, adj=1)
barplot(height=merged_match_alt_stems$Nest_percent, add=T, col=rgb(0,0,1,0.5), border="blue", axes=F, yaxt="n", xaxt="n")
legend("topright", legend=c("Nests", "Tools"), pch=22, pt.bg=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), col=c("blue", "red"), cex=0.8)	

# FIGURE S3 a,c,e
dev.off()
dev.new(height=10.5, width=3.5, unit="in")
par(mfrow=c(3,1)) # boxplots for citations, impact factors and % 'intelligent' terms for great ape species only
boxplot(log10(Citations+1)~Behaviour, subset(processed_data, Great.Ape=="Y"), col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1, yaxt="n", xlab="", ylab="Citations", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2)
axis(side=2, at=log10(seq(from=1, to=1001, 10)), labels=rep("", 101))
axis(side=2, at=c(0, log10(11),log10(101), log10(1001)), labels=c(0,10,100,1000), las=1)	

boxplot(log10(JIF+1)~Behaviour, subset(processed_data, Great.Ape =="Y"), col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1, yaxt="n", xlab="", ylab="Impact factor", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2)
axis(side=2, at=log10(1:51), labels=rep("", 51))
axis(side=2, at=c(0, log10(2),log10(3), log10(4),log10(6), log10(11), log10(21), log10(51)), labels=c(0,1,2,"",5,10,20,50), las=1)	

boxplot(log10(Intel.percent+1)~Behaviour, subset(processed_data, Great.Ape=="Y"), col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1,  xlab="", yaxt="n", ylab="% 'intelligent' terms", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2)
axis(side=2, at=log10(1:14), labels=rep("", 14))
axis(side=2, at=c(0, log10(2), log10(3), log10(6), log10(11)), labels=c(0, 1, 2, 5, 10), las=1)	

# FIGURE S3 b,d,f
dev.off()
dev.new(height=10.5, width=3.5, unit="in")
par(mfrow=c(3,1)) # boxplots for citations, impact factors and % 'intelligent' terms for Corvus species only
boxplot(log10(Citations+1)~Behaviour, subset(processed_data, Corvus=="Y"), col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1, yaxt="n", xlab="", ylab="Citations", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2)
axis(side=2, at=log10(seq(from=1, to=1001, 10)), labels=rep("", 101))
axis(side=2, at=c(0, log10(11),log10(101), log10(1001)), labels=c(0,10,100,1000), las=1)	

boxplot(log10(JIF+1)~Behaviour, subset(processed_data, Corvus=="Y"), col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1, yaxt="n", xlab="", ylab="Impact factor", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2)
axis(side=2, at=log10(1:51), labels=rep("", 51))
axis(side=2, at=c(0, log10(2),log10(3), log10(4),log10(6), log10(11), log10(21), log10(51)), labels=c(0,1,2,"",5,10,20,50), las=1)	

boxplot(log10(Intel.percent+1)~Behaviour, subset(processed_data, Corvus=="Y"), col=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)), border=c(rgb(0,0,1,0.75), rgb(1,0,0,0.75)), las=1,  xlab="", yaxt="n", ylab="% 'intelligent' terms", range=1.5, names=c("Nests", "Tools"), cex.lab=1.2, cex.axis=1.2, ylim=c(0, log10(11)))
axis(side=2, at=log10(1:14), labels=rep("", 14))
axis(side=2, at=c(0, log10(2), log10(3), log10(6), log10(11)), labels=c(0, 1, 2, 5, 10), las=1)	


### multiple regression models ###

# model comparison
summary(null_model<-hurdle(Citations~1, subset(processed_data, !is.na(Intel.percent)), dist="poisson", zero.dist="binomial", link="logit")) # null model, intercept only
summary(behaviour_model<-hurdle(Citations~Behaviour, subset(processed_data, !is.na(Intel.percent)), dist="poisson", zero.dist="binomial", link="logit")) # behaviour only (tools vs. nests)
summary(intel_model<-hurdle(Citations~log10(Intel.percent+1), subset(processed_data, !is.na(Intel.percent)), dist="poisson", zero.dist="binomial", link="logit")) # language only (% 'intelligent' terms in abstracts)
summary(full_model<-hurdle(Citations~Behaviour+log10(Intel.percent+1), subset(processed_data, !is.na(Intel.percent)), dist="poisson", zero.dist="binomial", link="logit")) # behaviour + language
summary(full_int_model<-hurdle(Citations~Behaviour*log10(Intel.percent+1), subset(processed_data, !is.na(Intel.percent)), dist="poisson", zero.dist="binomial", link="logit")) # behaviour * language

AIC(null_model, behaviour_model, intel_model, full_model, full_int_model) # full model with interaction best supported

# McFadden's pseudo R^2 for full model
1-(logLik(full_int_model)[1]/logLik(null_model)[1])

# FIGURE 2
dev.off()
dev.new(width=5, height=5)
par(mfrow=c(1,1)) # scatterplot and fit lines for full model
plot(Citations~log10(Intel.percent+1), subset(processed_data, Behaviour=="Tool"), pch=19, col=rgb(1,0,0,0.1), las=1, ylab="Citations", xlab="% 'intelligent' terms", xaxt="n")
points(Citations~log10(Intel.percent+1), subset(processed_data, Behaviour=="Nest"), pch=19, col=rgb(0,0,1,0.1))
legend("topleft", pch=19, legend=c("Tool use", "Nest building"), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)))
axis(side=1, at=log10(1:16), labels=rep("", 16))
axis(side=1, at=c(0, log10(2), log10(3), log10(4), log10(5), log10(6), log10(11), log10(16)), labels=c(0, 1, 2, 3,4, 5, 10, 15))

# add fit lines
data_fitting<-subset(processed_data, !is.na(Intel.percent)) # create subset of the data with % language available 
data_fitting$Fitted<-full_int_model$fitted.values # extract fitted values from full model with interaction
tool_spline<-smooth.spline(x=log10(subset(data_fitting, Behaviour=="Tool")$Intel.percent+1), y=subset(data_fitting, Behaviour=="Tool")$Fitted) # create a smoothed spline for tool use
nest_spline<-smooth.spline(x=log10(subset(data_fitting, Behaviour=="Nest")$Intel.percent+1), y=subset(data_fitting, Behaviour=="Nest")$Fitted) # create a smoothed spline for nest building
lines(tool_spline, col="red", lwd=2) # add tool spline
lines(nest_spline, col="blue", lwd=2) # add nest spline


### change over time ###

# calculate % intelligent words per year (i.e. matching stems for the abstracts in a given year as a percentage of all abstract stems in that year)
tool_words_year<-as.data.frame(cbind(unique(subset(processed_data, Behaviour=="Tool")$Publication.Year), rep(NA, length(unique(subset(processed_data, Behaviour=="Tool")$Publication.Year))))) # set up data for tool use
colnames(tool_words_year)<-c("Year", "Perc_matches") # change column names for convenience
tool_words_year<-tool_words_year[order(tool_words_year$Year),] # sort by year

for (i in 1:length(tool_words_year$Perc_matches)){ # calculate % matching stems for each year
	tokens<-unnest_tokens(tbl=subset(processed_data, Behaviour=="Tool")[subset(processed_data, Behaviour=="Tool")$Publication.Year==tool_words_year$Year[i],], output=word, input=Abstract, token="words", to_lower=TRUE)$word # extract words for year i
	stems<-wordStem(tokens,  language = "english") # convert to stems
	stems<-stems[!is.na(stems)] # remove NAs (where abstracts missing)
	tool_words_year$Perc_matches[i]<-length(which(stems %in% dictionary_stems))/length(stems)*100 # % of matching stems of total stems for that year
	}
	
nest_words_year<-as.data.frame(cbind(unique(subset(processed_data, Behaviour=="Nest")$Publication.Year), rep(NA, length(unique(subset(processed_data, Behaviour=="Nest")$Publication.Year))))) # repeat for nests
colnames(nest_words_year)<-c("Year", "Perc_matches") 
nest_words_year<-nest_words_year[order(nest_words_year$Year),] 

for (i in 1:length(nest_words_year$Perc_matches)){
	tokens<-unnest_tokens(tbl=subset(processed_data, Behaviour=="Nest")[subset(processed_data, Behaviour=="Nest")$Publication.Year==nest_words_year$Year[i],], output=word, input=Abstract, token="words", to_lower=TRUE)$word
	stems<-wordStem(tokens,  language = "english")
	stems<-stems[!is.na(stems)] # remove NAs (where abstracts missing)
	nest_words_year$Perc_matches[i]<-length(which(stems %in% dictionary_stems))/length(stems)*100
	}
	
merged_words_year<-merge(tool_words_year, nest_words_year, by="Year", all=TRUE) # merge tool and nest matches by year
colnames(merged_words_year)[2:3]<-c("Tool_matches", "Nest_matches") # rename columns
merged_words_year[complete.cases(merged_words_year),]

merged_words_year<-merged_words_year[complete.cases(merged_words_year),] # remove years without any abstracts
merged_words_year<-subset(merged_words_year, Year<2024) # remove 2024 (incomplete year)

# linear models
toolmatches_year_lm<-lm(Tool_matches~Year, merged_words_year)
summary(toolmatches_year_lm)
qqnorm(toolmatches_year_lm$resid); qqline(toolmatches_year_lm$resid) # reasonable fit 

nestmatches_year_lm<-lm(Nest_matches~Year, merged_words_year)
summary(nestmatches_year_lm)
qqnorm(nestmatches_year_lm$resid); qqline(nestmatches_year_lm$resid) # reasonable fit 

# FIGURE 3
dev.off()
dev.new(width=9, height=3)
par(mfrow=c(1,1)) # change in % of 'intelligent' words over time for nest building vs. tool use articles
plot(Tool_matches~Year, merged_words_year, pch=19, col=c(rgb(1,0,0,0.6)), las=1, ylab="% 'intelligent' terms", xaxt="n", cex=0.8, cex.lab=0.8, cex.axis=0.8, ylim=c(0,4))
abline(toolmatches_year_lm, col="red", lwd=2) # fit line for tools
points(Nest_matches~Year, merged_words_year, pch=19, col=c(rgb(0,0,1,0.6)), cex=0.8)
abline(nestmatches_year_lm, col="blue", lwd=2, cex=0.8) # fit line for nests
axis(side=1, at=c(seq(from=1975, to=2020, by=5)), cex.axis=0.8)
legend("topleft", legend=c("Tool use", "Nest building"), pch=19, cex=0.8, col=c(rgb(1,0,0,0.75), rgb(0,0,1,0.75)), bty="n")