#!/bin/bash

./gradlew clean uploadArchivesToMavenLocal -x updateDocs -x test --stacktrace -PgitProtocol=https --info
