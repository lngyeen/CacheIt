//
//  KeyTracker.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/5/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import Foundation

// MARK: - NSCache's Delegate

extension Cache {

    final class KeyTracker: NSObject, NSCacheDelegate {

        var keys = Set<Key>()

        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
            guard let entry = obj as? Entry else { return }
            self.keys.remove(entry.key)
        }
    }

}
