
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

## Set up

1. Create an API key in [OpenAI Platform](https://platform.openai.com/api-keys) after logging into your account.

2. Add your API key to your R environment file (.Renviron)
    ``` r
    library(geneGPT)
    add_openai_key_to_renv(<YOUR_KEY>)
    ```
3. If you receive the following error message:
     ``` r
     .Renviron file not found. Please create the .Renviron file first.
     ```

   Run the following line of code in the terminal:
    ``` 
    touch ~/.Renviron
    ```
4. If you receive the following message:
   ``` r
   OPENAI_API_KEY added to .Renviron successfully.
   ```

   Run the following command to source your .Renviron file:
   ``` r
   readRenviron("~/.Renviron")
   ```

   You are all set to run some of the example code!
   
## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(geneGPT)
genes = gene_annotation(c("VIM", "CDH1", "TWIST1"))
signal = markers("EMT Transition", 5)
answer = chat("Could you give me a biological interpreation of VIM, CDH1, TWIST1 being upregulated in cancer?")
```

