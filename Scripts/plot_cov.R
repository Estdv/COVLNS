library(dplyr)

# file = "/home/laboratorionacional/Desktop/TestSeqs/Fastq/430_S15_L001.results/depth.tsv"
# file = "/home/laboratorionacional/Desktop/TestSeqs/Fastq/458_S1_L001.results/depth.tsv"
#file = "/home/laboratorionacional/Desktop/TestSeqs/Fastq/1631_S13_L001.results/depth.tsv"
file = "depth.tsv"
dir = getwd()
x = sub(".*/", "", dir)
x = sub("_.*", "", x)


tabla = read.table(file)

tabla = tabla %>%
     mutate(logged = log10(tabla$V3))



med = median(tabla$logged)
mil = 1000
plot(tabla$V2, tabla$logged, 
     main = x,
     type = "l",
     col="blue",
     xlab="Posicion en el Genoma",
     ylab="Profundidad de covertura",
     #ylim = c(0,2000)
     )
polygon(tabla$V2, tabla$logged,col = "blue")
abline(h=med, col = "red")
abline(h=mil, col = "yellow")


# tabli = read.table("/home/laboratorionacional/ViralFlow/test_files/ART1.results/depth.tsv")
# mediana = median(tabli$V3)
# plot(tabli$V2, tabli$V3,
#      main = "Grafico de Covertura",
#      type = "l",
#      col="blue",
#      xlab="Posicion en el Genoma",
#      ylab="Profundidad de covertura",
#      ylim = c(0,7000),
# )
# abline(h=mediana, col = "red")
