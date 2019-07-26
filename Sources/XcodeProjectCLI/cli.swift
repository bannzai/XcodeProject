
public struct Version: CustomStringConvertible {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public init(
        _ major: Int,
        _ minor: Int,
        _ patch: Int
        ) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public var description: String {
        return "version: \(major).\(minor).\(patch)"
    }
}


public struct CLI {
    public let version: Version
    public init(version: Version) {
        self.version = version
    }
    
    public func execute() {
        
    }
}
