# XcodeProject
**XcodeProject** is a library for Xcode utility for read structure and it can be overwrite for`project.pbxproj.  
And **XcodeProject** package has executable library about append and remove files and directory to your xcode project on CLI named by **xcp**.

## About XcodeProject Library 
### Usage XcodeProject Core Function.

Instanciate `XcodeProject` class.  `XcodeProject` is necessary edit for `project.pbxproj`.

```swift
// Prepare for your project `project.pbxproj` file path.
let yourProjectPath = "/Users/bannzai/development/iOSProject/iOSProject.xcodeproj"
let pbxPath = yourProjectPath + "/project.pbxproj"
let xcodeprojectFileURL = URL(fileURLWithPath: pbxPath)

// Instanciate `XcodeProject`.
let xcodeproject = try XcodeProject(xcodeprojectURL: xcodeprojectFileURL)
```

Append file with relative wfile path from iOSProject.xcodeproject directory and build target name.  

```Swift
xcodeproject.appendFile(path: "iOSProject/Repository/UserRepository.swift", targetName: "iOSProject")
```

Remove file with relative wfile path from iOSProject.xcodeproject directory and build target name.  

```Swift
// append file with file path and build target name. 
xcodeproject.removeFile(path: "Config.swift", targetName: "iOSProject")
```

If you want overwrite `project.pbxproj`, You can call `xcodeproject.write()` method.  

```swift
// Overwrite in pbxproj.
try xcodeproject.write()
```

## Command Line Tool 
### Usage
#### Add file
xcp --add-file <FILE_PATH> <BUILD_TARGET_NAME>  

```bash
$ xcp --add-file iOSProject/Group/A.swift iOSProject.xcodeproj/project.pbxproj iOSProject 
```

#### Add group
xcp --add-group <FILE_PATH> <BUILD_TARGET_NAME>  

```bash
$ xcp --add-group iOSProject/Group/ iOSProject.xcodeproj/project.pbxproj iOSProject
```

#### Remove file
xcp --remove-file <FILE_PATH> <BUILD_TARGET_NAME>  

```bash
$ xcp --remove-file iOSProject/Group/A.swift iOSProject.xcodeproj/project.pbxproj iOSProject 
```

#### Remove group
xcp --remove-group <FILE_PATH> <BUILD_TARGET_NAME>  

```bash
$ xcp --remove-group iOSProject/Group/ iOSProject.xcodeproj/project.pbxproj iOSProject
```

## Used in
### [Kuri](http://github.com/bannzai/Kuri)
[Kuri](http://github.com/bannzai/Kuri) is code generate for iOS CleanArchitecture.

## License
`XcodeProject` is available under the MIT license. See the LICENSE file for more info.

