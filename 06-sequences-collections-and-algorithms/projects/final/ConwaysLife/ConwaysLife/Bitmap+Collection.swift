/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

/// Make Bitmap conform to some useful collection protocols.
extension Bitmap: RandomAccessCollection, MutableCollection {
  /// Index stores row, column locations of a Bitmap.  It assumes row-major order
  /// where row is considered before column.
  @usableFromInline
  struct Index: Comparable {
    @inlinable static func < (lhs: Index, rhs: Index) -> Bool {
      (lhs.row, lhs.column) < (rhs.row, lhs.column)
    }
    var row, column: Int
  }

  /// Start of the Bitmap is the upper-left corner.
  @inlinable var startIndex: Index {
    Index(row: 0, column: 0)
  }

  /// Forward traversal takes place in raster-order.
  @inlinable var endIndex: Index {
    Index(row: height, column: 0)
  }

  /// Forward traversal required by collections. Raster-scan order.
  @inlinable func index(after i: Index) -> Index {
    i.column < width-1 ?
      Index(row: i.row, column: i.column+1) :
      Index(row: i.row+1, column: 0)
  }

  /// Reverse traversal required by bidirectional collections.  Raster-scan order.
  @inlinable func index(before i: Index) -> Index {
    i.column > 0 ?
      Index(row: i.row,   column: i.column-1) :
      Index(row: i.row-1, column: width-1)
  }
  ///　Requred by RandomAccessCollection.  Advance in raster-scan order.
  @inlinable func index(_ i: Index, offsetBy distance: Int) -> Index {
    Index(row: i.row + distance / width, column: i.column + distance % width)
  }

  /// Distance between two points in raster-scan order.
  @inlinable func distance(from start: Index, to end: Index) -> Int {
    (end.row * width + end.column) - (start.row * width + start.column)
  }

  /// Convenience method.  Create an index by offsettng the row and column.
  /// The result index is not necessarily contained in the collection.
  @inlinable func index(of i: Index, rowOffset: Int, columnOffset: Int) -> Index {
    Index(row: i.row + rowOffset, column: i.column + columnOffset)
  }

  /// Convenience method for determining if an index is in bounds.
  @inlinable func contains(index: Index) -> Bool {
    return (0..<width).contains(index.column) && (0..<height).contains(index.row)
  }

  @inlinable subscript(position: Index) -> Pixel {

    /// Required by collections.
    get {
      precondition(contains(index: position), "out of bounds index \(position)")
      return pixels[position.row * width + position.column]
    }

    /// MutableCollection requirement.  It does not invalidate indicies.
    set {
      precondition(contains(index: position), "out of bounds index \(position)")
      pixels[position.row * width + position.column] = newValue
    }
  }
}

