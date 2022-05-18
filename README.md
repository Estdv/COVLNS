# COVLNS


### Programa Principal para analisis de variantes de SASR-COV-2 a partir de datos de secuenciacion generados en el Laboratorio Nacional de Salud

### Autor: Esteban Del Valle

## USAGE: 
```sh
bash COVLNS.sh [path] [mode]
```
Correr en directorio actual
```sh
bash COVLNS.sh[mode]
```


- path: Directorio en donde se encuentran los archivos fastq
- mode: [(H,h):HAVoC,(V,v):Viralflow,(G,g):Gencom] software de variantes utilizado (default: h)

##### ex: bash COVLNS.sh /home/fastqs/ h

## Modos:
- Viralflow (v): Corre en docker y usa el ambiente de pangolin
- Havoc (h): Utiliza ambientes de pangolin y havoc
- Gencom (g): Corre en ambiente principal


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
| ViralFlow | https://github.com/dezordi/ViralFlow |
| HAVoC | https://bitbucket.org/auto_cov_pipeline/havoc/src/master/] |
| Gencom | Gencom] |
| Docker | https://www.docker.com/ |
| Samtools | https://anaconda.org/bioconda/samtools |
| pdfunite | https://github.com/mtgrosser/pdfunite] |
| fastqc | https://www.bioinformatics.babraham.ac.uk/projects/fastqc/] |
| multiqc | https://multiqc.info/ |
| R | https://www.r-project.org/ |

## Nota:
Pangolin puede presentar problema. Se recomienda mantenerlo actulizado en los diferentes ambientes usando pangolin --update
