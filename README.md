# rest_API
Для запуска сервиса 
```
dotnet user-secrets init

dotnet user-secrets set MongoDbSettings:Password (ваш пароль)

docker network create rest_api_network

docker run -d --rm --name mongo -p 27017:27017 -v mongodbdata:/data/db -e MONGO_INITDB_ROOT_USERNAME=mongoadmin
-e MONGO_INITDB_ROOT_PASSWORD=104931 --network=rest_api_network mongo
docker run -it --rm -p 8080:80 -e MongoDbSettings:Host=mongo -e  MongoDbSettings:Password=(ваш пароль) --network=rest_api_network rest_api:v1
```
