# Docker build agent

A Docker build agent for working with NodeJS and Docker (e.g. Node code that you'll want to deploy into a Docker container itself).

## Usage

```
pipeline {
    agent {
        docker { 
	    image 'anotherdave/docker-jenkins-node-alpine:0.0.1'
	    args '-v /var/run/docker.sock:/var/run/docker.sock -u root:root'
	}
    }
    environment {
        HOME = '.'
    }
    stages {
        stage('...') {
            steps {
		/* Can run Node steps as well as Docker build */	
	    }
	}
    }
}
```

## References

* https://getintodevops.com/blog/the-simple-way-to-run-docker-in-docker-for-ci
