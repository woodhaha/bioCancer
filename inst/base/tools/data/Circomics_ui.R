output$LegendCircos <- renderPlot({
  my.colors = colorRampPalette(c("blue3","cyan","white","yellow", "red","black"))
  z=matrix(1:100,nrow=1)
  x=1
  y=seq(3,2345,len=100) # supposing 3 and 2345 are the range of your data
  image(x,y,z,col=my.colors(100),axes=FALSE,xlab="",ylab="")
  #axis(2)
  mtext(text=c("Min","Low","middle","High","Max","NA"), line=1.8, las=2, side=4, at=c(50,500,900, 1400,1900,2300),adj = 1)
  mtext(text=c("Down","Low","0","High","Up","NA"), line=0.5, las=2, side=2, outer = FALSE, at=c(50,500,900, 1400,1900,2300),adj = 1)
})


# pull user data to r_data$ListProfData
output$uiPullUserDataCNA <- renderUI({
  selectInput(inputId = "UserData_CNA_id", label='CNA:',
              choices=  r_data$datasetlist, selected= "", multiple=FALSE,
              selectize = FALSE
  )
})
output$uiPullUserDatamRNA <- renderUI({
  selectInput(inputId = "UserData_mRNA_id", label='mRNA:',
              choices=  r_data$datasetlist, selected= "", multiple=FALSE,
              selectize = FALSE
  )
})
output$uiPullUserDataMetHM27 <- renderUI({
  selectInput(inputId = "UserData_MetHM27_id", label='Methylation HM27',
              choices= r_data$datasetlist, selected= NULL, multiple=FALSE,
              selectize = FALSE
  )
})
output$uiPullUserDataMetHM450 <- renderUI({
  selectInput(inputId = "UserData_MetHM450_id", label='Methylation HM450',
              choices= r_data$datasetlist, selected= NULL, multiple=FALSE,
              selectize = FALSE
  )
})
output$uiPullUserDataFreqMut <- renderUI({
  selectInput(inputId = "UserData_FreqMut_id", label='Mutation Frequency',
              choices= r_data$datasetlist, selected= NULL, multiple=FALSE,
              selectize = FALSE
  )
})
output$uiPullUserDatamiRNA <- renderUI({
  selectInput(inputId = "UserData_miRNA_id", label='miRNA',
              choices= r_data$datasetlist, selected= NULL, multiple=FALSE,
              selectize = FALSE
  )
})
output$uiPullUserDataRPPA <- renderUI({
  selectInput(inputId = "UserData_RPPA_id", label='RPPA',
              choices= r_data$datasetlist, selected= NULL, multiple=FALSE,
              selectize = FALSE
  )
})



output$ui_CircosDimension <- renderUI({

  Dimension <- c("CNA","Methylation", "mRNA","Mutation","miRNA","RPPA", "All" )
  selectizeInput("CircosDimensionID", label= "Select Dimension:", choices= Dimension,
                 selected= "", multiple=TRUE)
})

output$StrListProfDataCircos <- renderPrint({

  withProgress(message = 'loading Profiles Data... ', value = 0.1, {
    Sys.sleep(0.25)
    getListProfData(panel='Circomics',input$GeneListID)
  })
  ## don't use r_data$ListProfData => cause réinitiate wheel
#      if(is.null(r_data$ListProfData)){
#        c("Gene List is empty. copy and paste genes from text file (Gene/line) or use gene list from examples.")
#     }else{
#
   c("STUDIES:", input$StudiesIDCircos,
  "Genetic Profiles: mRNA, Methylation, CNA, miRNA, Mutations, RPPA",
    "Gene List:",
    r_data[[input$GeneListID]]
  )
# }
})

