DOCKER_TAG               ?= 0.1.0-dev
DOCKER_REGISTRY          ?= hyunsunmoon
DOCKER_REPOSITORY        ?= edge-monitoring-server

## Docker labels. Only set ref and commit date if committed
DOCKER_LABEL_VCS_URL     ?= $(shell git remote get-url $(shell git remote))
DOCKER_LABEL_VCS_REF     ?= $(shell git diff-index --quiet HEAD -- && git rev-parse HEAD || echo "unknown")
DOCKER_LABEL_COMMIT_DATE ?= $(shell git diff-index --quiet HEAD -- && git show -s --format=%cd --date=iso-strict HEAD || echo "unknown" )
DOCKER_LABEL_BUILD_DATE  ?= $(shell date -u "+%Y-%m-%dT%H:%M:%SZ")

docker-build:
	docker build $(DOCKER_BUILD_ARGS) \
                --file Dockerfile.server \
		--tag ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}:${DOCKER_TAG} \
		--label "org.label-schema.schema-version=1.0" \
		--label "org.label-schema.name=${DOCKER_REPOSITORY}" \
		--label "org.label-schema.version=${VERSION}" \
		--label "org.label-schema.vcs-url=${DOCKER_LABEL_VCS_URL}" \
		--label "org.label-schema.vcs-ref=${DOCKER_LABEL_VCS_REF}" \
		--label "org.label-schema.build-date=${DOCKER_LABEL_BUILD_DATE}" \
		--label "org.opencord.vcs-commit-date=${DOCKER_LABEL_COMMIT_DATE}" \
		.;
docker-push:
	docker push ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}:${DOCKER_TAG}
