import NIOFileSystem
import Zenea

public struct BlockFS: BlockStorage {
    public var zeneaURL: FilePath
    
    public var description: String { self.zeneaURL.string }
    
    public init(_ path: String) {
        self.zeneaURL = FilePath(path)
    }
    
    public init(_ path: FilePath) {
        self.zeneaURL = path
    }
}
