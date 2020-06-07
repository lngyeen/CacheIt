//
//  ListMovieViewController.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/5/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import UIKit

final class ListMovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private lazy var centerSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            spinner.center = self.view.center
        return spinner
    }()

    private lazy var bottomSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        return spinner
    }()

    private let model = ListNewsModel()
    private let cellId = "ListMovieTableViewCell"
    private var listMovie: [Movie] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
        self.addHandler()
        self.loadData()

    }

    private func initialSetup() {
        self.view.addSubview(self.centerSpinner)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.cellId, bundle: nil), forCellReuseIdentifier: self.cellId)
    }

    private func addHandler() {

        self.model.onFail = { [weak self] error in
            // Use cache
            guard let self = self else { return }
            self.centerSpinner.stopAnimating()
            self.listMovie = movieCache.listCachedMovie
            print(error)
        }

        self.model.onGetlistMovie = { [weak self] listMovie in
            guard let self = self else { return }

            self.centerSpinner.stopAnimating()
            self.listMovie = listMovie
        }

    }

    private func loadData() {
        self.centerSpinner.startAnimating()
        self.model.getlistMovie()
    }

}

extension ListMovieViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listMovie.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId) as! ListMovieTableViewCell

        cell.configCellWith(movie: self.listMovie[indexPath.row])
        return cell

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1

        if (indexPath.section ==  lastSectionIndex) && (indexPath.row == lastRowIndex) {

            self.bottomSpinner.startAnimating()
            self.tableView.tableFooterView = self.bottomSpinner
            self.tableView.tableFooterView?.isHidden = false
            self.loadData()
        }
    }


}
