### START HERE ###

This repository contains R code and data files associated with an as-yet-unpublished manuscript titled _"Anthropocentric biases may explain research disparities between animal tool use and nest building"_. See below for a description of each file.

Files contained in the **WoS_data** folder, i.e. **all_tool_results.csv**, **all_nest_results.csv**, **ape_tool_results.csv**, **ape_nest_results.csv**, **corvus_tool_results.csv** and **corvus_nest_results.csv** contain unprocessed data from searches of the Web of Science for tool use and nest building papers. The prefix 'all' indicates all species, while 'ape' and 'corvus' indicate subsets containing results for Great ape and _Corvus_ species respectively. 

A description of the relevant columns is as follows:

Include (0/1): indicates whether the article was to be included (1) or excluded (0) from the analyses based on criteria described in the Supplementary Information (note that this column is not included in the all species nest dataset).

Publication.Type: indicate the type of publicaiton, either B=book or J=journal article.

Article.Title: article title.

Source.Title: book or journal title.

Publication.Year: year of publication.

Abstract: text of article abstract (if available).

Times.Cited..All.Databases: number of citations per article as recorded in all Web of Science databases.

**Rscript** contains R code used to produce the analyses reported in the main text and supplementary information. For further explanation please see the script annotations.

**construction_dictionary.txt** contains the list of words representing 'intelligent' terminology used in article abstacts (for full details, see the Methods section of the paper and the R script). 

