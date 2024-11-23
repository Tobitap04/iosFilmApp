//
//  SearchViewModel.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchResults = [Movie]()
    
    private let tmdbService = TMDBService()
    
    func searchMovies(query: String) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=DEIN_TMDB_API_KEY&query=\(query)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = result.results
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}