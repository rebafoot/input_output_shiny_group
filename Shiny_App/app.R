#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
# Find out more about building applications with Shiny here:
#    http://shiny.rstudio.com/

library(readxl)
library(readr)
library(tidyr)
library(utils) 
library(dplyr)
library(shiny)
library(DT) 
library(visdat)
library(ggplot2)
library(ggthemes)
library(rpart)
library(ggbeeswarm)
library(plotly)
library(colourpicker)
library(rpart.plot)
library(party)
library(randomForest)
library(tibble)
library(glmnet)
library(knitr)
library(broom)
library(ggfortify)
library(stats)

source("helper.R")
source("Group2Functions.R")
source("Group3Functions.R")

# Define UI for application 
ui <- fluidPage(
  
  titlePanel("Mycobacteria Research Laboratories"),
  helpText("Upload Data and Explore Data Tables and Graphs Using the Tabs Below"),
  
  sidebarLayout(
    sidebarPanel(width = 3, (label = h3("Upload Data")),
                 
                 fileInput(label = "Efficacy", inputId = "efficacy",
                           buttonLabel = "Efficacy Data", multiple = TRUE, accept = ".xlsx"),
                 fileInput(label = "Plasma", inputId = "plasma", 
                           buttonLabel = "Plasma Data", multiple = TRUE, accept = ".xlsx"),
                 fileInput(label = "Tissue Laser", inputId = "tissue_laser", 
                           buttonLabel = "Tissue Laser Data", multiple = TRUE, accept = ".xlsx"),
                 fileInput(label = "Tissue Std PK", inputId = "tissue_std_pk", 
                           buttonLabel = "Tissue Std PK Data", multiple = TRUE, accept = ".xlsx")
                  ),
    
    mainPanel(width = 8,
      tabsetPanel(type = "tabs",
                  tabPanel("Raw Data Sets", 
                           tabsetPanel(type = "tabs",
                             tabPanel("Efficacy",
                                DT::dataTableOutput("raw_efficacy_table")
                                ),
                             tabPanel("Plasma",
                                DT::dataTableOutput("raw_plasma_table")
                                ),
                             tabPanel("Tissue Laser",
                                DT::dataTableOutput("raw_tissue_laser_table")
                                ),
                             tabPanel("Tissue Std PK",
                                DT::dataTableOutput("raw_tissue_std_pk_table")
                                )
                                )
                                ),
                           
                  tabPanel("Clean Data Set",
                           tabsetPanel(type = "tabs",
                                       tabPanel("Efficacy",
                                                DT::dataTableOutput("clean_efficacy_table")
                                                ),
                                       tabPanel("Plasma",
                                                DT::dataTableOutput("clean_plasma_table")
                                                ),
                                       tabPanel("Tissue Laser",
                                                DT::dataTableOutput("clean_tissue_laser_table")
                                                ),
                                       tabPanel("Tissue Std PK",
                                                DT::dataTableOutput("clean_tissue_std_pk_table")
                                                ),
                                       tabPanel("Efficacy Summary",
                                                helpText("Used for In Vitro & In Vivo Plots in 'Independent' Tab"),
                                                DT::dataTableOutput("clean_efficacy_summary_table")
                                               )
                                           )
                                           ),
                           
                  tabPanel("Summary of Clean  Data", 
                           tabsetPanel(type = "tabs",
                                       tabPanel("Efficacy",
                                                plotOutput("summary_efficacy_plot")
                                                ),
                                       tabPanel("Plasma",
                                                plotOutput("summary_plasma_plot")
                                                ),
                                       tabPanel("Tissue Laser",
                                                plotOutput("summary_tissue_laser_plot")
                                                ),
                                       tabPanel("Tissue Std PK",
                                                plotOutput("summary_tissue_std_pk_plot")
                                                ),
                                       tabPanel("Efficacy Summary",
                                                plotOutput("summary_efficacy_summary_plot")
                                        )
                                        )
                                        ),
                  
                  tabPanel("Independent", 
                           tabsetPanel(type = "tabs",
                                       tabPanel("In Vitro", width = 2,
                                                helpText("Select and Deselect to Explore Efficacy Summary Data"),
                                checkboxGroupInput("CheckBeeVarInVitro",
                                label = h3("Check Variables To Explore"), 
                                choices = list("Caseum_binding" = Caseum_binding, 
                                               "cLogP" = cLogP,
                                               "huPPB" = huPPB,
                                               "muPPB" = muPPB,
                                               "MIC_Erdman" = MIC_Erdman,
                                               "MICserumErd" = MICserumErd,
                                               "MIC_Rv" = MIC_Rv,
                                               "MacUptake" = MacUptake),
                                selected = c("Caseum_binding" = Caseum_binding, 
                                              "cLogP" = cLogP,
                                              "huPPB" = huPPB,
                                              "muPPB" = muPPB,
                                              "MIC_Erdman" = MIC_Erdman,
                                              "MICserumErd" = MICserumErd,
                                              "MIC_Rv" = MIC_Rv,
                                              "MacUptake" = MacUptake)
                                  ),
                                checkboxGroupInput("CheckBeeDrugInVitro", 
                                 label = h3("Check Drugs To Explore"), 
                                 choices = list("DRUG1" = DRUG1, "DRUG2" = DRUG2, 
                                                "DRUG3" = DRUG3,
                                 "DRUG4" = DRUG4, "DRUG5" = DRUG5, "DRUG6" = DRUG6,
                                 "DRUG7" = DRUG7, "DRUG8" = DRUG8, "DRUG9" = DRUG9,
                                 "DRUG10" = DRUG10, "DRUG11" = DRUG11),
                                 selected = c("DRUG1" = DRUG1, "DRUG2" = DRUG2, 
                                             "DRUG3" = DRUG3,
                                             "DRUG4" = DRUG4, "DRUG5" = DRUG5, "DRUG6" = DRUG6,
                                             "DRUG7" = DRUG7, "DRUG8" = DRUG8, "DRUG9" = DRUG9,
                                             "DRUG10" = DRUG10, "DRUG11" = DRUG11)
                                 ),
                                 plotlyOutput("beeswarm_invitro_plot", width = "auto", height = "auto")
                                 ),
                                       tabPanel("In Vivo", width = 3,
                                                helpText("Select and Deselect to Explore Efficacy Summary Data"),
                                                checkboxGroupInput("CheckBeeVarInVivo",
                                                                   label = h3("Check Variables To Explore"), 
                                                                   choices = list("RIM" = RIM, 
                                                                                  "OCS" = OCS,
                                                                                  "ICS" = ICS,
                                                                                  "ULU" = ULU,
                                                                                  "SLU" = SLU,
                                                                                  "SLE" = SLE,
                                                                                  "PLA" = PLA),
                                                                   selected = c("RIM" = RIM,
                                                                                "OCS" = OCS, 
                                                                                 "ICS" = ICS,
                                                                                 "ULU" = ULU,
                                                                                 "SLU" = SLU,
                                                                                 "SLE" = SLE,
                                                                                 "PLA" = PLA)
                                                                                ),
                                                checkboxGroupInput("CheckBeeDrugInVivo", 
                                                                   label = h3("Check Drugs To Explore"), 
                                                                   choices = list("DRUG1" = DRUG1, "DRUG2" = DRUG2, 
                                                                                  "DRUG3" = DRUG3,
                                                                                  "DRUG4" = DRUG4, "DRUG5" = DRUG5, "DRUG6" = DRUG6,
                                                                                  "DRUG7" = DRUG7, "DRUG8" = DRUG8, "DRUG9" = DRUG9,
                                                                                  "DRUG10" = DRUG10, "DRUG11" = DRUG11),
                                                                   selected = c("DRUG1" = DRUG1, "DRUG2" = DRUG2, 
                                                                                "DRUG3" = DRUG3,
                                                                                "DRUG4" = DRUG4, "DRUG5" = DRUG5, "DRUG6" = DRUG6,
                                                                                "DRUG7" = DRUG7, "DRUG8" = DRUG8, "DRUG9" = DRUG9,
                                                                                "DRUG10" = DRUG10, "DRUG11" = DRUG11)
                                                ),
                                                plotlyOutput("beeswarm_invivo_plot", width = "auto", height = "auto")
                                                ),
                                       tabPanel("Plot2"),
                                       tabPanel("Plot3")
                                )
                                ),
                  
                  tabPanel("Independent ~ Dependent", 
                           tabsetPanel(type = "tabs",
                                       tabPanel("Regression Trees",
                                                radioButtons("regression", label = "Pick a Variable",
                                                             choices = list("Lung Efficacy" = ELU,
                                                                         "Spleen Efficacy" = ESP)
                                                             ),
                                                numericInput("min_split", label = h3("Minimum Split for Regression Tree"), value = 1, min = 0),
                                                numericInput("min_bucket", label = h3("Minimum Buckets for Regression Tree"), value = 1, min = 0),
                                                plotOutput("regression_tree")
                                                ),
                                       tabPanel("Best Variables",
                                                radioButtons("variable", label = "Pick a Variable",
                                                             choices = list("Lung Efficacy" = ELU,
                                                                            "Spleen Efficacy" = ESP)),
                                                plotlyOutput("best_variables")),
                                       tabPanel("KateScatter"),
                                       tabPanel("KateCoefficient"),
                                       tabPanel("LASSO Model",
                                                radioButtons("variable_lasso", label = "Pick a Variable",
                                                             choices = list("Lung Efficacy" = ELU,
                                                                            "Spleen Efficacy" = ESP)),
                                                radioButtons("dosage", label = "Pick a Dosage", 
                                                             choices = list("50" = fifty,
                                                                            "100" = hundred))),
                                                verbatimTextOutput("lasso_model"))
                           )
                  )
                  )
                  )
      )



