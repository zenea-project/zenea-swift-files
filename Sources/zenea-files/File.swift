import NIOFileSystem
import Zenea

extension BlockFS {
    public func checkBlock(id: Block.ID) async -> Result<Bool, Block.CheckError> {
        var url = zeneaURL
        url.append("blocks")
        
        let hash = id.hash.toHexString()
        url.append(String(hash[0..<2]))
        url.append(String(hash[2..<4]))
        url.append(String(hash[4...]))
        
        do {
            let info = try await FileSystem.shared.info(forFileAt: url)
            guard let info = info else { return .success(false) }
            
            guard info.type == .regular else { return .failure(.unable) }
            return .success(true)
        } catch let error as FileSystemError where error.code == .notFound {
            return .success(false)
        } catch {
            return .failure(.unable)
        }
    }
}
