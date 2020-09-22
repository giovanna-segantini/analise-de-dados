---
title: |
  ![](ufrn.png){height=0.5cm, width=1in} 
  \newline
  Importa��o e exporta��o de dados

author: "Giovanna Segantini"
date: "giovanna.ufrn@gmail.com"
output: beamer_presentation
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introdu��o

A primeira etapa de uma pesquisa � a importa��o de dados. 

Objetivos da aula:

- Aprender a importar e exportar dados contidos em arquivos locais

- Aprender a importar dados de forma din�mica,utilizando pacotes especializados e uma conex�o da internet. 

## Formatos de armazenamento

- Dados delimitados em texto (csv)
- Microsoft Excel (xls, xlsx);
- Arquivos nativos do R (RData e rds)
- Formato fst (fst)
- SQLite (SQLITE)
- Texto n�o estruturado (txt).

Em geral o formato mais flex�vel  e utilizado � *.csv*

## Mostrando o diret�rio de trabalho

� com base nesse diret�rio o R procura os arquivos para importar dados. 

� nesse mesmo diret�rio que o R salva arquivos. 

```{r}
my.dir <-getwd()
print(my.dir)
```

O resultado apresenta a pasta a onde os arquivos ser�o salvos e resgatados. ** O Rcloud n�o permite a mudan�a no diret�rio.** 

## Importando arquivos CSV

Os arquivos CSV s�o bastante utilizados para disponibiliza��o de dados. � um formato bem antigo e que utiliza v�rgulas para separa��o dos valores. No entanto, implementa��es mais sofisticadas utilizam aspas duplas ("") entorno do conte�do e podem ter outro tipo de separador, como o ponto e v�rgula (;).

Como sugest�o para evitar problemas, antes de prosseguir para a importa��o de dados em um arquivo .csv, deve-se abrir o arquivo em um editor de texto qualquer e verificar:

- A exist�ncia de texto antes dos dados e a necessidade de ignorar algumas linhas iniciais;

- A exist�ncia ou n�o dos nomes das colunas;

- O s�mbolo separador de colunas;

- O s�mbolo de decimal, o qual deve ser o ponto (.).


---



Um pacote bastante popular para a importa��o de arquivos CSV � o readr. Caso n�o o tenha instalado, fa�a a instala��o e carregue o mesmo utilizando:

```{r, eval = FALSE}
install.packages("readr")

library(readr)

cia_2016 <- read_delim("empresas_economatica_2016.csv", 
    ";", escape_double = FALSE, trim_ws = TRUE)

View(cia_2016)

```


---

Agora, vamos checar a classe das nossas colunas. Para isso, utilizamos a fun��o *glimpse* do pacote *dplyr*:

```{r, eval=FALSE}
#install.packages("dplyr")

library("dplyr")

# print column classes
dplyr::glimpse(cia_2016)

#ou

str(cia_2016)

```
**NOTA**: O uso da mensagem com as classes das colunas � particularmente �til quando o arquivo importado tem v�rias colunas e a defini��o manual de cada classe exige muita digita��o.

## Importando arquivos Excel (xls e xlsx)

Os principais pacotes para importar esses tipos de arquivo s�o: XLConnect (Mirai Solutions GmbH 2016), xlsx (Dragulescu 2014) e readxl (Wickham 2016a).

---

```{r, eval=FALSE}

#install.packages("readxl")

library(readxl)
# read xlsx into dataframe
my.df <- read_excel("Anexos_Balan�o_TD 
                    +- Julho 20.xls", sheet = "1.1")
View(my.df)

# glimpse contents
dplyr::glimpse(my.df)

#Ajustando a importa��o do banco de dados
my.df <- read_excel("cotacoes.xlsx", skip=1)
View(my.df)

```

Em alguns casos, o arquivo onde est�o as informa��es possui em
suas primeiras linhas instru��es para utiliza��o. Nestes casos, voc�
pode usar o argumento skip para indicar quantas linhas devem ser
puladas.

## Importando dados em outros formatos

Pode-se importar dados diretamente dos programas estat�sticos.

```{r, eval=FALSE}

#install.packages("haven")

library(haven)
Segmentao_Mercado <- read_sav("Segmentao_Mercado.sav")
View(Segmentao_Mercado)
```

## Importando dados via Pacotes

- BatchGetSymbols: Yahoo Finance e Google Finance.
- Quandl: dados da Quandl
- BETS: Funda��o Get�lio Vargas
- rbcb: acesso direto ao API do BCB
- GetDFPData: DF distribu�das pela B3 e pela CVM
- GetHFData: dados de alta frequ�ncia na B3.
- GetTDData: pre�os e retorno do Tesouro Direto

## Carregando os pacotes


```{r, eval=FALSE}

my.pkgs <- c('BatchGetSymbols', 'Quandl', 'BETS',
'rbcb','GetDFPData',
'GetHFData', 'GetTDData', 'dplyr')

install.packages(my.pkgs)
```

## BatchGetSymbols

Esse pacote faz a comunica��o do R com os dados financeiros
dispon�veis no Yahoo Finance e Google Finance.

```{r, eval=FALSE}

library(BatchGetSymbols)
library(dplyr)

help(package = BatchGetSymbols )

# set tickers
my.tickers <- c("PETR4.SA", "CIEL3.SA",
"GGBR4.SA", "GOAU4.SA")

```

---


```{r, eval=FALSE} 
# set dates and other inputs
first.date <- Sys.Date()-30
last.date <- Sys.Date()

thresh.bad.data <- 0.95 # sets percent threshold for bad

bench.ticker <- "^BVSP" # set benchmark as ibovespa

cache.folder <- "BGS_Cache" # set folder for cache


l.out <- BatchGetSymbols(tickers = my.tickers,
 first.date = first.date,
 last.date = last.date,
 bench.ticker = bench.ticker,
 thresh.bad.data = thresh.bad.data,
 cache.folder = cache.folder)

```

---

A sa�da de BatchGetSymbols � um objeto do tipo lista, semelhante
ao dataframe por�m mais flex�vel. O acesso a cada elemento de
uma lista pode ser feito pelo operador $.

```{r, eval=FALSE} 
print(l.out$df.control)
```

Objeto *df.control* mostra que todos tickers foram v�lidos, com
um total de 22 observa��es para cada ativo. Note que as datas
batem 100% com o Ibovespa.

Quanto aos dados financeiros, esses est�o contidos no elemento *df.tickers* de *l.out*:
```{r, eval = FALSE}
print(l.out$df.tickers)
```

---

Outra fun��o �til do pacote � BatchGetSymbols::GetIbovStocks, a qual importa a composi��o atual do �ndice Ibovespa diretamente do site da B3.

```{r, eval = FALSE}
# set tickers
df.ibov <- GetIbovStocks()
my.tickers <- paste0(df.ibov$tickers,'.SA')
```

Note que utilizamos a fun��o *paste0* para adicionar o texto '.SA' para cada ticker em df.ibov$tickers

```{r, eval = FALSE}

# set dates and other inputs
first.date <- Sys.Date()-30
last.date <- Sys.Date()
thresh.bad.data <- 0.95   # sets percent threshold for bad data
bench.ticker <- '^BVSP'   # set benchmark as ibovespa
cache.folder <- 'data/BGS_Cache' # set folder for cache


l.out <- BatchGetSymbols(tickers = my.tickers,
                         first.date = first.date,
                         last.date = last.date,
                         bench.ticker = bench.ticker,
                         thresh.bad.data = thresh.bad.data,
                         cache.folder = cache.folder)
```

