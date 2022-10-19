## Load scripts
path.wrapper <- 'C:/Users/teodorm3/Documents/Wrapper/sdap-re-wrapper/'
source(paste0(path.wrapper, 'dataTransformation/create_lab_event.R'))
source(paste0(path.wrapper, 'dataTransformation/rename_nCols.R'))
source(paste0(path.wrapper, 'filetypeMapping/GNF.R'))

## mock simple DF with as much info possible
mapping_time <- function(n.r = 5000, map.type = 'lab', ddf){
  if(missing(ddf)){
    mock.DF <- data.frame(ACCSNM = "ABC123",
                        SMPTOPID = paste0("Sample ", c(1:n.r)),
                        SAMPLE_DATA_ID = paste0("Sample ", c(1:n.r)),
                        IPACCSNM = c(NA, "Yes"),
                        SMPNAM = "Fake name",
                        LABTD = "12-11-2012",
                        LABTTM = "01-01-2001",
                        GNFTD = "12-11-2012",
                        GNFTTM = "01-01-2001")
  }
  else{
    mock.DF <- ddf
  }
  T0 <- Sys.time()
  do.call(paste('create', map.type, 'event', sep = '_'), list(mock.DF))
  Tf <- Sys.time()      
  elapsed.time <- Tf-T0
  return(elapsed.time)
}

## Check
mapping_time(n = 100*100)
mapping_time(n = 100*100, map.type = 'gnf')

iterate_mapping <- function(i = 1000,
                            n.rows = 5000,
                            ddf,
                            map.type = c('lab', 'gnf')){
  stats <- data.frame(Iterations = 0, Rows = 0, Mapping_Type = "type",
                      Tmedian = Sys.time()-Sys.time(),
                      Tmax = Sys.time()-Sys.time(),
                      Tmin = Sys.time()-Sys.time())
  if(missing(ddf)){
    n.r <- n.rows
  }
  else{
    n.r <- nrow(ddf)
  }
  for(m.type in map.type){
    print(paste0("Mapping ", m.type))
    time.vector <- c()
    for(ii in 1:i){
      if(ii %% 200 == 0) print(paste0("Iteration ", ii))
      current.time <- mapping_time(n.r = n.r, map.type = m.type, ddf)
      time.vector <- append(time.vector, current.time)
    }
    stats <- rbind(stats, c(i, n.r, m.type,
                            median(time.vector),
                            max(time.vector),
                            min(time.vector)))
  }
  return(stats[-1,])
}

## Check
n.r <- 12
mydf <- data.frame(ACCSNM = "ABC123",
                        SMPTOPID = paste0("Sample ", c(1:n.r)),
                        SAMPLE_DATA_ID = paste0("Sample ", c(1:n.r)),
                        IPACCSNM = c(NA, "Yes"),
                        SMPNAM = "Fake name",
                        LABTD = "12-11-2012",
                        LABTTM = "01-01-2001",
                        GNFTD = "12-11-2012",
                        GNFTTM = "01-01-2001")

iterate_mapping(i = 10, mydf)

## Run several sizes
## Medium sizes <- c(5000, 10000, 100000)
sizes <- c(1000000, 5000000)
final.stats <- data.frame()
#for(s in sizes){
  n.df <- data.frame(ACCSNM = "ABC123",
                        SMPTOPID = paste0("Sample ", c(1:s)),
                        SAMPLE_DATA_ID = paste0("Sample ", c(1:s)),
                        IPACCSNM = c(NA, "Yes"),
                        SMPNAM = "Fake name",
                        LABTD = "12-11-2012",
                        LABTTM = "01-01-2001",
                        GNFTD = "12-11-2012",
                        GNFTTM = "01-01-2001")
  print(paste("TABLE WITH", s, "ROWS", sep = " "))
  s.stats <- iterate_mapping(ddf = n.df)
  final.stats <- rbind(final.stats, s.stats)
#}

write.csv(final.stats, 'heavy_sizes.csv')

##medium.sizes <- final.stats
##write.csv(medium.sizes, "medium_sizes.csv")


### ------------------------------------------------------------------
### PLOTS
h <- read.csv('heavy_sizes.csv')
m <- read.csv('medium_sizes.csv')
(results <- rbind(h, m))
library(ggplot2)

##write.csv(results, 'results.csv')

ggplot(results, aes(x = Rows, color = Mapping_Type)) +
  geom_line(aes(y = Tmax), linetype = "dashed", size = 1) +
  geom_line(aes(y = Tmedian), size = 1.5) +
  geom_line(aes(y = Tmin), linetype = 'dotted', size = 1) +
  geom_vline(xintercept = 1e+06) +
  ylab("Time in Seconds")

##ggsave('plotted_results.png')

ggplot(results[results$Rows != 5e+06,], aes(x = Rows, color = Mapping_Type)) +
  geom_line(aes(y = Tmax), linetype = "dashed", size = 1) +
  geom_line(aes(y = Tmedian), size = 1.5) +
  geom_line(aes(y = Tmin), linetype = 'dotted', size = 1) +
  geom_vline(xintercept = 1e+06) +
  ylab("Time in Seconds")

##ggsave('plotted_results_1m.png')
