//
//  WrappedKey.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/6/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import Foundation

extension Cache {

    // Class to wrap Key
    final class WrappedKey: NSObject {

        let key: Key

        init(_ key: Key) {
            self.key = key
        }

        override var hash: Int {
            return self.key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {

            guard let value = object as? WrappedKey else { return false }
            return value.key == key

        }

    }

}
