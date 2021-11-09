University Rankings
===================
Snap judgements and first impressions are important influences on decision making.  This is especially true online, where studies show that people decide to leave or browse a site within just a few seconds of following a link.

In the world of university applications, two major facets are often presented as reasons for attendance:

 1. Academic rigor and capacity
 2. Social and extra-curricular opportunity

One might suppose that, of these, the former is more desirable: after all, a university is a place dedicated to academic pursuits.  It is reasonable, therefore, to presume that institutions use the latter as a selling point primarily where they are incapable of empirically justifying their claims to the former.

From this hypothesis, this study aims to assess whether there is a correlation between the academic quality of a university (as attested to by expert assessors from many well-known lists) and the focus of their marketing material.  In part due to ease-of-access, we will be using their web presence: main website and prospectuses.

RQs
---
 1. Is the language used by universities in marketing material a significant indicator of their academic quality?
 2. If so, what language features define this?

Literature
----------
See the [lit review](LitReview).

Plan
----
In effect, the aim is to acquire a sample of university web pages' language, compare it to their overall rankings, and see if anything correlates with a reasonable causal link.  This breaks down into:

 1. Acquire Web Data
    - [Find list of uni websites](WebList)
    - [Scrape](WebScrape) (n=1 or 2 links deep to represent their general focus)
    - [Convert](WebConversion) to text
    - [Process](WebAnnotation) into CSV file: word, university, frequency, stem, etc...

 2. Acquire Ranking Ground Truth
    - [Identify](Rankings) the most influential/meaningful rankings
    - [Download](RankingScrape) these rankings; normalise and code them to fit with the CSV
    - Add as a column in the CSV
 
 3. Linguistic Feature Extraction
    - [Decide](LanguageMetrics) on 'academicness' metrics
    - Implement (TODO: wordnet, AMT, corpus comparisons?)

 4. Analysis
    - Data descriptions
    - Comparisons of ranks, relation to literature
    - Comparison of our metrics to ranks, correlation
    - Model-building and significance testing

 5. Paper
    - Write up notes
    - Relate to other stuff.
  


