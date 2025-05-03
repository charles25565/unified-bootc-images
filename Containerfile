FROM quay.io/centos-bootc/centos-bootc:stream10 AS builder
RUN rm -rf /etc/yum.repos.d
COPY ${REPO} /etc/yum.repos.d/${REPO}
RUN for exclude in ${EXCLUDES}; do find /usr/share/doc/bootc-base-imagectl/manifests -iname '*.yaml' | xargs sed -i "s@- ${exclude}@@g"; done 
RUN /usr/libexec/bootc-base-imagectl build-rootfs --manifest=standard /out
FROM scratch AS default
COPY --from=builder /out /
LABEL containers.bootc 1
LABEL ostree.bootable true
LABEL bootc.diskimage-builder quay.io/centos-bootc/bootc-image-builder
ENV container=oci
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
