---
author: "M. Teodoro Tenango"
title: "Mapa de cualquier región del mundo con R - Parte I: El mapa base"
image: "/post/2022/map_any_region_with_ggplot2_part_I/maps_DrawingMap.png"
draft: true
date: 2022-10-08
description: "Parte I para hacer mapas de cualquier región del mundo con R utilizando las librerías ggplot2 y maps"
tags: ["R mapas", "ggplot2", "Code Visuals", "R funciones"]
categories: ["R"]
archives: ["2022"]
---

## Sobre esta entrada

Cuando nos preparamos para una entrevista de trabajo, una de las preguntas que más recomiendan preparar es "Menciona el proyecto del que estés más orgulloso?". Personalmente nunca me han hecho esa pregunta en una entrevista de trabajo pero me mantuvo pensando. Hace algunos años desarrollé el código en R para la creación de mapas de infraestructura para un proyecto de Ciencias Políticas, y puedo decir que este es uno de los proyectos de los que estoy más orgulloso. Sin embargo, también es cierto lo que comúnmente se dice entre los desarrolladores, que **a nadie le importa cómo lo hiciste**. Al usuario final solo le interesa el producto final y cómo utilizarlo, mientras que al equipo de investigación le interesa saber las posibilidades que propone.

El proyecto me enseñó tanto en términos de habilidades técnicas que he decidido compartir el **cómo** en caso de que pueda ayudar a alguien más. También es mi forma de contribuir a la comunidad de R, ya que yo mismo aprendí R y programación gracias a las amables personas que publican su experiencia en la web (y también a los que tienen la paciencia de responder preguntas en StackOverflow). Debido al acuerdo de confidencialidad con mi cliente no puedo compartir el código completo o el repositorio de Git.

Creamos mapas de datos que muestran los cambios durante un período de tiempo para diferentes países y orientados a todo tipo de ciudades. Esto básicamente significa que necesitamos **mapear cualquier región del mundo con R**. Hoy en día existen todo tipo de paquetes y técnicas para hacerlo. Compartiré la estrategia que utilicé con [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html) y [maps](https://cran.r-project.org /web/packages/maps/index.html), utilizando el soporte de [Open Street Map](https://www.openstreetmap.org/) para obtener las coordenadas de las ciudades y finalmente hacerlo interactivo con [shiny](https ://shiny.rstudio.com/). El proyecto es bastante largo para una sola publicación, por lo que mi idea es dividirlo en algunas publicaciones de blog más pequeñas. La lista aún puede cambiar, pero pensé algo como esto:

1. El mapa básico
2. "Web scrapping" con nominatim de Open Street Maps
3. Mapas con ciudades
4. Mapas dinámicos en el tiempo
5. Creación de un solo script para facilitar reproducibilidad
6. Hacer que el código sea interactivo en una aplicación shiny

Espero que lo disfruten. Siéntanse libres de dejar cualquier tipo de comentario y/o preguntas al final.
