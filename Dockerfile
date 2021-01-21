FROM        golangci/golangci-lint:v1.35.2

ENV         LINT_NAME="mittwald-golangci" \
            LINT_ID="1000" \
            GOLANGCI_ADDITIONAL_YML="/.golangci.yml" \
            YQ="/usr/bin/yq"

ENV         GOLANGCI_BASIC_YML="/home/${LINT_NAME}/.golangci.yml"

RUN         set -xe \
            && \
            groupadd --gid "${LINT_ID}" "${LINT_NAME}" \
            && \
            useradd --uid "${LINT_ID}" --gid "${LINT_NAME}" --shell /bin/bash --create-home "${LINT_NAME}"

COPY        .golangci.yml ${GOLANGCI_BASIC_YML}

# do not update this to v4 because it lacks the "merge"-command
COPY        --from=mikefarah/yq:3.4.1 /usr/bin/yq ${YQ}

COPY        bin/docker-entrypoint.sh /entrypoint.sh

USER        ${LINT_ID}:${LINT_ID}

ENTRYPOINT ["/entrypoint.sh"]
CMD        ["golangci-lint"]