#Define server logic 
server <- function(input, output) {
  
###### CODE FOR RENDERING RAW DATA
  
# Render data table with raw efficacy data
  output$raw_efficacy_table <- DT::renderDataTable({
    efficacy_file <- input$efficacy
    
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(efficacy_file)){
      return(NULL)
    }
    
    ext <- tools::file_ext(efficacy_file$name)
    file.rename(efficacy_file$datapath, 
                paste(efficacy_file$datapath, ext, sep = "."))
    read_excel(paste(efficacy_file$datapath, ext, sep = "."), sheet = 1)
  })
  
# Render data table with raw plasma data
    output$raw_plasma_table <- DT::renderDataTable({
      plasma_file <- input$plasma
      
      # Make sure you don't show an error by trying to run code before a file's been uploaded
      if(is.null(plasma_file)){
        return(NULL)
      }
      
      ext <- tools::file_ext(plasma_file$name)
      file.rename(plasma_file$datapath, 
                  paste(plasma_file$datapath, ext, sep = "."))
      read_excel(paste(plasma_file$datapath, ext, sep = "."), sheet = 1)
      
    })
    
# Render data table for raw tissue laser data
    output$raw_tissue_laser_table <- DT::renderDataTable({
      tissue_laser_file <- input$tissue_laser
      
      # Make sure you don't show an error by trying to run code before a file's been uploaded
      if(is.null(tissue_laser_file)){
        return(NULL)
      }
      
      ext <- tools::file_ext(tissue_laser_file$name)
      file.rename(tissue_laser_file$datapath, 
                  paste(tissue_laser_file$datapath, ext, sep = "."))
      read_excel(paste(tissue_laser_file$datapath, ext, sep = "."), sheet = 1)
      
    })
    
