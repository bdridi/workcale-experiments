#!/bin/bash

List="Kubernetes Philosophy health covid cncf openshift spring java mars earth ecology cryptography bitcoin sport football interstellar music painting github book"
arr=($List)
for i in {1..100}
do  
 
  if (( $i % 2 )); then
    category_index=$(( $RANDOM % 19 ))
    echo "creating category ${arr[$category_index]}"
    curl --location --request POST 'api.microlearning.workcale.io/api/v1/microlearning/categories?name='${arr[$category_index]}''
  fi
  echo "Call api for the $i time"
  curl --location --request GET 'http://api.microlearning.workcale.io//api/v1/microlearning/articles' > tmp
  
done
