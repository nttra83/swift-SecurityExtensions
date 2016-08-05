import Foundation
import IDZSwiftCommonCrypto

extension SecKey {
    
    /**
     * Computes the digital signature of the given data using the current key. This method takes the SHA1 hash of the data
     * and passes that into `SecKeyRawSign()` with `PKCS1SHA1` padding.
     *
     * Please note that normally this assumes that the current key
     * is a private key, but that is not verified here.
     *
     * - parameter data: the data to sign
     * - returns: The signature of the data.
     */
    public func sign(data data:[UInt8]) -> [UInt8] {
        let sha1 = Digest(algorithm: .SHA1)
        sha1.update(data)
        let digest = sha1.final()
        
        var signature = [UInt8](count:1024, repeatedValue:0)
        var signatureLength = 1024
        let status = SecKeyRawSign(self, .PKCS1SHA1, digest, digest.count, &signature, &signatureLength)
        guard status == errSecSuccess else {
            return []
        }
        let realSignature = signature[0 ..< signatureLength]
        return Array(realSignature)
    }
    
}
