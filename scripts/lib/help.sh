#!/usr/bin/env bash

print_help() {
	cat <<'EOF'
Project Deploy

USAGE
  ./deploy.sh <version> <env: local|staging|production> [options]

POSITIONAL ARGUMENTS
  version                 Docker image tag to build/push/use (e.g. 1.0.0)
  env                     One of:
                            - local      : build all images with Dockerfile.dev, update .env files,
                                           bump kubernetes/deploy.yaml, kubectl apply locally
                            - staging    : build & push images (Dockerfile.staging), update .env files,
                                           bump kubernetes/deploy.yaml, kubectl apply on staging host
                            - production : build & push images (Dockerfile.prod), update .env files,
                                           (no kubernetes apply; prod deploy handled separately via systemd)

OPTIONS
  -n, --dry-run           Print what would happen without making any changes
  -h, --help, help        Show this help and exit

BEHAVIOR
  • Dockerfiles (required per app dir):
      local               -> Dockerfile.dev
      staging             -> Dockerfile.staging
      production          -> Dockerfile.prod
    The build will FAIL if the expected Dockerfile is missing.

  • Files/State changed:
      - .env / .env.*       : NEXT_PUBLIC_APP_VERSION=<version> is updated (if present)
      - kubernetes/deploy.yaml : image tags :<old> -> :<version> (local & staging only)
      - .version            : snapshot of the last run, including:
            CURRENT_VERSION=<version>
            LAST_DEPLOY_ENV=<env>
            LAST_DEPLOY_AT=<ISO8601 timestamp>
            LAST_DEPLOY_USER=<user>
            GIT_BRANCH=<branch>
            GIT_COMMIT_SHA=<short sha>
            GIT_DIRTY=0|1
            DRY_RUN=0|1

  • Remote hosts
      Staging host is hard-coded in the script.
      Production deploy rolls systemd services on remote hosts via SSH.

ENV VARS
  DRY_RUN=1                Same effect as --dry-run

EXAMPLES
  ./deploy.sh 1.0.0 local
  ./deploy.sh 1.0.0 staging
  ./deploy.sh 1.0.0 production
  ./deploy.sh --dry-run 1.0.0 staging
  DRY_RUN=1 ./deploy.sh 1.0.0 local

EXIT CODES
  0  success
  1+ failure (missing args, missing Dockerfile, command error, etc.)
EOF
}
