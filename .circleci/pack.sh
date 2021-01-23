#!/bin/bash
which circleci || brew install circleci
circleci config pack unpacked >|config.yml
#circleci config validate config.yml
