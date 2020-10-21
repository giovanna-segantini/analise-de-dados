rm(list = ls () )

my.pkgs <- c("BatchGetSymbols", "Quandl", "BETS",
              "rbcb","GetDFPData",
              "GetHFData", "GetTDData")

install.packages(my.pkgs)


#BatchGetSymbols

library(BatchGetSymbols)
library(dplyr)

help(package = BatchGetSymbols )

my.tickers <- c("PETR4.SA", "CIEL3.SA",
                "GGBR4.SA", "GOAU4.SA")

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