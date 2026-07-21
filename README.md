# Register App: CI Repository

This repository contains the Java Maven application and its Jenkins CI pipeline.

## Responsibility

The CI pipeline validates application changes, creates a Docker image, scans it, publishes it to Docker Hub, and starts the GitOps CD job with the exact image tag.

## Project Contents

- `server/`: Java module and unit test.
- `webapp/`: WAR module containing the JSP application.
- `Dockerfile`: packages the generated WAR in Tomcat.
- `Jenkinsfile`: Jenkins CI pipeline.
- `pom.xml`: Maven parent project for both modules.

## CI Stages

1. Clean the Jenkins workspace.
2. Check out the `main` branch from GitHub.
3. Run `mvn clean package`.
4. Run `mvn test`.
5. Run SonarQube analysis.
6. Wait for the SonarQube quality gate.
7. Build `remson001/register-app-pipeline:<tag>`.
8. Scan the image with Trivy for HIGH and CRITICAL vulnerabilities.
9. Push the versioned tag and `latest` to Docker Hub.
10. Remove local Docker artifacts from the agent.
11. Trigger `gitops-register-app-cd` with `IMAGE_TAG`.

## Image Tagging

The pipeline creates tags in the form `1.0.0-<Jenkins build number>`, for example `1.0.0-55`. The versioned tag is the deployment identifier; `latest` is also pushed for convenience.

## Commands on the Jenkins Agent

Run these commands from a checkout of this repository on the node labeled `Jenkins-Agent`:

```bash
mvn clean package
mvn test
mvn sonar:sonar
docker build -t remson001/register-app-pipeline:1.0.0-<BUILD_NUMBER> .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image remson001/register-app-pipeline:1.0.0-<BUILD_NUMBER> --no-progress --scanners vuln --exit-code 0 --severity HIGH,CRITICAL --format table
docker push remson001/register-app-pipeline:1.0.0-<BUILD_NUMBER>
docker push remson001/register-app-pipeline:latest
```

Maven creates and tests the WAR, Docker packages it into Tomcat, Trivy scans the final image, and Docker Hub stores both tags. In Jenkins, Docker Hub authentication comes from the `Dockerhub` credential; do not put a password in shell history.

The CI job then triggers the CD job with a value similar to:

```text
IMAGE_TAG=1.0.0-55
```

## Jenkins Prerequisites

- Jenkins agent label: `Jenkins-Agent`
- Maven tool: `Maven03`
- JDK tool: `Java21`
- Jenkins credentials: `GitHub`, `Dockerhub`, and `Jenkins-Sonarqube-token`
- Docker available to the Jenkins agent
- SonarQube server configured in Jenkins
- Trivy available through the Docker image used by the pipeline

## Important Current Behavior

The Trivy command uses `--exit-code 0`, so findings are reported but do not currently fail the build. A production pipeline should define an exception policy and then use a blocking exit code when required.

See the [project README](../README.md) for the complete architecture and the [interview questions](../INTERVIEW-QUESTIONS.md) for discussion points.
