### START HERE ###

This repository contains R code and data files associated with an accepted manuscript titled _"Anthropocentric biases may explain research disparities between animal tool use and nest building"_. See below for a description of each file.

**tool_nest_language_data_sharing.csv**: this file contains the processed data from Clarivate Web of Science/Journal Citation Reports searches. You can use this to reproduce all the findings reported in the main text and supplementary material. It contains the following columns:

Article.Title: article title.

Abstract: text of article abstract (if available, otherwise NA).

Citations: number of citations per article as recorded in all Web of Science databases.

Behaviour: indicates whether the article is relevant to tool use (Tool) or nest building (Nest).

Great.Ape: indicates whether the article is relevant to the behaviour of great apes (Y) or other taxa (N).

Corvus: indicates whether the article is relevant to the behaviour of Corvus species (Y) or other taxa (N).

JIF: journal impact factor (for the year 2023 or latest available year, if available, otherwise NA).

Subject: subject category (one of: Anthro, Applied, Cognition, Ecology, General, Other_bio, Taxon, Zoology or NA if not available. See main text and supplementary information for further explanation of these categories)

Intel.percent: percentage of words in the article abstract (where available, otherwise NA) that match a custom dictionary of 'intelligent' language (see main text and supplementary information for further explanation). 

Alt.percent: percentage of words in the article abstract (where available, otherwise NA) that match an alternative dictionary of 'intelligent' language (see main text and supplementary information for further explanation). 

CSV files contained in the **WoS_data** folder, i.e. **all_tool_results.csv**, **all_nest_results.csv**, **ape_tool_results.csv**, **ape_nest_results.csv**, **corvus_tool_results.csv** and **corvus_nest_results.csv** contain unprocessed data from searches of the Web of Science for tool use and nest building papers. The prefix 'all' indicates all species, while 'ape' and 'corvus' indicate subsets containing results for Great ape and _Corvus_ species respectively. 

A description of the relevant columns in the files listed above is as follows:

Include (0/1): indicates whether the article was to be included (1) or excluded (0) from the analyses based on criteria described in the Supplementary Information (note that this column is not included in the all species nest dataset).

Publication.Type: indicate the type of publicaiton, either B=book or J=journal article.

Article.Title: article title.

Source.Title: book or journal title.

Publication.Year: year of publication.

Abstract: text of article abstract (if available).

Times.Cited..All.Databases: number of citations per article as recorded in all Web of Science databases.

**Rscript** contains R code used to produce the analyses reported in the main text and supplementary information. For further explanation please see the script annotations.

**construction_dictionary.txt** contains the list of words representing 'intelligent' terminology used in article abstacts (for full details, see the Methods section of the paper and the R script). 

CSV files contained in the **JCR_data** folder with the prefix 'JCR' contain data exported from a number of searches of Clarivate's Journal Citation Reports tool for journal information, using various filters (because only 600 results could be exported at a time). Codes in the file names indicate which journals were included in each search, i.e. 'anthro' = anthropology journals, 'arch' = archaeology journals, 'beh_sci' = behavioural science journals, 'biodiv' = biodiversity journals, 'biology' = biology journals, 'ecology' = ecology journals, 'ento' = entomology journals, 'env_sci' = 'environmentral sciences', 'evo_devo' = evolutionary and developmental biology, 'fish' = fisheries, 'multi' = multidisciplinary, 'orni' = ornithology, 'palaeo' = palaeontology, 'psych' = psychology, 'top600' = 600 most highly cited journals, 'toxi' = toxicology, 'vet' = veterinary sciences, 'zoology' = zoology. An additional file, 'journals_manual.csv' contains the results of further manual collection of impact factors and categorisation into subjects prior to analysis (because only a small number of journals in the main database could be automatically matched to the aforementioned searches, and because JCR's own subject categories were not suitable for testing predictions). 

Text files contained in the **Dictionaries** folder contain two custom dicionaries used for matching stems from article abstracts. 'custom_dictionary.txt' is the dictionary used for the vast majority of analyses, containing a combination of words selected by the authors and included in the Collins online thesauraus, detailed in Table S1. 'alt_dictionary.txt' is an alternative dictionary, containing the word 'intelligent' plus 20 synonyms included in the Collins online thesaurus. 
