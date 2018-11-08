## Synopsis

le workflow suivant illustre comment passer des paramètre dans le pipeline

### En utilisant les paramètres par défaut 

```
$ more workflow.nf 
params.salutation  = "Hello"
params.name  = "world"
(...)

../bin/nextflow run workflow.nf 
```

### En spécifiant les paramètres sur la ligne de commande

```
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
```

### En utilisant un fichier de configuration

```
$ more my.config 
params.salutation  = "Hola"
params.name  = "Muchachos"

../bin/nextflow run -config my.config workflow.nf  
```


## nextflow

### ./workflow.nf

```groovy
  1   params.salutation  = "Hello"
  2   params.name  = "world"
  3   
  4   println("${params.salutation} ${params.name}!")
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [nostalgic_poitras] - revision: a51114ae25
Hello world!
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [gigantic_wilson] - revision: a51114ae25
Bonjour Monde!
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [mad_bartik] - revision: a51114ae25
Hola Muchachos!
```


## Files

```
```


