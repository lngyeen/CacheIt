//
//  ListMovieTableViewCell.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/5/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import UIKit

final class ListMovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configCellWith(movie: Movie) {

        self.titleLabel.text = movie.originalTitle
        self.contentLabel.text = movie.overview

        let imageUrl = "\(Const.kBaseImageURL)\(movie.posterPath ?? "")"
        self.thumbnailImageView.loadImageWith(url: imageUrl)

    }
    
}
