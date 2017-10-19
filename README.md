# DependencyCheck Enterprise Docker

Docker-based self-updating central [OWASP DependencyCheck](https://www.owasp.org/index.php/OWASP_Dependency_Check) Database Server.
This is an out-of-the-box solution for the central Enterprise Setup described [here](https://jeremylong.github.io/DependencyCheck/data/database.html).

## Benefits
- Very fast analysis
- Self-updating, thus always up-to-date CVE data
- No manual central database setup required
- Analysis clients do not require internet access (see below)

Though not actually required, clients _should_ still have HTTP/HTTPS access to [Maven Central Repository](https://search.maven.org/) in order to lessen the 
probability of false negatives (cf. [OWASP DependencyCheck documentation](https://jeremylong.github.io/DependencyCheck/data/index.html#Downloading_Additional_Information)).
If you definitely want to disable internet access on the client, disable the so called _"Central Analyzer"_.


## Quick Start Setup

### Central Database Server

Build the Docker image and push it to your registry:
```bash
./gradlew -PdockerRegistry=<DOCKER_REGISTRY> build push
```

Run the image in a new container:
```bash
docker run -p 3307:3306 <DOCKER_REGISTRY>/dependencycheck-enterprise:3.0.1-1
```

If you are building on the host that shall serve the database the above steps reduce to:
```bash
./gradlew build
docker run -p 3307:3306 dependencycheck-enterprise:3.0.1-1
```

Note that the database update is not being kicked off upon run of the image but only being scheduled on a regular basis. Per default the database update is 
scheduled on the hour. The initial update takes quite some time. Depending on your machine and internet connection this can take up to 30 min. Subsequent 
updates are incremental ones and finish in a couple of seconds.


### Analysis clients

All kinds of analysis clients are supported: Gradle, Maven, Ant, Jenkins, CLI. Apply the following changes to your build file:
- add buildscript dependency for `mysql:mysql-connector-java:5.1.44`
- disable database updates triggered by your project: `autoUpdate = false`
- add database connection parameters: `data { ... }`

Example (Gradle):
```groovy
buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath 'org.owasp:dependency-check-gradle:3.0.1'
        classpath 'mysql:mysql-connector-java:5.1.44'
    }
}

apply plugin: 'org.owasp.dependencycheck'

dependencyCheck {
    autoUpdate = false
    data {
        connectionString = "jdbc:mysql://<DC_HOST>:3307/dependencycheck?useSSL=false"
        driver = "com.mysql.jdbc.Driver"
        username = "dc"
        password = "change-me"
    }
}
```

Start the Dependency Analysis:
```bash
./gradlew dependencyCheckAnalyze
```

It's likely that the database is still empty as the automatic update has not been triggered yet. Thus you might want to kick off the initial update manually:
```bash
./gradlew dependencyCheckUpdate
```
 

## Customization

See [gradle.properties](https://github.com/stefanneuhaus/dependencycheck-enterprise-docker/blob/master/gradle.properties) for a selection of properties. 


## Compatibility

Plugin versions used in your project to be analyzed (_client_) usually stay compatible to the DependencyCheck Enterprise Docker Database (_server_) for a 
long time. All client/server combinations with version >= 1.4.1 should work together.
