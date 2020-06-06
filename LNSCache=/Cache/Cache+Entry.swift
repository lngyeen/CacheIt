//
//  WrappedEntry.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/6/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import Foundation

extension Cache {
    
    // Class to wrap Value
    final class Entry {

        let key: Key
        let value: Value
        let expirationDate: Date

        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }

    }

}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}
