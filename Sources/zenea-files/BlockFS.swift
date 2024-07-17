import NIOFileSystem
import Zenea

public struct BlockFS: BlockStorage, Hashable, Sendable, Codable {
    public var zeneaPath: String
    
    public var zeneaURL: FilePath {
        get { FilePath(zeneaPath) }
        set { zeneaPath = newValue.string }
    }
    
    public var description: String { self.zeneaPath }
    
    public init(_ path: String) {
        self.zeneaPath = path
    }
    
    public init(_ path: FilePath) {
        self.zeneaPath = path.string
    }
}
