//
//  ListNewsModel.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/5/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import Foundation

final class ListNewsModel {

    var onFail: ((_ error: String) -> Void)?
    var onGetlistMovie: ((_ list: [Movie]) -> Void)?
    private var listMovie: [Movie] = []

    private var page: Int = 1

    func getlistMovie() {

        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=the&page=\(self.page)&api_key=\(Const.kAPIKey)")!
        let urlRequest = URLRequest(url: url)

        if self.page == 1 {
            self.listMovie = []
        }

        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in

            guard let self = self else { return }

            guard error == nil else {
                DispatchQueue.main.async {
                    self.onFail?(error.debugDescription)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.onFail?("Data is nil")
                }
                return
            }

            do {

                let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                self.listMovie.append(contentsOf: movieResponse.results)

                self.page += 1
                cacheQueue.async {
                    for movie in movieResponse.results {
                        movieCache.insert(movie, forKey: movie.id)
                    }
                }

                DispatchQueue.main.async {
//                    self.onGetListArticle?(self.listMovie)\
                    self.onFail?("")
                }

            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.onFail?("Fail to decode data")
                }
            }

        }.resume()

    }

}
