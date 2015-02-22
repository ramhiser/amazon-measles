# Amazon Customer Reviews of Melanie's Marvelous Measles

The goal of this repository is to analyze the product reviews of [Melanie's
Marvelous Measles](http://www.amazon.com/Melanies-Marvelous-Measles-Stephanie-Messenger/dp/1466938897)
on Amazon.com.

## Usage

To get started, first install and load the `packrat` package via:

```r
devtools::install_github('rstudio/packrat')
```

After `packrat` is installed, we need to install and load the package snapshot used in this analysis. Do so via:

```r
library(packrat)
packrat::restore()
```

Once the required R package environment has been installed, load the various project utilities, munge scripts, and data sets via:

```r
library('ProjectTemplate')
load.project()
```
