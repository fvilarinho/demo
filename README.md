Getting Started
---------------
This is a demo project for education/training purposes of DevOps. All the services used below are in the Cloud to facilitate the understanding.
The architecture uses microservices and containerization.

[![Pipeline](https://github.com/fvilarinho/demo/actions/workflows/pipeline.yml/badge.svg?branch=master)](https://github.com/fvilarinho/demo/actions/workflows/pipeline.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=fvilarinho_demo_backend&metric=alert_status)](https://sonarcloud.io/dashboard?id=fvilarinho_demo_backend)
[![Gradle Status](https://gradleupdate.appspot.com/arthurfnsc/demo/status.svg)](https://gradleupdate.appspot.com/arthurfnsc/demo/status)

The pipeline uses [`GitHub Actions`](https://github.com/features/actions) that contains a pipeline with 7 phases described below:

### 1. Compile, Build and Test
All commands of this phase are defined in `build.sh` file. 
It checks if there are no compile/build errors.
The tools used are:
- [`Gradle`](https://www.gradle.org) - Tool to automate the build of the code.

### 2. Code Analysis - SAST (White-box testing)
All commands of this phase are defined in `codeAnalysis.sh` file. 
It checks Bugs, Vulnerabilities, Hotspots, Code Smells, Duplications and Coverage of the code.
If these metrics don't comply with the defined Quality Gate, the pipeline won't continue.
The tools used are:
- [`Gradle`](https://www.gradle.org) - Tool to automate the SAST analysis of the code.
- [`Sonar`](https://sonardcloud.io) - Service that provides SAST analysis of the code.

Environments variables needed in this phase:
- `GITHUB_TOKEN`: API Key used by Sonar client to communicate with GitHub.
- `SONAR_TOKEN`: API Key used by Sonar client to store the generated analysis.

### 3. Libraries Analysis - SAST (White-box testing)
All commands of this phase are defined in `librariesAnalysis.sh` file. 
It checks for vulnerabilities in internal and external libraries used in the code.
The tools used are:
- [`Gradle`](https://www.gradle.org) - Tool to automate the SAST analysis of the libraries.
- [`Snyk`](https://snyk.io) - Service that provides SAST analysis of the libraries.

Environments variables needed in this phase:
- `SNYK_TOKEN`: API Key used by Snyk to store the generated analysis.

### 4. Packaging
All commands of this phase are defined in `package.sh` file.
It encapsulates all binaries in a Docker image.
Once the code and libraries were checked, it's time build the package to be used in the next phases.
The tools/services used are:
- [`Docker Compose`](https://docs.docker.com/compose) - Tool to build the images.

### 5. Package Analysis - SAST (White-box testing)
All commands of this phase are defined in `packageAnalysis.sh` file.
It checks for vulnerabilities in the generated package.
The tools/services used are:
- [`Gradle`](https://www.gradle.org) - Tool to automate the SAST analysis of the package.
- [`Snyk`](https://snyk.io) - Service that provides SAST analysis of the package.

Environments variables needed in this phase:
- `SNYK_TOKEN`: API Key used by Snyk to store the generated analysis.

### 6. Publishing
All commands of this phase are defined in `publish.sh` file.
It publishes the package in the Docker registry (GitHub Packages).
The tools/services used are:
- [`Docker Compose`](https://docs.docker.com/compose) - Tool to push the images into the Docker registry.
- [`GitHub Packages`](https://github.com/features/packages) - Docker registry where the images are stored.

Environments variables needed in this phase:
- `DOCKER_REGISTRY_USER`: Username of the Docker registry.
- `DOCKER_REGISTRY_PASSWORD`: Password of the Docker registry.

### 7. Deploy
All commands of this phase are defined in `deploy.sh` file.
It deploys the package in a K3S (Kubernetes) cluster.
The tools/services used are:
- [`Terraform`](https://terraform.io/) - Infrastructure as a Code tool. 
- [`kubectl`](https://kubernetes.io/docs/reference/kubectl/overview/) - Kubernetes Orchestration tool. 
- [`Portainer`](https://portainer.io) - Kubernetes Orchestration Portal.
- [`Linode`](https://www.linode.com) - Cloud (Newark/USA) where the cluster manager is installed.
- [`Cloudflare`](https://www.cloudflare.com) - CDN platform used to store DNS entries.

### 8. DAST (Black-box testing) and RASP (Runtime Application Self-Protection)
We are doing this phase outside the pipeline but it can be incorporated in the future.
The tools/services used are:
- [`Contrast Security`](https://www.contrastsecurity.com/) - Services that protects and checks vulnerabilities.

Comments
--------
### If any phase got errors or violations, the pipeline will stop.
### All environments variables must also have a secret with the same name. 
### You can define the secret in the repository settings. 
### DON'T EXPOSE OR COMMIT ANY SECRET IN THE PROJECT.

Architecture
------------
The application uses:
- [`Java 11`](https://www.oracle.com/br/java/technologies/javase-jdk11-downloads.html) - Programming Language.
- [`Spring Boot 2.5.4`](https://spring.io) - Development Framework.
- [`Gradle 6.8.3`](https://www.gradle.org) - Automation build tool.
- [`Mockito 3`](https://site.mockito.org/) - Test framework.
- [`JUnit 5`](https://junit.org/junit5/) - Test framework.
- [`MariaDB`](https://mariadb.com/) - Database server.
- [`NGINX 1.18`](https://www.nginx.com/****) - Web server.
- [`Docker 20.10.8`](https://www.docker.com) - Containerization tool.
- [`K3S 1.21.4`](https://k3s.io/) - Containerization tool.

For further documentation please check the documentation of each tool/service.

How to install
--------------
1. Linux operating system.
2. You need an IDE such as [IntelliJ](https://www.jetbrains.com/pt-br/idea).
3. You need an account in the following services:
`GitHub, Sonarcloud, Snyk, Contrast Security`.
4. You need to set the environment variables described above in you system.
5. The API Keys for each service must be defined in the UI of each service. Please refer the service documentation.
6. Fork this project from GitHub.
7. Import the project in IDE.
8. Commit some changes in the code and follow the execution of the pipeline in GitHub.

How to run locally
------------------
1. In the project directory, execute the scripts below:
`./build.sh; ./package.sh; docker-compose up`
2. Open the URL `http://localhost` in your preferred browser after the boot.

How to run in the cloud (Linode)
--------------------------------
1. Run the `deploy.sh` script that will provision your infrastructure, the kubernetes cluster/orchestration and the application microservices.
2. Open the URL `http://<linode-ip>:30080` in your preferred browser after the boot.

Other Resources
----------------
- [Official Gradle documentation](https://docs.gradle.org)
- [Spring Boot Gradle Plugin Reference Guide](https://docs.spring.io/spring-boot/docs/2.4.4/gradle-plugin/reference/html/)
- [Spring Web](https://docs.spring.io/spring-boot/docs/2.5.4/reference/htmlsingle/#boot-features-developing-web-applications)
- [Spring Data JPA](https://docs.spring.io/spring-boot/docs/2.5.4/reference/htmlsingle/#boot-features-jpa-and-spring-data)
- [Serving Web Content with Spring MVC](https://spring.io/guides/gs/serving-web-content/)
- [Accessing Data with JPA](https://spring.io/guides/gs/acce****ssing-data-jpa/)

All opinions and standard described here are my own.

That's it! Now enjoy and have fun!

Contact
-------
- LinkedIn: https://www.linkedin.com/in/fvilarinho
- e-Mail: fvilarinho@gmail.com