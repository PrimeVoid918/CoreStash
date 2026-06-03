#!/usr/bin/env bash

TARGET=$(echo "$1" | tr '[:upper:]' '[:lower:]')

if [ -z "$CHROME_EXECUTABLE" ]; then
    export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
fi

case "$TARGET" in
    "chrome" | "web" | "w")
        flutter run -d chrome
        ;;
    "android" | "mobile" | "a")
        flutter run -d 24117RN76G
        ;;
    "all" | "all-devices")
        flutter run -d all
        ;;
    "help" | "-h" | "--help")
        echo "Usage: ./run.sh [chrome | android | all]"
        ;;
    *)
        # Fallback safeguard if you type nothing or make a typo
        echo "⚠️  Unknown target '$1'"
        ;;
esac
