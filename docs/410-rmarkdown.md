
# RMarkdown

https://resources.rstudio.com/rstudio-conf-2020/one-r-markdown-document-fourteen-demosyihui-xie

https://yihui.org/en/2020/02/rstudio-conf-2020/

## html

```
  html_document:
    number_sections: true
    theme: journal
    toc: true
```

## pdf

```
  latex_document:
    extra_dependencies: [animate, coffee4]
```
## word

```
  word_document:
    reference_docx: rstudio-conf20.docx
```

## powerpoint

```
  powerpoint_presentation:
    reference_doc: rstudio-conf20.pptx
```
## ioslides

```
  # o for overview mode; w for widescreen
  ioslides_presentation: default
```

## beamer

```
  beamer_presentation:
    slide_level: 2
    theme: AnnArbor
```

## tufte

```
  tufte::tufte_html:
    tufte_variant: envisioned
```

## rolldown

```
  rolldown::scrollama_sidebar: default
```

## rticles

```
  rticles::jss_article:
    pandoc_args: [-V, documentclass=jss]
    extra_dependencies: animate
```

## flexdashboard

```
  flexdashboard::flex_dashboard: default
```
## pagedown

```
  pagedown::book_crc: default
```

## bookdown

```
  bookdown::gitbook: default
```
## learnr

```
  learnr::tutorial: default
runtime: shiny_prerendered
```
