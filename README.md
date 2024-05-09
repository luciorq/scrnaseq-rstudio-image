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
docker run -d --restart=always --platform=linux/amd64 -p 8989:8989 --name scrnaseq-env rstudio-scrnaseq:latest;
```

## Notes - Creating Users

This image don't create users automatically, but we provide a script that allows user creation.


```bash
user_list_var=(usuario01 usuario02 usuario03 usuario04)

function create_user_in_container () {
  local container_name;
  local user_name;
  local user_pw_str;
  local user_pw_hash;
  container_name="${1:-scrnaseq-env}";
  user_name="${2:-bioinfo}";
  user_pw_str="${3:-}";
  if [[ -z ${user_pw_str} ]]; then
    builtin echo -ne 'Error: PW can not be an empty string.\n';
    builtin return 1;
  fi
  # user_pw_has="$(mkpasswd -m sha-512 "${user_pw_str}")";
  \docker exec "${container_name}" useradd -m -s /bin/bash -d "/home/${user_name}" -p "${user_pw_hash}" --user-group "${user_name}";
}


for i in "${user_list_var[@]}"; do
  user_name="${i}";
  user_pw_str="$(\gopass pwgen --one-per-line --ambiguous 24 | head -1)";
  user_pw_hash="$(\mkpasswd -m sha-512 "${user_pw_str}")";
  create_user_in_container scrnaseq-env "${i}" "${user_pw_hash}";
  builtin echo "User: ${user_name} -> Password: ${user_pw_str}";
done
```

Access the container using: <http://URL:8989>
