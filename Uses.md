How to use

Dev (hot reload):

docker build -t myapp:dev --target dev .
docker run -p 3000:3000 myapp:dev


Production:

docker build -t myapp:latest .
docker run -p 3000:3000 myapp:latest