output$ui_Circomics <- renderUI({

  ## get Studies for Circomics
  updateSelectizeInput(session, 'StudiesIDCircos', choices = Studies[,1], selected = c("luad_tcga_pub","blca_tcga_pub"))
  #,"prad_tcga_pub","ucec_tcga_pub"

  conditionalPanel("input.tabs_Enrichment == 'Circomics'",
                   wellPanel(
                     selectizeInput('StudiesIDCircos', 'Studies in Wheel', choices=NULL, multiple = TRUE),
                      conditionalPanel(condition = "input.StudiesIDCircos == null",
                                       p("Select at less two studies",align="center",style = "color:red")
                                       ),
                  # if(length(input$StudiesIDCircos)==1){
                     div(class="row",
                         div(class="col-xs-4",
                             conditionalPanel(condition = "input.StudiesIDCircos != null",
                             checkboxInput("ViewProfDataCircosID", "Availability", value = FALSE))
                             ),
                         div(class="col-xs-8",
                             conditionalPanel(condition = "input.pullUserDataButtonId==true",
                                              p("+ User data",align="center", style = "color:blue")
                             )
                         )
                     ),
                      div(class="row",
                         div(class="col-xs-3",
                             conditionalPanel(condition = "input.StudiesIDCircos != null",
                            checkboxInput("loadListProfDataCircosId", "Load", value = FALSE))
                            ),
                         # div(class="col-xs-3",
                         # conditionalPanel(condition = "input.StudiesIDCircos != null",
                         #   actionButton('loadListProfDataCircosId', 'Load')
                         # )
                         #   ),
                         div(class="col-xs-8",
                             conditionalPanel(condition= 'input.loadListProfDataCircosId == true',
                                              actionButton('pushListProfData', 'Push for Processing',
                                                           icon("arrow-up")
                                                           )
                             ))

                     )
                   #}
                     ),

                   wellPanel(
                     h4("Pull from Processing Panel:"),
                     div(class="row",
                         div(class="col-xs-3",
                             checkboxInput('UserDataCNAID', 'CNA', FALSE)),
                         div(class="col-xs-3",
                             checkboxInput('UserDatamRNAID', 'mRNA', FALSE)),
                         div(class="col-xs-2",
                             checkboxInput('UserDataFreqMutID', 'Mut', FALSE)),

                         div(class="col-xs-2",
                             checkboxInput('UserDataMet27ID', 'Met27', FALSE))
                     ),
                     div(class="row",
                         div(class="col-xs-4",
                             checkboxInput('UserDataMet450ID', 'Met450', FALSE)),
                         div(class="col-xs-4",
                             checkboxInput('UserDatamiRNAID', 'miRNA', FALSE)),
                         div(class="col-xs-4",
                             checkboxInput('UserDataRPPAID', 'RPPA', FALSE))
                     ),

                     conditionalPanel(condition="input.UserDataCNAID==true",
                                      uiOutput("uiPullUserDataCNA")

                     ),
                     conditionalPanel(condition="input.UserDatamRNAID==true",
                                      uiOutput("uiPullUserDatamRNA")
                     ),
                     conditionalPanel(condition="input.UserDataMet27ID==true",
                                      uiOutput("uiPullUserDataMetHM27")
                     ),
                     conditionalPanel(condition="input.UserDataMet450ID==true",
                                      uiOutput("uiPullUserDataMetHM450")
                     ),
                     conditionalPanel(condition="input.UserDataFreqMutID==true",
                                      uiOutput("uiPullUserDataFreqMut")
                     ),
                     conditionalPanel(condition="input.UserDatamiRNAID==true",
                                      uiOutput("uiPullUserDatamiRNA")
                     ),

                     conditionalPanel(condition="input.UserDataRPPAID==true",
                                      uiOutput("uiPullUserDataRPPA")
                     ),
                     # if(input$UserDataCNAID ||
                     #   input$UserDatamRNAID ||
                     #   input$UserDataMetHM27ID ||
                     #   input$UserDataMetHM450ID ||
                     #   input.UserDataFreqMutID ||
                     #   input.UserDatamiRNAID||
                     #  input$UserDataRPPAID){
                                      div(class="row",
                                          div(class="col-xs-6",
                                              actionButton('pullUserDataButtonId', 'Add to wheel', icon('arrow-down'))),
                                          div(class="col-xs-6",
                                              #checkboxInput("getlistProfDataCircosID", "Load", value = FALSE))
                                              actionButton('UnpullUserDataButtonId', 'Remove')
                                          )
                                          #checkboxInput('confirmPullUserDataID', 'Confirm Pull', FALSE)
                                      )
                    # }
                   ),


                   conditionalPanel(condition= 'input.loadListProfDataCircosId == true',
                                    uiOutput("ui_CircosDimension")
                                    #uiOutput("ui_SaveCircos")
                   ),

                   #                    conditionalPanel("input.CircosDimensionID == 'All'",
                   #                                     #plot_downloader("SaveMetabologram_All", pre = ""),
                   #                                     downloadButton('Save_Metabologram_All', 'All')
                   #
                   #                    ),

                   checkboxInput("CircosLegendID", "Legend", value=FALSE),
                   #                    radioButtons(inputId = "WheelID", label = "Wheel Style:",
                   #                                 c("Summary"="init" ,"Zoom" = "Zoom",  "Static" = "Static"),
                   #                                 selected = "", inline = TRUE),

                   #                    radioButtons(inputId = "saveWheelID", label = "Save Wheel:",
                   #                                 c("SVG" = "SVG", "Gif" = "Gif"),
                   #                                 selected = "SVG", inline = TRUE),
                   #
                   #                    conditionalPanel(condition = "input.saveWheelID == 'SVG'",
                   #                                     downloadButton('SaveSVG', 'SVG')),
                   #
                   #                    conditionalPanel(condition = "input.saveWheelID == 'Gif'",
                   #                                     downloadButton("SaveGif")),

                   conditionalPanel("input.CircosLegendID==true",
                                    wellPanel(
                                      plotOutput("LegendCircos")
                                    )
                                    #                    h4("Wheel Legend"),
                                    #                    p(span("Black", style="color:black"),": Non available data."),
                                    #                    p(span("White", style="color:black"),": Non significant rate."),
                                    #                    p(span("Cyan", style="color:deepskyblue"),": Middle Negative significant rate."),
                                    #                    p(span("Blue", style="color:blue"),": Negative significant rate."),
                                    #                    p(span("Yellow", style="color:gold"),": Middle Positive significant rate."),
                                    #                    p(span("Red", style="color:red"),": Positive significant rate.")
                   ),

                   help_modal_km('Circomics','CircomicsHelp',inclMD(file.path(r_path,"base/tools/help/Circomics.md")))
  )

})

