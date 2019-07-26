
install:
	cd ../
	swift build
	cd -

add-file-nested: install
	../.build/x86_64-apple-macosx/debug/xcp --add-file Group2/bbbb.swift iOSTestProject.xcodeproj/project.pbxproj iOSTestProject --overwrite

add-group: install
	../.build/x86_64-apple-macosx/debug/xcp --add-group Group2 iOSTestProject.xcodeproj/project.pbxproj iOSTestProject --overwrite

