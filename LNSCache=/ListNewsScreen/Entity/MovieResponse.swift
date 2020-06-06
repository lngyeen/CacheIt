//
//  Article.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/5/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {

    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]

}

struct Movie: Codable {

    let id: Int
    let title: String?
    let originalName: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?

}
