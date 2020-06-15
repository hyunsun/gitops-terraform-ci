FROM golang:1.14

RUN go get github.com/hashicorp/terraform
RUN go install github.com/hashicorp/terraform
