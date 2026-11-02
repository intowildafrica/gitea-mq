FROM golang:1.26-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/gitea-mq ./cmd/gitea-mq

FROM alpine:3.22
RUN apk add --no-cache git ca-certificates
COPY --from=build /out/gitea-mq /bin/gitea-mq
EXPOSE 8080
ENTRYPOINT ["/bin/gitea-mq"]
