# rstudio

Sets up an rstudio image based on the latest ubuntu image. 

## Instructions

### Building the image
```
./dockerbuild.sh
```


### Running the image
```
./dockerrun.sh $username $host_port
```

* Username should be an existing user on the host computer. The script creates a user with the same ids in the docker container. 
* host_port should be a port number that's open on your host computer. 




