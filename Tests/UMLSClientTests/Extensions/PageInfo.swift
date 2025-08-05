//  PageInfo.swift

import UMLSClient
import UMLSClientModel

extension PageInfo {

  func count(using totalSize: UInt) -> UInt {
    var count = totalSize / size
    count += totalSize % size > 0 ? 1 : 0
    return count + 1
  }

  var pageCountUsingEnvironment: UInt {
    count(using: UMLSClient.getTestContentSize())
  }

}
