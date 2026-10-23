#!/usr/bin/env bash
# Source only inside this prepared cloud workspace. Never reassign HOME.
export PATH="/workspace/tools/flutter/bin:/workspace/tools/venv/bin:/workspace/tools/android-sdk/platform-tools:$PATH"
export PUB_CACHE=/workspace/tools/pub-cache
export XDG_CONFIG_HOME=/workspace/tools/config
export ANALYZER_STATE_LOCATION_OVERRIDE=/workspace/tools/analyzer
export ANDROID_HOME=/workspace/tools/android-sdk
export ANDROID_USER_HOME=/workspace/tools/android-user
export GRADLE_USER_HOME=/workspace/tools/gradle
export GRADLE_OPTS='-Duser.home=/workspace/tools/android-user -Dorg.gradle.workers.max=2 -Dorg.gradle.daemon=false'

# Native SQLite loader name for Linux Flutter tests
export LD_LIBRARY_PATH="/workspace/tools/native${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

export JAVA_HOME=/workspace/tools/jdks/jdk-17.0.14+7
export PATH="$JAVA_HOME/bin:$PATH"
