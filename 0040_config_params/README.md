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
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [zen_goldstine] - revision: 65a92cdec3
Hello world!
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [evil_hypatia] - revision: 65a92cdec3
Bonjour Monde!
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [sad_elion] - revision: 65a92cdec3
Hola Muchachos!
```


## Files

```
```