# Render data table for raw tissue std pk data
    output$raw_tissue_std_pk_table <- DT::renderDataTable({
      tissue_std_pk_file <- input$tissue_std_pk
      
      # Make sure you don't show an error by trying to run code before a file's been uploaded
      if(is.null(tissue_std_pk_file)){
        return(NULL)
      }
      
      ext <- tools::file_ext(tissue_std_pk_file$name)
      file.rename(tissue_std_pk_file$datapath, 
                  paste(tissue_std_pk_file$datapath, ext, sep = "."))
      read_excel(paste(tissue_std_pk_file$datapath, ext, sep = "."), sheet = 1)
      
    })
    
# Render data table for raw in vitro data
    output$raw_efficacy_summary_table <- DT::renderDataTable({
      efficacy_summary_file <- input$efficacy_summary
      
      # Make sure you don't show an error by trying to run code before a file's been uploaded
      if(is.null(efficacy_summary_file)){
        return(NULL)
      }
      
      ext <- tools::file_ext(efficacy_summary_file$name)
      file.rename(efficacy_summary_file$datapath, 
                  paste(efficacy_summary_file$datapath, ext, sep = "."))
      read_excel(paste(efficacy_summary_file$datapath, ext, sep = "."), sheet = 1)
      
    })
    

######## CODE FOR RENDERING CLEAN DATA
  
