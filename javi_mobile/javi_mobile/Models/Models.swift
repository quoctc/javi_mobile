// Models.swift
//
//  Created by Quoc Tran on 9/25/17.
//  Copyright © 2017 Quoc Tran. All rights reserved.
//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> Any
}

public enum ErrorResponse : Error {
    case Error(Int, Data?, Error)
}

open class Response<T> {
    open let statusCode: Int
    open let header: [String: String]
    open let body: T?

    public init(statusCode: Int, header: [String: String], body: T?) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

protocol Decodable {
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T!
}

protocol ArrayDecodable {
    static func decodeArrayOf<T>(source: Any, instance: AnyObject?) -> [T]
}

extension ArrayDecodable {
    static func decodeArrayOf<T>(source: Any, instance: AnyObject?  = nil) -> [T] {
        let array = source as! [AnyObject]
        return array.map { return Decoders.decode(clazz: T.self, source: $0, instance: nil) }
    }
}

private var once = Int()
class Decoders {
    static fileprivate var decoders = Dictionary<String, ((AnyObject, AnyObject?) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject, AnyObject?) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0, $1) as AnyObject }
    }

    static func decode<T>(clazz: T.Type, discriminator: String, source: AnyObject) -> T {
        let key = discriminator;
        if let decoder = decoders[key] {
            return decoder(source, nil) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map {
            return Decoders.decode(clazz: T.self, source: $0, instance: nil)
        }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key:T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value, instance: nil)
        }
        return dictionary
    }

    static func decode<T>(clazz: T.Type, source: AnyObject, instance: AnyObject?) -> T {
        initialize()
        
        //decode for base support type
        if T.self is Int32.Type && (source is NSNumber || source is NSString) {
            if source is NSNumber {
                return (source as! NSNumber).int32Value as! T
            }
            else {
                return source.int32Value as! T
            }
        }
        if T.self is Int64.Type && (source is NSNumber || source is NSString) {
            if source is NSNumber {
                return (source as! NSNumber).int64Value as! T
            }
            else {
                return source.int64Value as! T
            }
        }
        if T.self is UUID.Type && source is String {
            return UUID(uuidString: source as! String) as! T
        }
        if source is T {
            return source as! T
        }
        if T.self is Data.Type && source is String {
            return Data(base64Encoded: source as! String) as! T
        }
        
        //decode for custom object type
        if T.self is Decodable.Type {
            return (T.self as! Decodable.Type).decode(source: source, instance: instance)
        }
        
        //decode from saved decoders
        let key = "\(T.self)"
        if let decoder = decoders[key] {
           return decoder(source, instance) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source, instance: nil)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss",
            "M/d/yyyy HH:mm:ss"
        ].map { (format: String) -> DateFormatter in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject, instance: AnyObject?) -> Date in
           if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return date
                    }
                }
            }
            if let sourceInt = source as? Int64 {
                // treat as a java date
                return Date(timeIntervalSince1970: Double(sourceInt / 1000) )
            }
            fatalError("formatter failed to parse \(source)")
        }
    }()

    static fileprivate func initialize() {
        _ = Decoders.__once
    }
}
