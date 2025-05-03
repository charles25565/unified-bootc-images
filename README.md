# Unified bootc Images

This is an innovative project that provides a generic codebase to create multiple bootc images.

## Adding a new image

1. Create a repo file for the distro that has the correct repositories. For EL-like distros, `BaseOS` & `AppStream` are enough. For Fedora, the `Everything` repo is enough. Do not use minor releases. Use the existing ones as an example.
2. Add your image to the matrix in the workflow file. As for tag, use the usual branch name of each distribution's RPM Git repos. For example, `f41` for Fedora 41, `c10s` for CentOS Stream 10, `r9` for Rocky Linux 9, etc. You will need to configure the excludes yourself.

## Building

A lengthy podman command is used for this:

```bash
podman build --security-opt=label=disable --cap-add=all --device /dev/fuse --build-arg repo=repo --build-arg excludes="excludes" -t localhost/your-bootc-image .
```

Some arguments you may want to change are:

* `repo`: Change it to the repo filename accessible from the build context (such as `almalinux9.repo`)
* `excludes`: Change it to the list of excluded packages. You can find the correct ones by examining the workflow file.
