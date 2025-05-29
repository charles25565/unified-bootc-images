FROM quay.io/centos-bootc/centos-bootc:stream10 AS builder
RUN rm -rf /etc/yum.repos.d/*
ARG repo
COPY ${repo} /etc/yum.repos.d/
ARG excludes
RUN for exclude in ${excludes}; do find /usr/share/doc/bootc-base-imagectl/manifests \( -iname '*.yaml' -o -iname '*.yml' \) | xargs sed -i "/- ${exclude}/d"; done 
RUN /usr/libexec/bootc-base-imagectl build-rootfs --manifest=standard /out
FROM scratch AS default
COPY --from=builder /out/ /
LABEL containers.bootc 1
LABEL ostree.bootable 1
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
