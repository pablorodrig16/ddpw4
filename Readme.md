# Developing Data Products Coursera Course W4 project assignment

This repository holds the scripts for the DDPW4 assignment. The project requires a shiny app deployed in [Rstudio shiny server](http://www.shinyapps.io/), a R presentation in [Rpubs](http://www.rpubs.com), and the app script in [GitHub](https://github.com/).

## The Project:
### Simulation of the performance of a diagnostic test

The project simulation of a diagnostic performance study. It was developed as follows:  
1. A test vector is created with uniform random values.  
2. Disease is diagnosed if test value is greater than 5 plus an error term assigned by the user with *Set test performance* slider.  
3. Also a threshold value to compute the diagnostic performance calculations is available for the user with *Choose a test value as threshold* slider.  

It requires `epiR` and `plotly` R packages.

The app has 2 outputs:  
1. *Confusion matrix* and *performance calculations* for the threshold chosen by the user.  
2. Three types of diagnostic plots:  
    -   ROC curve  
    -   Youden index versus values  
    -   Likelihood ratios versus values  

You can access the shiny app [here](https://porbm28.shinyapps.io/DDPW4/).

Information about about diagnostic test evaluation can be found in [wikipedia](https://en.wikipedia.org/wiki/Sensitivity_and_specificity).