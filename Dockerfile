FROM alpine

RUN apk add --no-cache ansible

ENTRYPOINT [ "ash" ]
