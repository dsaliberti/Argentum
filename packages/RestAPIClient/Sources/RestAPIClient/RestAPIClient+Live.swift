import ComposableArchitecture
import Foundation
import SharedModels

extension RestAPIClient: DependencyKey {
  
  public static let baseUrl: String = "https://picsum.photos"
  public static let timeout = 30.0
  
  public static var liveValue: Self {
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    @Sendable
    func data(from request: URLRequest) async throws -> Data {
      return try await URLSession.shared.data(for: request).0
    } 
    
    return Self(
      fetchPhotosList: {
        let url = URL(string: "\(baseUrl)/v2/list")!
        let request = URLRequest(url: url, timeoutInterval: timeout)
        
        do {
          let data = try await data(from: request)
          return try decoder.decode([PicsumItem].self, from: data)
        } catch {
          throw error
        }
      },
      fetchPhotoDetail: { id in
        let url = URL(string: "\(baseUrl)/id/\(id)/info")!
        let request = URLRequest(url: url, timeoutInterval: timeout)
        
        do {
          let data = try await data(from: request)
          return try decoder.decode(PicsumItem.self, from: data)
        } catch {
          throw error
        }
      }
    )
  }
}
