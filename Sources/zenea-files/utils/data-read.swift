import Foundation

extension AsyncSequence where Element == Data {
    internal func read() async throws -> Data {
        var data = Data()
        for try await subdata in self {
            data += subdata
        }
        
        return data
    }
}
