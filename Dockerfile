FROM ubuntu

RUN apt update && apt install -y bash curl

COPY . .

CMD bash start.sh
