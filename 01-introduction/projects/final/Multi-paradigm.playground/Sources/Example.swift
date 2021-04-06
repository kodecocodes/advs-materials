import Foundation

public func example(_ title: String,
                    code: () throws -> Void) rethrows {
  print("## \(title)")
  try code()
  print("---")
}
