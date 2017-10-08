# XcodeProject
`XcodeProject` is Xcode utility for reading and writing `project.pbxproj` file format.

## Usage
```swift
let pbxPath = projectFilePath + "project.pbxproj"
let xcodeprojectFileUrl = URL(fileURLWithPath: pbxPath)

// Read pbxproj when create XCProject instance
let project = try XCProject(for: xcodeprojectFileUrl)

// Append for PBX Object with
// project root direcotry path,
// will append file path relative for project root directory path,
// will append project target name.
...
project.appendFilePath(
    with: projectRootPath,
    filePath: filePath,
    targetName: targetName
)
...

// Write in pbxproj.
// If you added the PBX Object it will be reflected
try project.write()
```

## Used in
### [Kuri](http://github.com/bannzai/Kuri)
[Kuri](http://github.com/bannzai/Kuri) is code generate for iOS CleanArchitecture.

## License
`XcodeProject` is available under the MIT license. See the LICENSE file for more info.

# XcodeProject
