//
//  MovieCollectionsViewController.swift
//  Dismo 2
//
//  Created by Jehnsen Hirena Kane on 15/04/23.
//

import UIKit
import Shared
class MovieCollectionsViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: MovieCollectionsPresenterProtocol?
    
    init(genre: MovieGenre) {
        super.init(nibName: "MovieCollectionsViewController", bundle: Bundle(for: Self.self))
        title = genre.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        presenter?.getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadingView.stopAnimating()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewFlowLayout.itemSize = .init(width: 110, height: 160)
        collectionViewFlowLayout.minimumInteritemSpacing = 2
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionView.register(nibWithCellClass: MovieCollectionViewCell.self, at: MovieCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }
}

extension MovieCollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let totalMovies = presenter?.totalMovies else {
            return 0
        }
        return totalMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MovieCollectionViewCell.self, for: indexPath)
        if !isLoadingCell(for: indexPath) {
            cell.setupContent(presenter?.movies[indexPath.row].posterURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieId = presenter?.movies[indexPath.row].id else {
            popupAlert(title: "Error", message: "Something wrong, please try again later")
            return
        }
        presenter?.getMoviewDetail(movieId: movieId)
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension MovieCollectionsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            presenter?.getMovies()
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        guard let moviesAmount = presenter?.movies.count else {
            return false
        }
        return indexPath.row >= moviesAmount - 1
    }
}

extension MovieCollectionsViewController: MovieCollectionsViewProtocol {
    func showMovies(_ movies: [DiscoverMovie], _ totalMovies: Int, _ indexPathToReload: [IndexPath]?) {
        if let indexPathToReload = indexPathToReload {
            let newIndexPathToReload = visibleIndexPathsToReload(intersecting: indexPathToReload)
            collectionView.reloadItems(at: newIndexPathToReload)
        } else {
            collectionView.reloadData()
        }
    }

    func showErrorMessage(_ message: String) {
        popupAlert(title: "Error", message: message)
    }
}
