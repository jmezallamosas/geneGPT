
# geneGPT

<!-- badges: start -->
<!-- badges: end -->

GeneGPT is an R wrapper for ChatGPT 4.0 with default functions to call gene anotations and markers for biological processes.

## Installation

You can install the development version of geneGPT from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jmezallamosas/geneGPT")
```

## OpenAI API Key

You can create an API key in [OpenAI Platform](https://platform.openai.com/api-keys) after logging into your account.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(geneGPT)
## genes = gene_annotation(c("VIM", "CDH1", "TWIST1"))
## signal = markers("EMT Transition", 5)
## answer = chat("Could you give me a biological interpreation of VIM, CDH1, TWIST1 being upregulated in cancer?")
```

