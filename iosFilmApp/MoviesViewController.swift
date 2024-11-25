import UIKit


class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var movies: [Movie] = []
    private var collectionView: UICollectionView!
    private var titleLabel: UILabel!
    private var toggleButton: UIButton!
    private var isNowPlaying = true  // Zum Umschalten zwischen aktuellen und zukünftigen Filmen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadMovies()
    }
    
    private func setupUI() {
        // Überschrift (Titel)
        titleLabel = UILabel()
        titleLabel.text = "Aktuelle Filme"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Umschalt-Button
        toggleButton = UIButton()
        toggleButton.setImage(UIImage(systemName: "gear"), for: .normal)  // Beispiel-Icon für den Button
        toggleButton.addTarget(self, action: #selector(toggleMovieType), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        
        // StackView für Überschrift und Button
        let stackView = UIStackView(arrangedSubviews: [titleLabel, toggleButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Constraints für StackView (Überschrift + Button)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        
        // Collection View für Filme
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 20) / 3, height: 200)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // Constraints für CollectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadMovies() {
        // Verwenden der richtigen Funktion, um Filme zu laden
        let apiCall: (@escaping ([Movie]?) -> Void) -> Void = isNowPlaying ? TMDBService.shared.getNowPlayingMovies : TMDBService.shared.getUpcomingMovies
        
        apiCall { [weak self] movies in
            DispatchQueue.main.async {
                if let movies = movies {
                    self?.movies = movies
                    self?.collectionView.reloadData()
                } else {
                    print("Fehler: Keine Filme gefunden.")
                }
            }
        }
    }
    
    // Button-Aktion zum Umschalten der Filmkategorie
    @objc private func toggleMovieType() {
        isNowPlaying.toggle()
        titleLabel.text = isNowPlaying ? "Aktuelle Filme" : "Zukünftige Filme"
        loadMovies()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
}



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
