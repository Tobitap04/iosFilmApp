import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    
    @State private var comment: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: MovieComment.entity(), sortDescriptors: [])
    private var movieComments: FetchedResults<MovieComment>

    var body: some View {
        ScrollView {
            VStack {
                Text(movie.title)
                    .font(.title)
                    .padding()
                Text(movie.overview)
                    .padding()
                TextField("Add a comment", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: saveComment) {
                    Text("Save Comment")
                }
                .padding()
                
                List {
                    ForEach(movieComments, id: \.self) { comment in
                        Text(comment.text ?? "")
                    }
                }
            }
        }
        .navigationBarTitle(movie.title, displayMode: .inline)
    }

    private func saveComment() {
        let newComment = MovieComment(context: viewContext)
        newComment.text = comment
        newComment.movieID = Int64(movie.id)
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving comment: \(error)")
        }
    }
}
