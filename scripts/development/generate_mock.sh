#! /bin/bash 
set -eu
set -o pipefail

PWD=`dirname $0`
APP_DIR="$PWD/../../"

cd $APP_DIR
sourcery --sources ./Sources/XcodeProjectCore --templates ./templates/sourcery/AutoMock.stencil --output ./Tests/XcodeProjectCoreTests/Generated/Mock.generated.swift --args testableImport=XcodeProjectCore