# Render data table with clean efficacy data
    output$clean_efficacy_table <- DT::renderDataTable({
    efficacy_file <- input$efficacy
    
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(efficacy_file)){
      return(NULL)
    }
    
    ext <- tools::file_ext(efficacy_file$name)
    file.rename(efficacy_file$datapath, 
                paste(efficacy_file$datapath, ext, sep = "."))
    efficacy_df <- read_excel(paste(efficacy_file$datapath, ext, sep = "."), sheet = 1)
    efficacy_function(efficacy_df)
    })
  
# Render data table with clean plasma data
    output$clean_plasma_table <- DT::renderDataTable({
    plasma_file <- input$plasma
    
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(plasma_file)){
      return(NULL)
    }
    
    ext <- tools::file_ext(plasma_file$name)
    file.rename(plasma_file$datapath, 
                paste(plasma_file$datapath, ext, sep = "."))
    plasma_df <- read_excel(paste(plasma_file$datapath, ext, sep = "."), sheet = 1)
    plasma_function(plasma_df)
    }) 

# Render data table with clean tissue laser data
    output$clean_tissue_laser_table <- DT::renderDataTable({
    tissue_laser_file <- input$tissue_laser
    
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(tissue_laser_file)){
      return(NULL)
    }
    
    ext <- tools::file_ext(tissue_laser_file$name)
    file.rename(tissue_laser_file$datapath, 
                paste(tissue_laser_file$datapath, ext, sep = "."))
    tissue_laser_df <- read_excel(paste(tissue_laser_file$datapath, ext, sep = "."), sheet = 1)
    tissue_laser_function(tissue_laser_df)
    })
  
# Render data table with clean tissue std pk data
    output$clean_tissue_std_pk_table <- DT::renderDataTable({
    tissue_std_pk_file <- input$tissue_std_pk
    
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(tissue_std_pk_file)){
      return(NULL)
    }
    
    ext <- tools::file_ext(tissue_std_pk_file$name)
    file.rename(tissue_std_pk_file$datapath, 
                paste(tissue_std_pk_file$datapath, ext, sep = "."))
    tissue_std_pk_df <- read_excel(paste(tissue_std_pk_file$datapath, ext, sep = "."), sheet = 1)
    tissue_std_pk_function(tissue_std_pk_df)
    })
  
# Render data table with cleaned efficacy summary data
    output$clean_efficacy_summary_table <- DT::renderDataTable({ input$efficacy_summary_file
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(efficacy_summary_file)){
      return(NULL)
    }
      efficacy_summary_file_1 <- paste0("https://raw.githubusercontent.com/KatieKey/input_output_shiny_group/",
                                      "master/CSV_Files/efficacy_summary.csv")
      efficacy_summary_file <- read_csv(efficacy_summary_file_1)
    })
  
######## CODE FOR RENDERING VIS DATA PLOTS OF RAW DATA
  
# Render plot with summary of clean efficacy data
      output$summary_efficacy_plot <- renderPlot({
      efficacy_file <- input$efficacy
      
      # Make sure you don't show an error by trying to run code before a file's been uploaded
      if(is.null(efficacy_file)){
        return(NULL)
      }
      
      ext <- tools::file_ext(efficacy_file$name)
      file.rename(efficacy_file$datapath, 
                  paste(efficacy_file$datapath, ext, sep = "."))
      efficacy_df <- read_excel(paste(efficacy_file$datapath, ext, sep = "."), sheet = 1)
      efficacy_clean <- efficacy_function(efficacy_df)
      vis_dat(efficacy_clean)
     }) 
  
