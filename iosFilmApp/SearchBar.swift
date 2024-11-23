
import SwiftUI

struct SearchBar: View {
    @Binding var query: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Titel, Schauspieler, Regisseur", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
        .padding([.top, .leading, .trailing])
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(query: .constant(""))
    }
}
