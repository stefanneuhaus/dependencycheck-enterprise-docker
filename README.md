# DependencyCheck Enterprise Docker

Docker based self-updating central [OWASP DependencyCheck](https://www.owasp.org/index.php/OWASP_Dependency_Check) Database Server.
This is basically an out-of-the-box solution for the central Enterprise Setup described [here](https://jeremylong.github.io/DependencyCheck/data/database.html).


## Quick Start

Build the Docker image and start a container:
```
./gradlew
docker run -p 3307:3306 --name dependencycheck-enterprise dependencycheck-enterprise:3.0.0-0.1
```

Grab yourself a coffee while the Database is being created.

Configure your project to be analyzed. Example (Gradle):
```groovy
buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath 'org.owasp:dependency-check-gradle:3.0.0'
        classpath 'mysql:mysql-connector-java:5.1.44'
    }
}

apply plugin: 'org.owasp.dependencycheck'

dependencyCheck {
    failBuildOnCVSS = 0
    autoUpdate = false
    data {
        connectionString = "jdbc:mysql://localhost:3307/dependencycheck?useSSL=false"
        driver = "com.mysql.jdbc.Driver"
        username = "root"
        password = "dc"
    }
}
```

Now you are able to start the Dependency Analysis without the time-consuming creation/update of a project-specific Database:
```
./gradlew dependencyCheckAnalyze
```
