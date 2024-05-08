# Containerized teaching environment for scRNA-Seq Analysis Workshop

This environment leverages:

- Ubuntu Server 24.04 LTS as the Base OS.
- [RStudio Server](https://posit.co/download/rstudio-server/) for remote access.
- [rig](https://github.com/r-lib/rig) for managing R installation.
- [pak](https://github.com/r-lib/pak) for R package management.

### Building container image

```bash
docker buildx build --platform=linux/amd64 --network=host -t rstudio-scrnaseq:latest -f ./Dockerfile .;
```

### Start container

```bash
docker run -d --restart=always --platform=linux/amd64 -p 8989:8989 --name <NAME> rstudio-scrnaseq:latest;
```

## Notes - Creating Users

This image don't create users automatically, but we provide a script that allows user creation.


```bash


```

Access the container using: <http://URL:8989>
