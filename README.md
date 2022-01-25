# docker-hadoop

Apache Hadoop in Docker made easy

- [Overview](#overview)
- [Installation](#installation)
- [Running the project](#running-the-project)
- [FAQ](#faq)
- [Additional info](#additional-info)

## Overview

So you probably wanted to dip your toes into Hadoop but got discouraged by its complexity.\
Yeah, me too.

I wanted to run Hadoop in Docker to avoid installing it locally, since a single stray command can send you on a very long journey to fix the installation. Alas, I didn't find a single GitHub repository that is up-to-date and builds on the ARM architecture, so I decided to create my own.

## Installation

You'll need to [install Docker](https://www.docker.com/get-started), obviously.\
Due to some problems with name resolution, you'll also need to add the following line to your `/etc/hosts`:
```
127.0.0.1 datanode datanode1 datanode2 datanode3
```

You're all set!

## Running the project

Once you're done with the setup, clone the repository and decide whether you want to run a cluster with 1 or 3 datanodes (`make 1dn` and `make 3dn`, respectively).

Here's a basic `docker-hadoop` workflow:
1. move your input files to the `input` folder
2. rename your `.jar` to `MapReduce.jar` and move it to `submit/project/MapReduce/build/libs/` or run `make pack` to build the code from `submit/project/MapReduce/src/main/java/mapreduce/`
3. submit your `.jar` to the cluster by running `make -e CLASS=your_class_name -e PARAMS="your parameters here" submit` in the project's root directory; remember to replace `your_class_name` with the target class name that you'd like to run (if you omit `-e CLASS=...`, the default is `-e CLASS="mapreduce.MapReduce"`; if you omit `-e PARAMS=...`, the default is `-e PARAMS="/input /output"`)
4. open `localhost` (or `localhost:80`) in your browser and stare in awe at the program output
5. prepare for the next submission by running `make clean`
6. create several GitHub account to bless the project with multiple **☆ Stars** (optional, but recommended)

To make working with the project a little more enjoyable, I created a simple Java project template using Gradle in the `submit` directory. Write your own code, package it by running `gradle jar` in the `submit/project/` folder and repeat the basic workflow - your shiny new `.jar` will become the new target automatically.

If you don't want to install Java or Gradle locally, you can either run `make pack` to create a `.jar` from your code in `submit/project/`, or `make pack submit` to run `make pack` and `make submit` one after the other.

Note that the first `make pack` will take an awfully long time. Subsequent builds will be faster due to caching.

The project includes a basic map-reduce WordCount implementation. You can run it via `make pack submit` to test the waters before altering the code. Remember that you'll need a working cluster to do that, so a complete example from a freshly-cloned project can be run via `make 1dn pack submit` or `make 3dn pack submit`.

Enjoy!

## Streaming API

If you'd like to use the streaming API instead of regular ol' Java, I got you covered. Create your cluster, put your input files in the `input` directory and run `make -e MAPPER="your mapper here" -e REDUCER="your reducer here" stream`.

Want an example command for the streaming API? Sure, try running `make -e MAPPER="tr -s '[[:punct:][:space:]]' '\n'" -e REDUCER="/usr/bin/uniq -c" stream` for WordCount.

If you're tired of Java (who isn't?) and *nix commands make you dizzy (that's me), you could also use Python for a change. Just run `make stream-python` and files from `input` will be processed by `mapper.py` and `reducer.py`, located in the `stream` directory. These files contain yet another implementation of the WordCount algorithm. I swear I will flip out if I have to write another one of these.

## FAQ

### I can't preview / download / upload files in the web GUI!

Edit your `/etc/hosts` as described above.

### I ran `make submit` and it crashed with `Exception in thread "main" java.lang.ClassNotFoundException: some_class_name`!

Specify your target class explicitly by passing `-e CLASS=some_other_class_name` to your `make` command.

### I ran `make submit` and it crashed with `Output directory hdfs://namenode:9000/output already exists`!

Run `make clean`.

### Some inexplicable demonic force possessed my installation!

Ah, a classic. That happens sometimes. Try running `make down` (which will delete the entire Compose container, along with HDFS!) and reinstall with either `make 1dn` or `make 3dn`.

If that didn't work... How about `make nuke`? Beware - it will literally nuke all your Docker images, containers and volumes. Handle with EXTREME caution!

### Why aren't you using `image: {name}:{tag}` in `docker-compose.yml`?

It's a temporary workaround for `aarch64` machines; refer to [this issue](https://github.com/docker/compose/issues/8804) for more info.

### I didn't find a solution to my problem in the FAQ :(

Open a new GitHub issue and we'll try to work something out.

## Additional info
The project was tested using Docker Desktop 4.2.0 (70708) on macOS 12.0.1 Monterey (arm64).
