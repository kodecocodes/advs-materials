/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI

struct ArticleRow: View {
  let article: Article
  let image: Binding<UIImage?>

  var body: some View {
    HStack(alignment: .top) {
      if let image = article.downloadedImage {
        Image(uiImage: image)
          .resizable()
          .frame(width: 85, height: 85)
          .cornerRadius(16)
      } else {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color.gray)
          .frame(width: 85, height: 85)
      }
      VStack(alignment: .leading) {
        Text(article.name).bold()
        Text(article.description)
      }
      .padding(.top, 3)
    }
    .frame(height: 100)
  }
}

#Preview {
  ArticleRow(article: Article.preview, image: .constant(nil))
}
