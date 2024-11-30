library(shiny)
library(bslib)
library(lubridate)

# Charger le fichier de textes
source("adventCaseText.R")

# Fonction pour obtenir les chemins des images pour chaque jour
get_case_images <- function(day) {
  case_pattern <- paste0("case", day, "(_\\d+)?\\.(jpeg|jpg|png|webp)$")
  case_files <- list.files("ADVENTCASEIMG", pattern = case_pattern, full.names = TRUE)
  return(case_files)
}

# Fonction pour obtenir le texte d'une case
get_case_text <- function(day) {
  text_var <- get(paste0("case", day))
  return(text_var)
}

ui <- page_fluid(
  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
    tags$style(HTML("
      body {
        background-image: url('https://img.freepik.com/free-photo/christmas-background-with-bokeh-lights-snowflakes_1048-11456.jpg');
        background-size: cover;
        background-attachment: fixed;
        background-position: center;
        min-height: 100vh;
      }
      .content-wrapper {
        background-color: rgba(255, 255, 255, 0.8);
        border-radius: 15px;
        padding: 20px;
        margin: 20px auto;
        max-width: 1200px;
        box-shadow: 0 0 20px rgba(255, 215, 0, 0.3);
      }
      .title {
        color: #d42426;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        font-weight: bold;
        font-size: calc(1.5rem + 1.5vw);
      }
      .btn {
        font-weight: bold;
        background: linear-gradient(135deg, #d42426 50%, #b41e20 50%) !important;
        border: 2px solid #ffffff !important;
        color: #ffffff !important;
        transition: all 0.3s ease;
        font-size: calc(1.2rem + 0.5vw);
        min-height: 60px;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        z-index: 1;
      }

      .btn::before {
        content: '';
        position: absolute;
        width: 200%;
        height: 30px;
        transform: rotate(-45deg);
        top: 50%;
        left: -50%;
        background: linear-gradient(45deg, 
          transparent 0%, 
          transparent 35%, 
          rgba(255, 235, 59, 0.5) 35%,
          rgba(255, 235, 59, 0.5) 65%,
          transparent 65%, 
          transparent 100%
        );
        z-index: 0;
      }

      .btn::after {
        content: '';
        position: absolute;
        width: 30px;
        height: 200%;
        transform: rotate(-45deg);
        top: -50%;
        left: 50%;
        margin-left: -15px;
        background: linear-gradient(45deg, 
          transparent 0%, 
          transparent 35%, 
          rgba(255, 235, 59, 0.5) 35%,
          rgba(255, 235, 59, 0.5) 65%,
          transparent 65%, 
          transparent 100%
        );
        z-index: 0;
      }

      .btn:not([disabled]):hover {
        transform: scale(1.05) rotate(-2deg);
        box-shadow: 0 8px 16px rgba(0,0,0,0.3);
        animation: wiggle 0.5s ease;
      }

      @keyframes wiggle {
        0% { transform: rotate(-2deg) scale(1.05); }
        25% { transform: rotate(2deg) scale(1.05); }
        50% { transform: rotate(-2deg) scale(1.05); }
        75% { transform: rotate(2deg) scale(1.05); }
        100% { transform: rotate(-2deg) scale(1.05); }
      }

      .btn[disabled] {
        background: linear-gradient(135deg, #888888 50%, #777777 50%) !important;
        opacity: 0.7 !important;
      }
      
      .modal-dialog {
        max-width: 500px;
        margin: 1.75rem auto;
      }
      .modal-content {
        background: rgba(255, 255, 255, 0.95);
        border: 3px solid #d42426;
        box-shadow: 0 0 30px rgba(0, 0, 0, 0.3);
        max-height: 90vh;
        display: flex;
        flex-direction: column;
      }
      .modal-header {
        background: #d42426;
        color: white;
        border-bottom: none;
        padding: 0.5rem 1rem;
      }
      .modal-body {
        text-align: center;
        padding: 15px;
        max-height: calc(90vh - 120px);
        overflow-y: auto;
        flex: 1;
      }
      .case-image-wrapper {
        margin-bottom: 8px;
        text-align: center;
      }
      .case-image {
        max-width: 50%;
        max-height: 200px;
        margin: 0 auto;
        display: block;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0,0,0,0.2);
        object-fit: contain;
      }
      .shiny-image-output {
        height: auto !important;
        max-height: 200px !important;
      }
      .case-text {
        margin-bottom: 15px;
        padding: 12px;
        background-color: rgba(255, 255, 255, 0.9);
        border-radius: 10px;
        text-align: left;
        font-size: 1em;
        line-height: 1.5;
        box-shadow: 0 0 10px rgba(0,0,0,0.2);
      }
      .modal-footer {
        background: #d42426;
        border-top: none;
        padding: 0.5rem;
      }
      @media (max-width: 576px) {
        .content-wrapper {
          margin: 10px;
          padding: 10px;
        }
        .btn {
          padding: 15px !important;
        }
        .modal-dialog {
          margin: 10px;
          max-width: 95%;
        }
        .case-image {
          max-width: 90%;
        }
      }
    "))
  ),
  
  div(
    class = "content-wrapper",
    h1("Calendrier de l'Avent", class = "text-center my-4 title"),
    
    div(
      class = "container",
      div(
        class = "row justify-content-center",
        uiOutput("calendar_grid")
      )
    )
  )
)

server <- function(input, output, session) {
  shuffled_days <- sample(1:24)
  
  output$calendar_grid <- renderUI({
    current_date <- as.numeric(day(Sys.Date()))
    current_month <- month(Sys.Date())
    
    grid_elements <- lapply(1:24, function(pos) {
      day_num <- shuffled_days[pos]
      can_open <- current_date >= day_num & current_month == 12
      btn_id <- paste0("day_", day_num)
      div(
        class = "col-6 col-sm-4 col-md-3 col-lg-2 p-2",
        actionButton(
          btn_id,
          day_num,
          class = "btn w-100 h-100",
          disabled = !can_open
        )
      )
    })
    
    do.call(tagList, grid_elements)
  })
  
  observe({
    lapply(1:24, function(day) {
      local({
        day_local <- day
        
        output[[paste0("case_content_", day_local)]] <- renderUI({
          images <- get_case_images(day_local)
          
          tagList(
            # Texte en premier
            div(
              class = "case-text",
              textOutput(paste0("text_", day_local))
            ),
            # Images ensuite
            lapply(seq_along(images), function(i) {
              div(
                class = "case-image-wrapper",
                imageOutput(paste0("image_", day_local, "_", i),height = "auto")
              )
            })
          )
        })
        
        images <- get_case_images(day_local)
        lapply(seq_along(images), function(i) {
          local({
            image_index <- i
            output[[paste0("image_", day_local, "_", image_index)]] <- renderImage({
              list(
                src = images[image_index],
                contentType = "image/jpeg",
                width = "80%",
                height = "auto",
                class = "case-image",
                alt = paste("Image du jour", day_local)
              )
            }, deleteFile = FALSE)
          })
        })
        
        output[[paste0("text_", day_local)]] <- renderText({
          get_case_text(day_local)
        })
        
        observeEvent(input[[paste0("day_", day_local)]], {
          showModal(modalDialog(
            title = paste("Jour", day_local),
            uiOutput(paste0("case_content_", day_local)),
            size = "l",
            easyClose = TRUE,
            footer = modalButton("Fermer")
          ))
        })
      })
    })
  })
}

shinyApp(ui = ui, server = server)
