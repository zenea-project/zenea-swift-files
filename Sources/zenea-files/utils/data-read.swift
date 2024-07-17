import Foundation

internal extension AsyncSequence where Element == Data {
    func read() async throws -> Data {
        var data = Data()
        for try await subdata in self {
            data += subdata
        }
        
        return data
    }
}
