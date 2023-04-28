//
//  MovieCollectionsProtocol.swift
//  Dismo 2
//
//  Created by Jehnsen Hirena Kane on 16/04/23.
//

import UIKit
import Shared

protocol MovieCollectionsPresenterProtocol: AnyObject {
    var view: MovieCollectionsViewProtocol? { get set }
    var interactor: MovieCollectionsInteractorInputProtocol? { get set }
    var router: MovieCollectionsRouterProtocol? { get set }
    
    var page: Int { get set }
    var genre: MovieGenre? { get set }
    var movies: [DiscoverMovie] { get set }
    var alreadyGetAllData: Bool { get set }
    var totalMovies: Int { get set }

    
    // VIEW -> PRESENTER
    func getMoviewDetail(movieId: Int)
    func getMovies()
}

protocol MovieCollectionsViewProtocol: AnyObject {
    var presenter: MovieCollectionsPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func showMovies(_ movies: [DiscoverMovie], _ totalMovies: Int, _ indexPathToReload: [IndexPath]?)
    func showErrorMessage(_ message: String)
}

protocol MovieCollectionsInteractorInputProtocol: AnyObject {
    var presenter: MovieCollectionsInteractorOutputProtocol? { get set }
    
    // PRESENTER -> INTERACTOR
    func fetchMovieDetail(movieId: Int)
    func fetchMovies(_ genreId: Int, _ page: Int)
}

protocol MovieCollectionsInteractorOutputProtocol: AnyObject {
    
    // INTERACTOR -> PRESENTER
    func didGetMovieDetail(_ details: MovieDetails)
    func didGetAllData()
    func didGetMovies(_ movies: [DiscoverMovie], _ totalMovies: Int, _ page: Int)
    func onError(message: String)
}

protocol MovieCollectionsRouterProtocol: AnyObject {
    static func createMovieCollectionsModule(with genre: MovieGenre) -> UIViewController
    
    // PRESENTER -> ROUTER
    func presentMovieDetailsScreen(from view: MovieCollectionsViewProtocol, for details: MovieDetails)
}
