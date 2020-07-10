# Official chart-testing image to get ct command
FROM quay.io/helmpack/chart-testing:v2.4.1 AS builder

RUN wget https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 && \
    chmod +x yq_linux_amd64 && \
    mv yq_linux_amd64 /usr/local/bin/yq

# Use our minideb image that is lower than chart-testing and has a bash interpreter
FROM bitnami/minideb:buster-snapshot-20200708T204754Z

RUN install_packages git

COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/ct /usr/local/bin/ct

COPY ./ct-check-category.yaml /ct-config.yaml
COPY ./category-checker.sh /category-checker.sh

ENTRYPOINT ["/category-checker.sh"]