# Render plot with summary of clean plasma data  
    output$summary_plasma_plot <- renderPlot({
    plasma_file <- input$plasma
    
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(plasma_file)){
      return(NULL)
    }
    
    ext <- tools::file_ext(plasma_file$name)
    file.rename(plasma_file$datapath, 
                paste(plasma_file$datapath, ext, sep = "."))
    plasma_df <- read_excel(paste(plasma_file$datapath, ext, sep = "."), sheet = 1)
    plasma_clean <- plasma_function(plasma_df)
    vis_dat(plasma_clean)
    }) 

  
# Render plot with summary of clean tissue laser data
    output$summary_tissue_laser_plot <- renderPlot({
    tissue_laser_file <- input$tissue_laser
    
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(tissue_laser_file)){
      return(NULL)
    }
    
    ext <- tools::file_ext(tissue_laser_file$name)
    file.rename(tissue_laser_file$datapath, 
                paste(tissue_laser_file$datapath, ext, sep = "."))
    tissue_laser_df <- read_excel(paste(tissue_laser_file$datapath, ext, sep = "."), sheet = 1)
    tissue_laser_clean <- tissue_laser_function(tissue_laser_df)
    vis_dat(tissue_laser_clean)
    }) 
  
# Render plot with summary of clean tissue std pk data
    output$summary_tissue_std_pk_plot <- renderPlot({
    tissue_std_pk_file <- input$tissue_std_pk
    
    # Make sure you don't show an error by trying to run code before a file's been uploaded
    if(is.null(tissue_std_pk_file)){
      return(NULL)
    }
    
    ext <- tools::file_ext(tissue_std_pk_file$name)
    file.rename(tissue_std_pk_file$datapath, 
                paste(tissue_std_pk_file$datapath, ext, sep = "."))
    tissue_std_pk_df <- read_excel(paste(tissue_std_pk_file$datapath, ext, sep = "."), sheet = 1)
    tissue_std_pk_clean <- tissue_std_pk_function(tissue_std_pk_df)
    vis_dat(tissue_std_pk_clean)
    }) 
    
# Render plot with summary of efficacy summary data
    output$summary_efficacy_summary_plot <- renderPlot({
      
      # Make sure you don't show an error by trying to run code before a file's been uploaded
      if(is.null(efficacy_summary_file)){
        return(NULL)
      }
      
      vis_dat(efficacy_summary_file)
    }) 
  
    
#####INDEPENDENT GROUPS FUNCTIONS
    #Beeswarm In Vitro
    
    output$beeswarm_invitro_plot <- renderPlotly({
        in_vitro <- efficacy_summary_file %>%
          rename(Drugs = "drug") %>% 
          unite(dosage_interval, dosage:dose_int, sep = "")
        
        in_vitro_SM <- in_vitro %>% 
          gather(key = variable, value = value, -Drugs, -dosage_interval) %>% 
          mutate(variable_filtered = variable) %>% 
          mutate(variable = factor(variable, levels = c("Caseum_binding", "cLogP", "huPPB", "muPPB", "MIC_Erdman",
                                                        "MICserumErd", "MIC_Rv", "MacUptake"),
                                   labels = c("Caseum \nBinding", "cLogP", 
                                              "Human \nPlasma \nBinding", "Mouse \nPlasma \nBinding", 
                                              "MIC Erdman \nStrain", "MIC Erdman \nStrain \nwith Serum", "MIC Rv Strain",
                                              "Macrophage \nUptake (Ratio)"))) %>% 
          mutate(dosage_interval = factor(dosage_interval, levels = c("50BID", "100QD"))) %>% 
          filter(Drugs %in% c(input$CheckBeeDrugInVitro))
        
        if(is.null(input$CheckBeeVarInVitro)) {
          return(NULL)
        }
      
        
        if(!is.null(input$CheckBeeVarInVitro)) {
          in_vitro_SM <- in_vitro_SM %>% 
            dplyr::filter(variable_filtered %in% input$CheckBeeVarInVitro)
        }
        
        if(!is.null(input$CheckBeeDrugInVitro)) {
          in_vitro_SM <- in_vitro_SM %>%
            dplyr::filter(Drugs %in% input$CheckBeeDrugInVitro)
        }

        in_vitro_SMplot <- in_vitro_SM %>% 
          ggplot(aes(x = dosage_interval, y = value, color = Drugs)) +
          geom_beeswarm(alpha = 0.5, size = 1.5, groupOnX = FALSE) +
          labs(x = 'Dosage-Interval', y = 'Value') +
          ggtitle('In-Vitro Distribution of TB Drugs') +
          theme_few() +
          facet_wrap(~ input$CheckBeeVarInVitro, ncol = 4, scale="free")
      
        in_vitro_plotly <- ggplotly(in_vitro_SMplot)
        
        return(in_vitro_plotly)
        
})
    
