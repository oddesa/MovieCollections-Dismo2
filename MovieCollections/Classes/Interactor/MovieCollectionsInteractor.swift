//
//  MovieCollectionsInteractor.swift
//  Dismo 2
//
//  Created by Jehnsen Hirena Kane on 16/04/23.
//

import Foundation
import Shared

class MovieCollectionInteractor: MovieCollectionsInteractorInputProtocol {
    weak var presenter: MovieCollectionsInteractorOutputProtocol?
    let provider = Movies.getProvider()
    
    func fetchMovieDetail(movieId: Int) {
        provider.request(.movieDetails(movieId: movieId)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                do {
                    self.presenter?.didGetMovieDetail(try response.map(MovieDetails.self))
                } catch {
                    self.presenter?.onError(message: error.localizedDescription)
                }
            case .failure(let error):
                self.presenter?.onError(message: error.localizedDescription)
            }
        }
    }
    
    func fetchMovies(_ genreId: Int, _ page: Int) {
        provider.request(.discoverMovies(genresId: [genreId], page: page)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let mappedResponse = try response.map(MoviePaginatedResponse<DiscoverMovie>.self)
                    let newPage = page + 1
                    guard let movies = mappedResponse.results, !movies.isEmpty else {
                        self.presenter?.didGetAllData()
                        return
                    }
                    self.presenter?.didGetMovies(movies,
                                                 mappedResponse.totalResults ?? 0,
                                                 newPage)
                } catch {
                    self.presenter?.onError(message: error.localizedDescription)
                }
            case .failure(let error):
                self.presenter?.onError(message: error.localizedDescription)
            }
        }
    }
}
