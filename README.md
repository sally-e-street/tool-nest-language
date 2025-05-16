### START HERE ###

This repository contains R code and data files associated with a published manuscript titled _"Anthropocentric bias may explain research disparities between animal tool use and nest building"_. See below for a description of each file.

**tool_nest_language_data_sharing.csv**: this is the processed data set that can be used to reproduce all findings reported in the main text and supplementary material. It contains the following columns:

Article.Title: article title.

Abstract: text of article abstract (if available, otherwise NA).

Citations: number of citations per article as recorded in all Web of Science databases.

Behaviour: indicates whether the article is relevant to tool use (Tool) or nest building (Nest).

Great.Ape: indicates whether the article is relevant to the behaviour of great apes (Y) or other taxa (N).

Corvus: indicates whether the article is relevant to the behaviour of Corvus species (Y) or other taxa (N).

JIF: journal impact factor (for the year 2023 or latest available year, if available, otherwise NA).

Subject: subject category (one of: Anthro, Applied, Cognition, Ecology, General, Other_bio, Taxon, Zoology or NA if not available. See main text and supplementary material for further explanation of these categories)

Intel.percent: percentage of words in the article abstract (where available, otherwise NA) that match a custom dictionary of 'intelligent' language (see main text and supplementary material for further explanation). 

Alt.percent: percentage of words in the article abstract (where available, otherwise NA) that match an alternative dictionary of 'intelligent' language (see main text and supplementary material for further explanation). 

**tool_nest_language_data_analysis.R** contains the R code used to produce the analyses reported in the main text and supplementary material. For further explanation please see the script annotations.

Text files contained in the **Dictionaries** folder contain two custom dictionaries used for matching stems from article abstracts. 'custom_dictionary.txt' is the dictionary used for the vast majority of analyses, containing a combination of words (n=61) selected by the authors and included in the Collins online thesauraus, detailed in Table S1. 'alt_dictionary.txt' is an alternative dictionary, containing the word 'intelligent' plus 20 synonyms (n=21) included in the Collins online thesaurus. 
