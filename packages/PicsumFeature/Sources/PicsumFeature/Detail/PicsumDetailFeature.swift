import ComposableArchitecture
import RestAPIClient
import SharedModels
import Sharing

@Reducer
public struct PicsumDetailFeature: Sendable {
  
  @Dependency(\.restAPIClient) var restAPIClient
  
  @ObservableState
  public struct State: Equatable {
    
    @Shared(.inMemory("favorites")) var favorites: [PicsumItem.ID] = []
    
    var selectedPhotoId: PicsumItem.ID
    var loadedPhoto: PicsumItem? = nil
    var errorMessage: String? = nil
    
    public init(selectedPhotoId: PicsumItem.ID) {
      self.selectedPhotoId = selectedPhotoId
    }
  }
  
  public enum Action: Hashable {
    case task
    case detailUpdated(PicsumItem)
    case toggleFavorite(PicsumItem.ID)
    case detailUpdatedFailure(String)
  }
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .task:
        
        return .run { [selectedId = state.selectedPhotoId] send in
          do {
            try await send(.detailUpdated(restAPIClient.fetchPhotoDetail(selectedId)))
          } catch {
            await send(.detailUpdatedFailure("Something went wrong, please try again"))
          }
        }
        
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
        state.loadedPhoto = newValue
        return .none
      
      case let .detailUpdatedFailure(errorMessage):
        state.errorMessage = errorMessage
        return .none
      }
    }
  }
}
