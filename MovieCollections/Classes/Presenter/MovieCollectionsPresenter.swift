//
//  MovieCollectionsPresenter.swift
//  Dismo 2
//
//  Created by Jehnsen Hirena Kane on 16/04/23.
//

import Foundation
import Shared

class MovieCollectionsPresenter: MovieCollectionsPresenterProtocol {
    weak var view: MovieCollectionsViewProtocol?
    var interactor: MovieCollectionsInteractorInputProtocol?
    var router: MovieCollectionsRouterProtocol?
    
    var page = 1
    var genre: MovieGenre?
    var movies = [DiscoverMovie]()
    var alreadyGetAllData = false
    var totalMovies = 0

    
    func getMoviewDetail(movieId: Int) {
        interactor?.fetchMovieDetail(movieId: movieId)
    }
    
    func getMovies() {
        guard let genreId = genre?.id,
              alreadyGetAllData == false
        else {
            return
        }
        interactor?.fetchMovies(genreId, page)
    }
    
    
}

extension MovieCollectionsPresenter: MovieCollectionsInteractorOutputProtocol {
    func didGetMovies(_ movies: [DiscoverMovie], _ totalMovies: Int, _ page: Int) {
        self.movies += movies
        self.page = page
        let indexPathToReload = self.page == 2 ? nil : self.calculateIndexPathsToReload(from: movies)
        // There is inconsistency data in endpoint, do this so we can update the total movies data just in the first time we hit the endpoint
        if indexPathToReload == nil {
            self.totalMovies = totalMovies
        }
        view?.showMovies(movies, totalMovies, indexPathToReload)
    }

    func didGetMovieDetail(_ details: MovieDetails) {
        guard let view = view else {
            return
        }
        router?.presentMovieDetailsScreen(from: view, for: details)
    }
    
    func didGetAllData() {
        alreadyGetAllData = true
    }
    
    func onError(message: String) {
        view?.showErrorMessage(message)
    }
    
    private func calculateIndexPathsToReload(from newData: [DiscoverMovie]) -> [IndexPath] {
        let startIndex = movies.count - newData.count
        let endIndex = startIndex + newData.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
