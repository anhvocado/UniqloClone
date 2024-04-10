//
//  String+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 5/7/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    static var TIME_PATTERN_WITHOUT_SECONDS = "yyyy/MM/dd HH:mm"
    static var DATE_TIME_PATTERN = "yyyy/MM/dd"
    static var TIME_PATTERN = "yyyy-MM-dd HH:mm:ss"
    static var BACKUP_TIME_PATTERN = "yyyy-MM-dd hh:mm:ss"
    static var COMMENT_CREATED_DATE_PATTERN = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    func toDate(pattern: String) -> Date? {
        let dateFormatter = DateFormatter()
        // fix https://prograils.com/posts/the-curious-case-of-the-24-hour-time-format-in-swift
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm a")
        dateFormatter.amSymbol = ""
        dateFormatter.pmSymbol = ""
        dateFormatter.locale = Locale(identifier: "en_US")
        // end fix
        dateFormatter.dateFormat = pattern
        return dateFormatter.date(from:self)
    }
    
    func convertDateToJPText(pattern: String) -> String {
        if let date = self.toDate(pattern: pattern) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            return "\(components.year?.rewriteDateTime() ?? "")/\((components.month?.rewriteDateTime() ?? ""))/\((components.day?.rewriteDateTime() ?? ""))"
        }
        return ""
    }
    
    func trim(to maximumCharacters: Int) -> String {
        return "\(self[..<index(startIndex, offsetBy: maximumCharacters)])" + "..."
    }
    
    public var stringPattern: String {
        return ".*[^A-Za-z0-9Ａ-Ｚａ-ｚ０-９!@#$%^&*()_+-={}:;\"'/<>,./?！＠＃＄％＾＆＊（）＿＋－＝｛｝：；＂＇／＜＞，．／？].*"
    }
    
    /// Convert String to Halfwidth
    public var halfSize: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, false)
        return text as String
    }
    
    /// Convert String to Fullwidth
    public var fullSize: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, true)
        return text as String
    }
}

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func formattedNumberString(newString: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0

        let newStringWithoutCommas = self.replacingOccurrences(of: ".", with: "") + newString

        if let number = formatter.number(from: newStringWithoutCommas), let formattedString = formatter.string(from: number) {
            return formattedString
        }

        return self
    }

    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))

        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)

        let digest = stringFromResult(result: result, length: digestLen)

        result.deallocate()

        return digest
    }

    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }

}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
