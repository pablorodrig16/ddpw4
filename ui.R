
# This is DDPW4 project assignment

library(shiny);library (plotly)

shinyUI(fluidPage(

  # Application title
  titlePanel("Simulation of the performance of a diagnostic test"),
 
  # Sidebar with a slider inputs and radio buttons for options
  sidebarLayout(
    sidebarPanel(
        h6("
This is a simulation of a diagnostic performance study. 
First, a test vector is created with uniform random values.
Disease is diagnosed if test value is greater than 5 plus an error term assigned with 'Set test performance' slider.
Also a threshold value to compute the diagnostic performance calculations is available.
The app has 2 outputs: it shows the confusion matrix and performance calculations for 
the threshold and it allows the selection of 3 types of diagnostic plots: 
ROC curve, Youden index versus values and likelihood ratio versus values. See ",
          a(href="https://en.wikipedia.org/wiki/Sensitivity_and_specificity","wikipedia.")),
        h4("Options:"),
      sliderInput("err",
                  "Set test performance (0=perfect,30=bad):",
                  min = 0,
                  max = 30,
                  value = 2,
                  step=1),
      sliderInput("threshold",
                   "Choose a test value as threshold:",
                   value = 5,
                   min = 0, 
                   max=9.5,
                   step = 0.5),
      radioButtons("mplot",selected = "roc",
                   "Select a plot:",
                   c("ROC curve"="roc",
                     "Youden index versus test values"="youden",
                     "Likelihood ratios versus test values"="lr")),
      submitButton("Update calculations"),
      hr(),
      p("See the code in", a(href="https://github.com/pablorodrig16/ddpw4","GitHub."))
    ),

    # Show cases distribution, test performance and plots
    mainPanel(
        fluidRow(
            column(4,
                   h4("Confusion matrix"),
                   hr(),
                   tableOutput("table2by2")
                   ),
            column(8,
                   h4("Performance calculations"),
                   hr(),
                   span(textOutput("Performance"))
                   )
        ),
        plotlyOutput("my_plot",width = "auto")
       )
    )
  )
)
