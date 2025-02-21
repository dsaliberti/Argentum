import ComposableArchitecture
import Foundation
import SharedModels

extension RestAPIClient: DependencyKey {
  
  public static var liveValue: Self {
    Self(
      fetchPhotosList: {
        let url = URL(string: "https://picsum.photos/v2/list")!
        let request = URLRequest(url: url, timeoutInterval: 30.0)
        
        do {
          let (data, _) = try await URLSession.shared.data(for: request)
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let foo = try decoder.decode([PicsumItem].self, from: data)
          return foo
        } catch {
          reportIssue("\(error.localizedDescription)")
          return []
        }
      },
      fetchPhotoDetail: { id in
        let url = URL(string: "https://picsum.photos/id/\(id)/info")!
        let request = URLRequest(url: url, timeoutInterval: 30.0)
        
        do {
          let (data, _) = try await URLSession.shared.data(for: request)
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let foo = try decoder.decode(PicsumItem.self, from: data)
          return foo
        } catch {
          reportIssue("\(error.localizedDescription)")
          throw error
        }
      }
    )
  }
}
