import SwiftUI
import SafariServices

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var isFavorited: Bool = false
    @State var showReviewPopup: Bool = false
    @State var userReview: String = ""
    @State private var showSafariView = false
    @State private var trailerKey: String?
    var movie: Movie
    let api = TMDBAPI()

    // DateFormatter für das deutsche Datumsformat
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // z.B. "3. Dezember 2024"
        formatter.locale = Locale(identifier: "de_DE") // Deutsche Lokalisierung
        return formatter
    }()

    // ISO 8601 Date Formatter zum Parsen des Formats "yyyy-MM-dd"
    private let isoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.title)
                            Text("Zurück")
                                .font(.body)
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    .frame(width: 150, height: 50)
                    .background(Color.black.opacity(0.7))
                    .clipShape(Capsule())

                    Spacer()

                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorited ? "star.fill" : "star")
                            .font(.title)
                            .foregroundColor(isFavorited ? .yellow : .gray)
                            .padding()
                    }
                    .padding(.trailing, 10)
                }
                .frame(height: 55)
                .background(Color.black)
                .padding(.horizontal)

                ScrollView {
                    VStack {
                        if let url = movie.fullPosterPath, let posterURL = URL(string: url) {
                            AsyncImage(url: posterURL) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            } placeholder: {
                                ProgressView()
                            }
                            .padding()
                        }

                        Text(movie.title)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(7)

                        // Überprüfen, ob das releaseDate korrekt in ein Date umgewandelt werden kann
                        if let releaseDate = movie.releaseDate,
                           let date = isoDateFormatter.date(from: releaseDate) {
                            Text("Veröffentlichung: \(dateFormatter.string(from: date))") // Anzeige im deutschen Format
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.bottom)
                        } else {
                            Text("Veröffentlichungsdatum nicht verfügbar")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom)
                        }

                        if let overview = movie.overview {
                            Text(overview)
                                .foregroundColor(.white)
                                .padding()
                        }

                        // Trailer-Button und Bewerten-Button nebeneinander
                        HStack {
                            if let trailerKey = trailerKey {
                                Button(action: { showSafariView.toggle() }) {
                                    HStack {
                                        Image(systemName: "play.fill")
                                        Text("Trailer ansehen")
                                    }
                                    .foregroundColor(.blue)
                                    .font(.body)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(10)
                                }
                                .sheet(isPresented: $showSafariView) {
                                    SafariView(url: URL(string: "https://www.youtube.com/watch?v=\(trailerKey)")!)
                                }
                            } else {
                                Text("Trailer nicht verfügbar")
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(10)
                            }

                            Spacer()

                            // Bewerten-Button
                            Button(action: {
                                showReviewPopup.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Bewerten")
                                }
                                .foregroundColor(.blue)
                                .font(.body)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal) // Buttons weiter vom Rand entfernt

                        Spacer()
                    }
                    .padding(.top, 10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showReviewPopup) {
            ReviewPopupView(reviewText: $userReview, movieTitle: movie.title, dismiss: {
                showReviewPopup = false
            })
        }
        .onAppear {
            loadFavoriteStatus()
            loadUserReview()
            fetchTrailer()
        }
    }

    func toggleFavorite() {
        isFavorited.toggle()
        UserDefaults.standard.set(isFavorited, forKey: "\(movie.id)_favorited")
    }

    func loadFavoriteStatus() {
        isFavorited = UserDefaults.standard.bool(forKey: "\(movie.id)_favorited")
    }

    func loadUserReview() {
        if let savedReview = UserDefaults.standard.string(forKey: "\(movie.title)_review") {
            userReview = savedReview
        }
    }

    func fetchTrailer() {
        api.fetchMovieVideos(movieID: movie.id) { key in
            DispatchQueue.main.async {
                trailerKey = key
            }
        }
    }
}

struct SafariView: View {
    var url: URL

    var body: some View {
        SafariViewController(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SafariViewController: UIViewControllerRepresentable {
    var url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
