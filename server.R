
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny); library (epiR);library (plotly)

shinyServer(function(input, output) {
    set.seed(1000)
    
    ## function to make 2 by 2 table
    tableFUN<-function (test, disease, threshold){
        if(any(test<threshold)) {
            result<-table(test<threshold,!disease)
        }else{
            result<-table(test<threshold,!disease)
            result<-rbind(result,c(0,0))
            rownames(result)[2]<-"TRUE"
        }
        result[is.na(result)]<-0
        return (result) 
    }
    
    ## creates test values
    test<-round(runif(n = 1000,min = 1,max = 10),2)

   
    ## creates disease vector defined when test value is greater than
    ## diseaseDef (5 + error term)
    disease<-reactive({
        test>runif(n = 1000,min = -1*input$err,max = input$err) +5
    })
    
    
    epiTest<-reactive({
        epi.tests(tableFUN(test = test,disease = disease(),threshold = input$threshold))
    })
    
    output$table2by2<-renderTable({
        t2by2<-epiTest()$tab
        t2by2[is.na(t2by2)]<-0
        t2by2
    })
    
    output$Performance<-renderText({
        performance<-summary(epiTest())
        performance<-performance[c(3,4,9:12,8),]
        rownames(performance)<-c("Sensitivity","Specificity", 
                                 "Positive Predictive Value",
                                 "Negative Predictive Value",
                                 "Positive Likelihood Ratio",
                                 "Negative LIkelihood Ratio",
                                 "Youden index")
        performance<-round(performance,2)
        
        pasteFun<-function (x){
            paste(x[1], " (",x[2],"-",x[3],"). ", sep = "")
        }
        
        values<-apply (performance,1,pasteFun)
        paste(row.names(performance),values,sep = ": ")
    })
    
    output$my_plot<-renderPlotly({
        specificity<-epiTest()$rval$sp
        sensitivity<-epiTest()$rval$se
        ## dataframe1 is a dataframe with test value, disease condition, se (sensitivity)
        ## sp (specificity), fp (false positive rate), plr (positive likelyhood ratio),
        ## nlr (negative likelyhood ratio), youden (youden index=se-fp)
        dataframe1<-data.frame(value=test,disease=disease())
        dataframe1$se<-sapply (test,FUN = function (x) {
            table1<-tableFUN(test = dataframe1$value,
                             disease = dataframe1$disease,
                             threshold = x)
            return(table1[1,1]/colSums(table1)[1])
        })
        dataframe1$sp<-sapply (test,FUN = function (x) {
            table1<-tableFUN(test = dataframe1$value,
                             disease = dataframe1$disease,
                             threshold = x)
            return(table1[2,2]/colSums(table1)[2])
        })
        dataframe1$fp<-1-dataframe1$sp
        dataframe1$plr<-dataframe1$se/dataframe1$fp
        dataframe1$nlr<-(1-dataframe1$se)/dataframe1$sp
        dataframe1$youden<-dataframe1$se-dataframe1$fp
        
        ## dataframe2 is a dataframe with sp, se for the threshold choosen by the user
        dataframe2<-dataframe2<-data.frame(1-specificity[1], sensitivity[1],
                                           Threshold=input$threshold)
        names(dataframe2)<-c("FalsePositive","Sensitivity","Threshold")
        
        if (input$mplot=="roc"){
            ## ROC curve
            my_plot<-plot_ly(data = dataframe1,x=~fp,y=~se, 
                             type="scatter", mode="markers",
                             text=~paste("Test value:",value),
                             colors="blue",
                             name="ROC curve")%>%
                add_trace(x=~dataframe2$FalsePositive, type="scatter",
                          y= ~dataframe2$Sensitivity,mode="markers",
                          text=~paste("Threshold:",input$threshold),
                          name="Threshold", colors="red")%>%
                layout(yaxis=list(title="Sensitivity"),
                       xaxis=list(title="1 - Specificity"),
                       shapes = list(type = "line", fillcolor = "black",
                                     line = list(color = "black"),
                                     opacity = 0.2,
                                     x0 = 0, x1 = 1, xref = 'x', 
                                     y0 = 0, y1 = 1, yref = 'y'))
        }else if(input$mplot=="youden"){
            ## Youden versus values plot
            my_plot<-plot_ly(data = dataframe1, x=~value)%>%
                add_trace(y=~youden, name="Youden index", 
                          type="scatter", mode="markers")%>%
                add_trace(y=~dataframe2$Sensitivity-dataframe2$FalsePositive,
                          x=input$threshold, 
                type="scatter", mode="markers", name="Threshold")%>%
                layout(yaxis=list(title="Youden index", range=c(0,1.1)),
                       xaxis=list(title="Test value"))
        }else if (input$mplot=="lr"){
            ## plotly graph for both positive and negative LR versus test value
            my_plot<-plot_ly(data = dataframe1, x=~value)%>%
                add_trace (y=~plr, name="LR+", type = "scatter",mode="markers")%>%
                add_trace (y=~nlr, name="LR-", type = "scatter",mode="markers")%>%
                layout(yaxis=list(title="Likelihood ratio", type="log"),
                       xaxis=list(title="Test value"),
                       shapes = list(type = "line", fillcolor = "black",
                                     line = list(color = "black"),
                                     opacity = 0.2,
                                     x0 = input$threshold, x1 = input$threshold, 
                                     xref = 'x', 
                                     y0 = 0, y1 = max(dataframe1$plr,na.rm=TRUE),
                                     yref = 'y'))
        }
        my_plot
    })
})