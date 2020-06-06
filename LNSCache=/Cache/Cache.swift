//
//  Cache.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/5/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import Foundation



final class Cache<Key: Hashable, Value> {

    private let cache = NSCache<WrappedKey, Entry>()
    private let entryLifeTime: TimeInterval
    private let keyTracker = KeyTracker()

    init(entryLifeTime: TimeInterval = Const.kEntryLifeTime, maximumEntryCount: Int = Const.kMaximumEntryCount) {

        self.entryLifeTime = entryLifeTime
        self.cache.countLimit = maximumEntryCount
        self.cache.delegate = keyTracker
    }

}

// MARK: - Deal with Key/Value
extension Cache {

    func insert(_ value: Value, forKey key: Key) {

        let date = Date().addingTimeInterval(self.entryLifeTime)
        let entry = Entry(key: key, value: value, expirationDate: date)

        self.cache.setObject(entry, forKey: WrappedKey(key))
        self.keyTracker.keys.insert(key)
//        print("=== insert entry with key: \(key)")
    }

    func value(forKey key: Key) -> Value? {

        guard let entry = self.cache.object(forKey: WrappedKey(key)) else  { return nil }

        guard Date() < entry.expirationDate else {
            // if value has expired --> remove it
            self.removeValue(forKey: key)
            return nil
        }

        return entry.value

    }

    func removeValue(forKey key: Key) {
        self.cache.removeObject(forKey: WrappedKey(key))
    }

    subscript(key: Key) -> Value? {
        get {
            return self.value(forKey: key)
        }
        set {
            guard let newValue = newValue else {
                // if asssign nil -> remove entry
                self.removeValue(forKey: key)
                return
            }
            self.insert(newValue, forKey: key)
        }
    }

}

// MARK: - Codable Entry
extension Cache {

    func entry(forKey key: Key) -> Entry? {

        guard let entry = self.cache.object(forKey: WrappedKey(key)) else { return nil }
        guard Date() < entry.expirationDate else {
            self.removeValue(forKey: key)
            return nil
        }
        return entry
    }

    func insert(_ entry: Entry) {
        self.cache.setObject(entry, forKey: WrappedKey(entry.key))
        self.keyTracker.keys.insert(entry.key)
    }

}

extension Cache: Codable where Key: Codable, Value: Codable {

    // Encode the Cache itself to data
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(self.insert)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }

}

extension Cache where Key == Int, Value == Movie {

    var listCachedMovie: [Movie] {
        return self.keyTracker.keys.compactMap{self.value(forKey: $0)}.sorted{ $0.id < $1.id }
    }
    
}

extension Cache where Key: Codable, Value: Codable {

    func saveToDisk(withName name: String, using fileManager: FileManager = .default) throws {

        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)

    }

}
