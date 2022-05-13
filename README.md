# COVLNS


## Programa Principal para analisis de variantes de SASR-COV-2 a partir de datos de secuenciacion
## generados en el Laboratorio Nacional de Salud

## Autor: Esteban Del Valle

### USAGE: 
```sh
bash COVLNS.sh [path] [mode]
```

```sh
bash COVLNS.sh[mode]
```
Corre en directorio actual

- path: Directorio en donde se encuentran los archivos fastq
- mode: [(H,h):HAVoC,(V,v):Viralflow,(G,g):Gencom] software de variantes utilizado (default: h)

#### ex: bash COVLNS.sh /home/fastqs/ h

## File list

   - grafcov.sh
   - pcsv.sh
   - plot_cov.R
   - QCsequence
   - GencomMod
   - Reference files (7)
   - ART_adapters.fa

## Requerimientos:

   | Plugin | README |
| ------ | ------ |
| ViralFlow | [https://github.com/dezordi/ViralFlow][PlDb] |
| HAVoC | [https://bitbucket.org/auto_cov_pipeline/havoc/src/master/][PlGh] |
| Gencom | [Gencom][PlGd] |
| Docker | [https://www.docker.com/][PlOd] |
| Samtools | [https://anaconda.org/bioconda/samtools][PlMe] |
| pdfunite | [https://github.com/mtgrosser/pdfunite][PlGa]
| fastqc | [https://www.bioinformatics.babraham.ac.uk/projects/fastqc/][PlMe] |
| multiqc | [https://multiqc.info/][PlGa] |
| R | [https://www.r-project.org/][PlGa] |