### beeswarm IN VIVO plot
    
    output$beeswarm_invivo_plot <- renderPlotly({
      in_vitro <- efficacy_summary_file %>%
        rename(Drugs = "drug") %>% 
        unite(dosage_interval, dosage:dose_int, sep = "")
      
      in_vivo_SM <- in_vitro %>% 
        gather(key = variable, value = value, -Drugs, -dosage_interval) %>% 
        mutate(variable_filtered = variable) %>% 
        mutate(variable = factor(variable, levels = c("RIM", "OCS","ICS","ULU","SLU","SLE","PLA"),
                                 labels = c("Rim (of lesion)","Outer Caseum","Inner Caseum","Uninvolved Lung",
                                            "Standard Lung", "Standard Lesion", "Plasma"))) %>% 
        mutate(dosage_interval = factor(dosage_interval, levels = c("50BID", "100QD"))) %>% 
        filter(Drugs %in% c(input$CheckBeeDrugInVivo))
      
      if(is.null(input$CheckBeeVarInVivo)) {
        return(NULL)
      }
      
      
      if(!is.null(input$CheckBeeVarInVivo)) {
        in_vivo_SM <- in_vivo_SM %>% 
          dplyr::filter(variable_filtered %in% input$CheckBeeVarInVivo)
      }
      
      if(!is.null(input$CheckBeeDrugInVivo)) {
        in_vivo_SM <- in_vivo_SM %>%
          dplyr::filter(Drugs %in% input$CheckBeeDrugInVivo)
      }
      
      in_vivo_SMplot <- in_vivo_SM %>% 
        ggplot(aes(x = dosage_interval, y = value, color = Drugs)) +
        geom_beeswarm(alpha = 0.5, size = 1.5, groupOnX = FALSE) +
        labs(x = 'Dosage-Interval', y = 'Value') +
        ggtitle('In-Vivo Distribution of TB Drugs') +
        theme_few() +
        facet_wrap(~ input$CheckBeeVarInVivo, ncol = 4, scale="free")
      
      in_vivo_plotly <- ggplotly(in_vivo_SMplot)
      
      return(in_vivo_plotly)
      
    })
   

    
