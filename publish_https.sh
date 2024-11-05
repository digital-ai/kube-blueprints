#!/bin/bash

./gradlew clean uploadArchives devSnapshot -x updateDocs -x test --stacktrace -PgitProtocol=https -Prelease.ignoreSuppliedVersionVerification=true --info