#! /usr/bin/env bash

git tag $(poetry version --short)
git push --tags # update the repository version
