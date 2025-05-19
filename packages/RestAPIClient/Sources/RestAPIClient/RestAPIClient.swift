import ComposableArchitecture
import DependenciesMacros
import SharedModels

@DependencyClient
public struct RestAPIClient: Sendable {
  public var fetchPhotosList: @Sendable () async throws -> [PicsumItem]
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
