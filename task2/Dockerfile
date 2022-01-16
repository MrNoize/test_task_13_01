FROM golang:1.16-alpine AS build
WORKDIR /build
COPY . .
RUN go mod download && CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags "-s -w -extldflags '-static'" -o ./go-sample-app

FROM scratch
COPY --from=build /build/go-sample-app ./go-sample-app
EXPOSE 8080
ENTRYPOINT [ "/go-sample-app" ]
