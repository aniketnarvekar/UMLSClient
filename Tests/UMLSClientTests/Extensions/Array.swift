//  Array.swift

extension Array {

  func every(completion: (Element) -> Bool) -> Bool {
    for element in self {
      guard completion(element) else {
        return false
      }
    }
    return true
  }

  func some(completion: (Element) -> Bool) -> Bool {
    for element in self {
      guard completion(element) else {
        continue
      }
      return true
    }
    return false
  }

}
