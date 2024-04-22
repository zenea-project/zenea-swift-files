import NIOFileSystem

internal func scanDir(_ dir: FilePath) async throws -> [DirectoryEntry] {
    let handle = try await FileSystem.shared.openDirectory(atPath: dir)
    var results: [DirectoryEntry] = []
    
    do {
        for try await entry in handle.listContents(recursive: false) {
            results += [entry]
        }
        try? await handle.close()
    } catch {
        try? await handle.close()
        throw error
    }
    
    return results
}

internal func processIntermediate(_ entry: DirectoryEntry, bytes: [UInt8]) async -> ([UInt8], [DirectoryEntry])? {
    guard entry.type == .directory else { return nil }
    
    guard let newBytes = [UInt8](hexString: entry.name.string) else { return nil }
    guard newBytes.count == 1 else { return nil }
    
    var contents: [DirectoryEntry] = []
    do {
        for try await file in try await scanDir(entry.path) {
            contents.append(file)
        }
    } catch {
        return nil
    }
    
    return (bytes + newBytes, contents)
}
