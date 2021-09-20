import Foundation
import Base58

public struct Multihash {

    public let code: Type
    public let digest: Data

    public var length: Int {
        return digest.count
    }

    public var bytes: Data {
        var data = Data(repeating: 0, count: 0)
        data.append(contentsOf: [code.rawValue, UInt8(length)])
        data.append(digest)
        return data
    }

    public init(code: Type, hash: Data) {
        self.code = code
        self.digest = hash
    }

    public func toBase58() -> String? {
        return [UInt8](bytes).base58EncodedString()
    }
}

extension Multihash {

    // @todo error handling
    public init?(base58 input: String) {
        let buffer = input.base58EncodedStringToBytes()

        if buffer.count < 2 {
            return nil
        }

        guard let code = Type(rawValue: buffer[0]) else {
            return nil
        }

        let hash = Data(buffer[2...(1+Int(buffer[1]))])

        self.init(code: code, hash: hash)
    }
}

extension Multihash: Equatable {
    public static func == (lhs: Multihash, rhs: Multihash) -> Bool {
        return lhs.code == rhs.code && lhs.digest == rhs.digest
    }
}
