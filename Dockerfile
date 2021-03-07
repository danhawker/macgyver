# Use the UBI8 minimal image as base
FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV OC_DOWNLOAD https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz

# Install a couple of common file and network utils
RUN microdnf install tar jq ethtool iputils iproute --nodocs ;\
    microdnf clean all

# Add `oc` and `kubectl` client tools
RUN curl -SL "$OC_DOWNLOAD" \
  | tar -zxv -C /usr/bin

# Create a dir to hold any configs mounted within the container
RUN mkdir -p /macgyver/etc

WORKDIR /macgyver

# Add macgyver.sh
COPY macgyver.sh macgyver.sh

#CMD ["/bin/bash"]
ENTRYPOINT ["/macgyver/macgyver.sh"]

LABEL \
        name="quay.io/danhawker/macgyver" \
        maintainer="Dan Hawker <https://github.com/danhawker>" \
        vendor="Dan Hawker <https://github.com/danhawker" \
        url="https://github.com/danhawker/macgyver" \
        description="What would MacGyver Do? Contains network configuration and diagnostic tools to help to fix stuff" \
        io.k8s.display-name="MacGyver" \
        io.k8s.description="What would MacGyver Do? Contains network configuration and diagnostic tools to help to fix stuff" \
        io.openshift.tags="openshift,tools" \
        license="Apache-2.0" \
        version="v0.1"

# EOF