# sphinx4-ruby

Project for testing sphinx4 speech recognition with JRuby.


## Usage

The following steps apply to OSX (Mavericks 10.9.4). Ensure that the [JDK 1.7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) is installed (`java -version`).

Install Maven:

```bash
$ brew install maven
```

Clone with submodules (git 1.6.5 or later):

```bash
$ git clone --recursive git@github.com:watsonbox/sphinx4-ruby.git
```

Compile and package sphinx4:

```bash
$ cd sphinx4
$ mvn clean package
```

Run one of the demos:

```bash
$ java -jar sphinx4-samples/target/sphinx4-samples-1.0-SNAPSHOT-jar-with-dependencies.jar dialog
```