import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Search Movies", text: $text)
                .padding(7)
                .padding(.leading, 0)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 10)
        }
        .frame(height: 40)
    }
}