######INDEPENDENT DEPENDENT GROUP FUNCTIONS
    ##regression tree
    
    output$regression_tree <- renderPlot({

      if(is.null(efficacy_summary_file)){
        return(NULL)
      }
      
      if (input$regression == "ELU") {
        
        function_data <- efficacy_summary_file %>%
          filter(!is.na(ELU))
        
        tree <- rpart(ELU ~  drug + dosage + level + 
                        PLA + ULU + RIM + OCS + ICS + SLU + SLE + 
                        cLogP + huPPB + muPPB + MIC_Erdman + MICserumErd + MIC_Rv + 
                        Caseum_binding + MacUptake,
                      data = function_data, 
                      control = rpart.control(cp = -1, minsplit = input$min_split, 
                                              minbucket = input$min_bucket))
        return(rpart.plot(tree))
      }
      
      if (input$regression == "ESP") {
        
        function_data <- efficacy_summary_file %>%
          filter(!is.na(ESP))
        
        tree <- rpart(ESP ~  drug + dosage + level + 
                        PLA + ULU + RIM + OCS + ICS + SLU + SLE + 
                        cLogP + huPPB + muPPB + MIC_Erdman + MICserumErd + MIC_Rv + 
                        Caseum_binding + MacUptake,
                      data = function_data, 
                      control = rpart.control(cp = -1, minsplit = input$min_split, 
                                              minbucket = input$min_bucket))
        return(rpart.plot(tree))
      }
        
}) 
    
    
###### best variables output
    
    output$best_variables <- renderPlotly({
    
    if(input$variable == "ELU"){
      dataset <- efficacy_summary_file %>% 
        select(-ESP) %>% 
        mutate(huPPB = as.numeric(huPPB), 
               muPPB = as.numeric(muPPB), 
               dosage = as.factor(dosage), 
               dose_int = as.factor(dose_int), 
               level = as.factor(level), 
               drug = as.factor(drug))
      
      efficacy.rf <- randomForest( ELU~ ., data =dataset,
                                   na.action = na.roughfix,
                                   ntree= 1000, 
                                   importance = TRUE)
      graph <-importance(efficacy.rf, type = 1) %>% 
        as.data.frame() %>% 
        rownames_to_column() %>% 
        rename(variable = rowname, 
               mse = `%IncMSE`) 
      
      
      graph <- graph %>% 
        filter(mse > 0) %>% 
        ggplot()+
        geom_point(aes(x = mse, y = reorder(variable, mse)))+
        theme_minimal()+
        labs(y = "Variable", 
             x = "Importance") +
        ggtitle("Lung Efficacy")
      return(ggplotly(graph))
    }
    
    if (input$variable == "ESP"){
      dataset <- efficacy_summary_file %>% 
        select(-ELU) %>% 
        mutate(huPPB = as.numeric(huPPB), 
               muPPB = as.numeric(muPPB), 
               dosage = as.factor(dosage), 
               dose_int = as.factor(dose_int), 
               level = as.factor(level), 
               drug = as.factor(drug))
      
      efficacy.rf <- randomForest( ESP ~ ., data =dataset,
                                   na.action = na.roughfix,
                                   ntree= 1000, 
                                   importance = TRUE)
      
      graph <-importance(efficacy.rf, type = 1) %>% 
        as.data.frame() %>% 
        rownames_to_column() %>% 
        rename(variable = rowname, 
               mse = `%IncMSE`) 
      
      
      graph <- graph %>% 
        filter(mse > 0) %>% 
        ggplot()+
        geom_point(aes(x = mse, y = reorder(variable, mse)))+
        theme_minimal()+
        labs(y = "Variable", 
             x = "Importance") +
        ggtitle("Spleen Efficacy")
      return(ggplotly(graph))
    }
    
    })
    
##LASSO Model Output
    
    output$lasso_model <- renderPrint({
    
    if (input$dosage == "50"){
    data <- na.omit(efficacy_summary_file) %>% 
      select_if(is.numeric) %>%
      filter(dosage == 50)
    
    response <- efficacy_summary_file %>% 
      select(input$variable)
    
    predictors <- efficacy_summary_file %>%
      select(c("PLA", "ULU", "RIM", "OCS", "ICS", "SLU", "SLE", "cLogP", "huPPB", 
               "muPPB", "MIC_Erdman", 'MICserumErd', "MIC_Rv", "Caseum_binding", "MacUptake"))
    
    y <- as.numeric(unlist(response))
    x <- as.matrix(predictors)
    
    fit =  glmnet(x, y)
    #issues with this part of the code
    
    coeff <- coef(fit,s=0.1)
    coeff <- as.data.frame(as.matrix(coeff))
    
    coeff <- coeff %>% 
      filter(coeff > 0)
    return(kable(coeff))
    }
      
      if (input$dosage == "100"){
        data <- na.omit(efficacy_summary_file) %>% 
          select_if(is.numeric) %>%
          filter(dosage == 100)
        
        response <- efficacy_summary_file %>% 
          select(input$variable_lasso)
        
        predictors <- efficacy_summary_file %>%
          select(c("PLA", "ULU", "RIM", "OCS", "ICS", "SLU", "SLE", "cLogP", "huPPB", 
                   "muPPB", "MIC_Erdman", 'MICserumErd', "MIC_Rv", "Caseum_binding", "MacUptake"))
        
        y <- as.numeric(unlist(response))
        x <- as.matrix(predictors)
        
        fit = glmnet(x, y)
        ##issues with this part of the code
        
        coeff <- coef(fit,s=0.1)
        coeff <- as.data.frame(as.matrix(coeff))
        
        coeff <- coeff %>% 
          filter(coeff > 0)
        return(kable(coeff))
      }
      
    })
    
       
}



# Run the application 
shinyApp(ui = ui, server = server)



