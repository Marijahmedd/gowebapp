FROM golang:1.22.3 AS builder

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .  

#creating a statically linked binary to be used with static distroless image
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o goweb .

FROM gcr.io/distroless/static-debian11

COPY --from=builder /app/goweb .

COPY --from=builder /app/static ./static


CMD [ "./goweb" ]