## Load Profile data in datasets to Processing panel
observe({
  if (not_pressed(input$pushListProfData)) return()
  isolate({

    loadInDatasets(fname="xCNA", header=TRUE)
    loadInDatasets(fname="xmRNA", header=TRUE)
    loadInDatasets(fname="xMetHM450", header=TRUE)
    loadInDatasets(fname="xMetHM27", header=TRUE)
    loadInDatasets(fname="xMut", header=TRUE)
    loadInDatasets(fname="xFreqMut", header=TRUE)
    loadInDatasets(fname="xmiRNA", header=TRUE)
    loadInDatasets(fname="xRPPA", header=TRUE)

    #### Updating datasets generate error with vars view tab
    # sorting files alphabetically
    #r_data[['datasetlist']] <- sort(r_data[['datasetlist']])
    #updateSelectInput(session, "dataset", label = "Datasets:",
     #                 choices = r_data$datasetlist,
      #                selected = "")

  })
})

# observe({
#
#   if (not_pressed(input$SaveSVG)) return()
#   isolate({
#     library(metabologram)
#     CoffeewheelTreeData <- reStrDimension(r_data$ListProfData)
#     metabologram(CoffeewheelTreeData, width=500, height=500, main="metabologram", showLegend = TRUE, fontSize = 12, legendBreaks=c("NA","Min","Negative", "0", "Positive", "Max"), legendColors=c("black","blue","cyan","white","yellow","red") , legendText="Legend")
#
#   })
# })


#
# output$SaveGif = downloadHandler(
#   filename = function(){'random.png'},
#   content  = function(file){
#     CoffeewheelTreeData <- reStrDimension(r_data$ListProfData)
#     ggsave(file,metabologram(CoffeewheelTreeData, width=500, height=500, main="metabologram", showLegend = TRUE, fontSize = 12, legendBreaks=c("NA","Min","Negative", "0", "Positive", "Max"), legendColors=c("black","blue","cyan","white","yellow","red") , legendText="Legend"))
#     #file.rename('random.gif', file)
# }
#     )

