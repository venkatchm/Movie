//
//  ImageCache.swift
//  RickyBuggy
//
//  Created by Venkatachalam Perumal on 23/01/25.
//
import Foundation

class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSString, NSData>()

    func getData(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }

    func setData(_ data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
}
