//
//  ImageView+.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/6/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import UIKit

extension UIImageView {

    func loadImageWith(url: String?) {

        guard let url = URL(string: url ?? "") else { return }

        // find in cache:
        if let image = imageCache[url.absoluteString] {

            self.image = image

        } else {

            // if not found in cache, download it:
            DispatchQueue.global(qos: .utility).async {

                guard let dataImage = try? Data(contentsOf: url) else {
                    imageCache[url.absoluteString] = nil
                    DispatchQueue.main.async {
                        self.image = nil
                    }
                    return
                }

                guard let image = UIImage(data: dataImage) else {
                    imageCache[url.absoluteString] = nil
                    DispatchQueue.main.async {
                        self.image = nil
                    }
                    return
                }

                DispatchQueue.main.async {
                    // cache
                    imageCache[url.absoluteString] = image
                    self.image = image
                }

            }
        }

    }

}
