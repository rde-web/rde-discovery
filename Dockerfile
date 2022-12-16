#TODO: find or make alpine image
FROM dart:2.18.5-sdk as builder
WORKDIR /source
COPY . .
RUN apt update && apt install make
RUN make init generate build

FROM debian:bullseye
WORKDIR /app
COPY --from=builder /source/bin/rde_discovery.exe rde_discovery
COPY --from=builder /source/config.yml config.yml
ENTRYPOINT [ "./rde_discovery" ]