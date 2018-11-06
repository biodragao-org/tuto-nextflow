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
params.salutation  = "Hello"
params.name  = "world"

println("${params.salutation} ${params.name}!")
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [tiny_volta] - revision: a51114ae25
Hello world!
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [sick_crick] - revision: a51114ae25
Bonjour Monde!
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [intergalactic_lamport] - revision: a51114ae25
Hola Muchachos!
```


## Files

```
```


