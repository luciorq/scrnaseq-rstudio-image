@default:
  just --choose

@build:
  #!/usr/bin/env -vS bash -i
  \builtin set -euxo pipefail;
  docker buildx build --platform=linux/amd64 --build-arg R_VERSION='4.4.3' --network=host --no-cache -t rstudio-scrnaseq:latest -f ./Dockerfile .;
