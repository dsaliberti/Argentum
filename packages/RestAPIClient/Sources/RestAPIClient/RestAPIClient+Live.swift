import ComposableArchitecture
import Foundation
import SharedModels

extension RestAPIClient: DependencyKey {
  
  public static let baseUrl: String = "https://picsum.photos"
  public static let timeout = 30.0
  
  public static var liveValue: Self {
    Self(
      fetchPhotosList: {
        let url = URL(string: "\(baseUrl)/v2/list")!
        let request = URLRequest(url: url, timeoutInterval: timeout)
        
        do {
          let (data, _) = try await URLSession.shared.data(for: request)
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          return try decoder.decode([PicsumItem].self, from: data)
        } catch {
          throw error
        }
      },
      fetchPhotoDetail: { id in
        let url = URL(string: "https://picsum.photos/id/\(id)/info")!
        let request = URLRequest(url: url, timeoutInterval: timeout)
        
        do {
          let (data, _) = try await URLSession.shared.data(for: request)
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          return try decoder.decode(PicsumItem.self, from: data)
        } catch {
          throw error
        }
      }
    )
  }
}
