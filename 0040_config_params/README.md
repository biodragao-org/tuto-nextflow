## nextflow

### ./workflow.nf

```groovy
params.salutation  = "Hello"
params.name  = "world"

println "${params.salutation} ${params.name}!"
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [clever_descartes] - revision: 65a92cdec3
Hello world!
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [modest_shirley] - revision: 65a92cdec3
Bonjour Monde!
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [gloomy_noyce] - revision: 65a92cdec3
Hola Muchachos!
```


## Files

```
```


