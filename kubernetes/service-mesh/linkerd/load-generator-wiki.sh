#!/bin/bash

curl --location --request POST 'api.microlearning.workcale.io/api/v1/microlearning/categories?name=linkerd'
for i in {1..100}
do
  echo "Call api for the $i time"
  curl --location --request GET 'http://api.microlearning.workcale.io//api/v1/microlearning/articles' > tmp  
done
