import Crypto
import Zenea

extension BlockFS {
    public func listBlocks() async -> Result<Set<Block.ID>, Block.ListError> {
        var url = zeneaURL
        url.append("blocks")
        
        do {
            var results: Set<Block.ID> = []
            
            let files1 = try await scanDir(url)
            
            for try await file1 in files1 {
                guard let (bytes1, files2) = await processIntermediate(file1, bytes: []) else { continue }
                
                for file2 in files2 {
                    guard let (bytes2, files3) = await processIntermediate(file2, bytes: []) else { continue }
                    
                    for file3 in files3 {
                        guard file3.type == .regular else { continue }
                        
                        let previousBytes = bytes1 + bytes2
                        
                        guard let bytes = [UInt8](hexString: file3.name.string) else { continue }
                        guard bytes.count == SHA256.byteCount - previousBytes.count else { continue }
                        
                        results.insert(Block.ID(algorithm: .sha2_256, hash: previousBytes + bytes))
                    }
                }
            }
            
            return .success(results)
        } catch {
            return .failure(.unable)
        }
    }
}
