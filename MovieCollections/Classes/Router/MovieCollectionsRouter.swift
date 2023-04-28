//
//  MovieCollectionsRouter.swift
//  Dismo 2
//
//  Created by Jehnsen Hirena Kane on 16/04/23.
//

import UIKit
import Shared

public class MovieCollectionsRouter: MovieCollectionsRouterProtocol {
    public static func createMovieCollectionsModule(with genre: MovieGenre) -> UIViewController {
        let viewController: MovieCollectionsViewProtocol & UIViewController = MovieCollectionsViewController(genre: genre)
        let presenter: MovieCollectionsPresenterProtocol & MovieCollectionsInteractorOutputProtocol = MovieCollectionsPresenter()
        let interactor: MovieCollectionsInteractorInputProtocol = MovieCollectionInteractor()
        let router: MovieCollectionsRouterProtocol = MovieCollectionsRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        presenter.genre = genre
        interactor.presenter = presenter
        
        return viewController
    }
    
    func presentMovieDetailsScreen(from view: MovieCollectionsViewProtocol, for details: MovieDetails) {
//        let movieDetails = MovieDetailsRouter.createMovieDetailsModule(with: details)
//        guard let viewVC = view as? UIViewController else {
//            fatalError("Invalid View Protocol type")
//        }
//        viewVC.navigationController?.pushViewController(movieDetails, animated: true)
        Router.route?(.detailsPage(details: details))
    }
}
