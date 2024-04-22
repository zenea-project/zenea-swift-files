import Foundation
import NIOFileSystem
import Zenea

extension BlockFS {
    public func putBlock<Bytes>(content: Bytes) async -> Result<Block, Block.PutError> where Bytes: AsyncSequence, Bytes.Element == Data {
        do {
            guard let content = try? await content.read() else { return .failure(.unable) }
            guard content.count <= Block.maxBytes else { return .failure(.overflow) }
            
            let block = Block(content: content)
            
            var url = zeneaURL
            url.append("blocks")
            
            let hash = block.id.hash.toHexString()
            url.append(String(hash[0..<2]))
            url.append(String(hash[2..<4]))
            url.append(String(hash[4...]))
            
            if let info = try await FileSystem.shared.info(forFileAt: url) {
                return .failure(info.type == .regular ? .exists(block) : .unable)
            }
            
            let parent = url.removingLastComponent()
            try? await FileSystem.shared.createDirectory(at: parent, withIntermediateDirectories: true)
            
            let handle = try await FileSystem.shared.openFile(forWritingAt: url, options: .newFile(replaceExisting: false))
            defer { Task { try? await handle.close(makeChangesVisible: true) } }
            
            try await handle.write(contentsOf: block.content, toAbsoluteOffset: 0)
            
            return .success(block)
        } catch {
            return .failure(.unable)
        }
    }
}
