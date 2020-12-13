
# Microlearning project

## Overview

Microlearning is demo project for training purpose. The idea is to display a list of random wiki pages to the user based on a set of categories stored in a redis database.

## Microservices

- Microlearning-api
  - the public api  
- Microlearning redis
  - the database to store categories
- Microlearning web application
- Microlearning-wiki service
  - search on wikipedia a random pages with specific category. 

## Architecture

![Alt text](archi.img.jpg?raw=true "Architecture")

## How to launch

- Launch the docker-compose file
  `docker-compose -f docker-compose.yaml up`

- Add a set of categories :
  `curl --location --request POST 'localhost:8090/api/v1/microlearning/categories?name=kubernetes'`

- Open `localhost:3000` in a browser and you should see the app UI running and serving wiki pages about kubernetes.
  