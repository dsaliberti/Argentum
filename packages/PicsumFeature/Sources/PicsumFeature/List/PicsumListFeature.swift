import ComposableArchitecture
import RestAPIClient
import SharedModels
import Sharing

@Reducer
public struct PicsumListFeature: Sendable {
  
  @Dependency(\.restAPIClient) var restAPIClient
  
  @ObservableState
  public struct State: Equatable {
    
    public var photos: [PicsumItem] = []
    
    var photosByAuthor: [String: [PicsumItem]] {
      Dictionary(grouping: photos, by: \.author)
    }
    
    @Shared(.inMemory("favorites")) var favorites: [PicsumItem.ID] = []
    
    @Presents var detail: PicsumDetailFeature.State?
    
    var isSelectedDetail = false
    
    var errorMessage: String? = nil
    var isLoading = false
    public init(photos: [PicsumItem] = []) {
      self.photos = photos
    }
  }
  
  public enum Action: Hashable {
    case task
    case photosUpdated([PicsumItem])
    case photosUpdatedFailure(String)
    case toggleFavorite(PicsumItem)
    case didTapDetail(PicsumItem.ID)
    case detail(PresentationAction<PicsumDetailFeature.Action>)
    case didTapReload
  }
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    
    Reduce { state, action in
      switch action {
      case .task:
        state.isLoading = true
        return doFetch(&state)
        
      case .didTapReload:
        state.errorMessage = nil
        return doFetch(&state)
        
      case let .photosUpdated(photos):
        state.isLoading = false
        state.photos = photos
        return .none
        
      case let .toggleFavorite(photo):
        
        if state.favorites.contains(photo.id) {
          state.$favorites.withLock {
            $0.removeAll(where: { $0 == photo.id })
          }
        } else {
          state.$favorites.withLock {
            $0.append(photo.id)
          }
        }
        
        return .none
        
      case let .didTapDetail(itemId):
        state.detail = PicsumDetailFeature.State(selectedPhotoId: itemId)
        return .none
        
      case .detail: 
        return .none
        
      case let .photosUpdatedFailure(errorMessage):
        state.isLoading = false
        state.errorMessage = errorMessage
        return .none
      }
    }
    .ifLet(\.$detail, action: \.detail) {
      PicsumDetailFeature()
    }
  }
  
  func doFetch(_ state: inout State) -> Effect<Action> {
    state.isLoading = true
    return .run { send in
      do {
        try await send(.photosUpdated(restAPIClient.fetchPhotosList()))
      } catch {
        await send(
          .photosUpdatedFailure(
            "Something went wrong, please try again"
          )
        )
      }
    }
  }
}
