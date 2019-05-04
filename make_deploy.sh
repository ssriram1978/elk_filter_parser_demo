#!/bin/bash

build_push_directory() {
   directory_name=$1
   tag=$2


   if [[ "$2" != "" ]]; then
        echo "docker build $directory_name -t $tag/$directory_name:latest"
        docker build $directory_name -t $tag/$directory_name:latest

        echo "docker push $tag/$directory_name:latest"
        docker push $tag/$directory_name:latest
   else
        echo "docker build $directory_name -t $directory_name:latest"
        docker build $directory_name -t $directory_name:latest
   fi

}


create_infrastructure() {
   directory_name=$1
   yaml_file=$2
   tag=$3

   if [[ "$1" == "all" ]]; then
        echo "build_push_directory plotter $tag"
        build_push_directory \
        plotter \
        $tag

        echo "docker-compose -f $2 build"
        docker-compose -f $2 build
    else
        echo "build_push_directory $tag"
        build_push_directory \
        $1 \
        $tag
    fi
}

deploy_infrastructure() {
   yaml_file=$1

    echo "chmod go-w filebeat/filebeat.docker.yml"
    chmod go-w filebeat/filebeat.docker.yml

    echo "chown root:root filebeat/filebeat.docker.yml"
   chown root:root filebeat/filebeat.docker.yml

    echo "docker stack deploy -c $1 elk_demo"
   docker stack deploy -c $1 elk_demo
}

teardown_infrastructure() {
   echo "docker stack rm elk_demo"
   docker stack rm elk_demo
}

create_deploy_infrastructure() {
   directory_name=$1
   yaml_file=$2
   tag=$3

   echo "create_infrastructure "
   create_infrastructure \
     $directory_name \
     $yaml_file \
     $tag

   echo "deploy_infrastructure"
   deploy_infrastructure \
      $yaml_file
}

case "$1" in
  build) create_infrastructure $2 $3 $4 ;;
  deploy) deploy_infrastructure $2 ;;
  build_and_deploy) create_deploy_infrastructure $2 $3 $4 ;;
  stop) teardown_infrastructure  ;;
  *) echo "usage: $0"
      echo "<build <all|directory_name> <yaml file> <tag -- optional> > |"
      echo "<deploy <yaml file> > |"
      echo "<build_and_deploy <all|directory_name> <yaml file> <tag --optional>> | "
      echo "stop"
     exit 1
     ;;
esac
