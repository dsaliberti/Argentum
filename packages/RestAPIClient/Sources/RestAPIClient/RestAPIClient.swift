import ComposableArchitecture
import DependenciesMacros
import SharedModels

/// A dependency client for fetching photos from a REST API
@DependencyClient
public struct RestAPIClient: Sendable {
  
  /// A function to fetch a list of photos asynchronously
  public var fetchPhotosList: @Sendable () async throws -> [PicsumItem]
  
  /// A function to fetch the details of a specific photo asynchronously
  /// - Parameter id: The unique identifier of the photo
  public var fetchPhotoDetail: @Sendable (_ id: PicsumItem.ID) async throws -> PicsumItem
}

extension RestAPIClient: TestDependencyKey {
  public static var previewValue: RestAPIClient {
    RestAPIClient(
      fetchPhotosList: { .mock },
      fetchPhotoDetail: { _ in .mock }
    )
  }
}

extension DependencyValues {
  public var restAPIClient: RestAPIClient {
    get { self[RestAPIClient.self] }
    set { self[RestAPIClient.self] = newValue }
  }
}
