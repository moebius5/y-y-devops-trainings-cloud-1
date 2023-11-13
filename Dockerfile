# Build the application from source
FROM golang:1.21 AS build-stage

WORKDIR /app

COPY catgpt/ ./
RUN ls -lha
RUN go mod download && CGO_ENABLED=0 go build -o /catgpt

# Deploy the application binary into a lean image
FROM gcr.io/distroless/static-debian12:latest-amd64 AS build-release-stage

WORKDIR /

COPY --from=build-stage /catgpt /catgpt

EXPOSE 8080 9090

USER nonroot:nonroot

ENTRYPOINT [ "/catgpt" ]