#! /bin/bash 
set -eu
set -o pipefail

PWD=`dirname $0`
APP_DIR="$PWD/../../"

cd $APP_DIR
sourcery --sources ./Sources/XcodeProject/Core --templates ./templates/sourcery/AutoMock.stencil --output ./Tests/XcodeProjectTests/Generated/Mock.generated.swift --args testableImport=XcodeProject
