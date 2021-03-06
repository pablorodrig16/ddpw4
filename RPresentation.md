DDP week 4 project
Simulation of the performance of a diagnostic test
========================================================
author: POR
date: Tue Nov 08 02:16:57 2016
Please visit my project [Shiny App](https://porbm28.shinyapps.io/DDPW4/) 


The project (I): Introduction
========================================================

* The project is a simulation of a diagnostic performance study of a numeric 'test' variable for a 'disease'.  
* Examples:  
    + Thyroid-stimulating hormone (TSH) and hypothyroidism
    + Prostate-Specific Antigen (PSA) and prostate cancer 
* The aim is to provide a graphical and data illustration of the diagnostic performance of 'test'.  
* The [Shiny App](https://porbm28.shinyapps.io/DDPW4/) allows the user to modify the theorical diagnostic performance of 'test' and to choose different 'threshold' values of 'test' as diagnostic tool for 'disease' and see the results.  


The project (II): Simulation
========================================================

1. 'test' is a vector created with random values of a uniform distribution (range: 1-10).  
2. 'disease' is diagnosed if 'test' value is greater than 5 plus an error term assigned by the user with *Set test performance* slider.
3. The app classifies cases and calculates performance parameters according to a 'test' value 'threshold' and makes different plots that illustrate the global performance of 'test' variable.  
<font size=5>
Example *confusion matrix* with 'threshold'>=5 and error term=3:  

```
          Disease +    Disease -      Total
Test +          486           70        556
Test -           80          364        444
Total           566          434       1000
```
</font>
4. The script of the [Shiny App](https://porbm28.shinyapps.io/DDPW4/) can be found [here](https://github.com/pablorodrig16/ddpw4).

The project (III): Analysis
========================================================

* `epiR::epi.tests()` function is used to calculate:  
    + Confusion matrix with margins
    + Performance parameters: 
        + Sensitivity
        + Specificity
        + Positive Predictive Value
        + Negative Predictive Value
        + Positive Likelihood Ratio
        + Negative LIkelihood Ratio
        + Youden's index

The Project (IV): Interface
========================================================
* Inputs:
    + *Set test performance* slider: theorical performance of 'test'
    + *Choose a test value as threshold* slider: 'threshold' value
    + *Select a plot* radio buttons: allows choosing plot
* Outputs: 
    + *Confusion matrix* and *performance calculations* for the 'threshold' chosen by the user.  
    + Interactive `plotly` package plots:
        + [ROC curve](https://en.wikipedia.org/wiki/Receiver_operating_characteristic)  
        + [Youden's index](https://en.wikipedia.org/wiki/Youden%27s_J_statistic) versus values  
        + [Likelihood ratios](https://en.wikipedia.org/wiki/Likelihood_ratios_in_diagnostic_testing) versus values 
