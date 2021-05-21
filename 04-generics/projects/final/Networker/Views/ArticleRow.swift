/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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

struct ArticleRow_Previews: PreviewProvider {
  static let article = Article(
    name: "Protocols by Tutorials",
    description: "Learn all about protocols.",
    // swiftlint:disable:next force_unwrapping
    image: URL(string: "https://google.com")!,
    id: "0")

  static var previews: some View {
    Group {
      ArticleRow(article: article, image: .constant(nil))
        .previewLayout(.fixed(width: 300, height: 100))
    }
  }
}
