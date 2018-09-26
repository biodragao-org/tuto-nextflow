#!./nextflow

params.salutation  = "Hello"
params.name  = "world"

process sayHello {
	tag "saying ${params.salutation} to ${params.name}"
	
	output:
		file("message.txt")
	script:
	
"""
#!/usr/bin/env python
x =  "${params.salutation}"
y =  "${params.name}" 
f = open("message.txt", "w") 
f.write( "%s - %s !" % (x,y) )
f.close()
"""
}
