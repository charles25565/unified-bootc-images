# Unified bootc Images

[![CI](https://github.com/charles25565/unified-bootc-images/actions/workflows/ci.yml/badge.svg)](https://github.com/charles25565/unified-bootc-images/actions/workflows/ci.yml)

This is an innovative project that provides a generic codebase to create multiple bootc images.

> [!IMPORTANT]
> All images available here are unofficial.

## Adding a new image

1. Create a repo file for the distro that has the correct repositories.
- `BaseOS` & `AppStream` are enough.
- Do not use `$releasever`.
- Use the existing ones as an example.
2. Add your image to the matrix in the workflow file.
- As for tag, use the usual branch name of each distribution's RPM Git repos. 
    - For example, `ol10` for Oracle Linux 10, `r9` for Rocky Linux 9, `nobara-41` for Nobara 41, etc.
- You will need to configure the excludes yourself in a separate commit.

## Building

Some lengthy podman commands are used:

```bash
sudo podman build --security-opt=label=disable --cap-add=all --device /dev/fuse --build-arg=repo=repo --build-arg=excludes="excludes" -t localhost/your-bootc-image:unoptimized .
```

Some arguments you may want to change are:

* `repo`: Change it to the repo filename accessible from the build context (such as `rockylinux9.repo`)
* `excludes`: Change it to the list of excluded packages. You can find the correct ones by examining the workflow matrix. If it is missing, just leave `excludes` blank.

We also optimize the image:

```bash
sudo podman run --privileged -v /var/lib/containers:/var/lib/containers quay.io/centos-bootc/centos-bootc:stream10 /usr/libexec/bootc-base-imagectl rechunk localhost/your-bootc-image:unoptimized localhost/your-bootc-image:latest
```
