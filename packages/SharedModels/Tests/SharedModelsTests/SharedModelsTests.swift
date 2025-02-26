import Testing
import Foundation
@testable import SharedModels

@Test func testJSONDecoding() async throws {
  let jsonString = """
   {
       "id": "0",
       "author": "Alejandro Escamilla",
       "width": 5000,
       "height": 3333,
       "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
       "download_url": "https://picsum.photos/id/0/5000/3333"
   }
  """
  
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  
  let model: PicsumItem = try decoder.decode(PicsumItem.self, from: jsonString.data(using: .utf8)!)
  
  #expect(model.id == "0")
  #expect(model.author == "Alejandro Escamilla")
  #expect(model.width == 5000)
  #expect(model.height == 3333)
  #expect(model.url == "https://unsplash.com/photos/yC-Yzbqy7PY")
  #expect(model.downloadUrl == "https://picsum.photos/id/0/5000/3333")
}
