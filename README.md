Xcode utility for reading and writing pbxproj file format.

# xcp
`xcp` is Xcode utility for reading and writing `project.pbxproj` file format.

## Usage
```swift
let pbxPath = projectFilePath + "project.pbxproj"
let xcodeprojectFileUrl = URL(fileURLWithPath: pbxPath)

// Read pbxproj when create XCProject instance
let project = try XCProject(for: xcodeprojectFileUrl)

// Append for PBX Object
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
`xcp` is available under the MIT license. See the LICENSE file for more info.
