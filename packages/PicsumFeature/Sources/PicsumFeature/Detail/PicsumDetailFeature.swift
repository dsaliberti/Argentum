import ComposableArchitecture
import RestAPIClient
import SharedModels
import Sharing

/// A feature managing the details of a selected photo
@Reducer
public struct PicsumDetailFeature: Sendable {
  
  /// The dependency for making API requests
  @Dependency(\.restAPIClient) var restAPIClient
  
  /// The state representing the details of a selected photo
  @ObservableState
  public struct State: Equatable {
    
    /// A shared in-memory store for tracking favorite photo IDs
    @Shared(.inMemory("favorites")) var favorites: [PicsumItem.ID] = []
    
    /// The ID of the selected photo
    var selectedPhotoId: PicsumItem.ID
    
    /// The loaded photo details
    var loadedPhotoItem: PicsumItem? = nil
    
    /// An optional error message in case of a failed fetch
    var errorMessage: String? = nil
    
    /// Indicates if the photo details are currently being loaded
    var isLoading = false
    
    /// Initializes the state with a selected photo ID
    /// - Parameter selectedPhotoId: The ID of the photo to be loaded
    public init(selectedPhotoId: PicsumItem.ID) {
      self.selectedPhotoId = selectedPhotoId
    }
  }
  
  /// The available actions for the list feature
  public enum Action: Hashable {
    case task
    case detailUpdated(PicsumItem)
    case toggleFavorite(PicsumItem.ID)
    case detailUpdatedFailure(String)
    case didTapReload
  }
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .task:
        return doFetch(&state)
        
      case let .toggleFavorite(photoId):
        if state.favorites.contains(photoId) {
          state.$favorites.withLock {
            $0.removeAll(where: { $0 == photoId })
          }
        } else {
          state.$favorites.withLock {
            $0.append(photoId)
          }
        }
        return .none
        
      case let .detailUpdated(newValue):
        state.isLoading = false
        state.loadedPhotoItem = newValue
        return .none
      
      case let .detailUpdatedFailure(errorMessage):
        state.isLoading = false
        state.errorMessage = errorMessage
        return .none
        
      case .didTapReload:
        state.errorMessage = nil
        return doFetch(&state)
      }
    }
  }
  
  /// Shared functionality which fetches the details of the selected photo
  /// - Parameter state: The current state of the feature
  /// - Returns: An effect that updates the state with the fetched photo details
  func doFetch(_ state: inout State) -> Effect<Action> {
    state.isLoading = true
    return .run { [selectedId = state.selectedPhotoId] send in
      do {
        try await send(.detailUpdated(restAPIClient.fetchPhotoDetail(selectedId)))
      } catch {
        await send(.detailUpdatedFailure("Something went wrong, please try again"))
      }
    }
  }
}
