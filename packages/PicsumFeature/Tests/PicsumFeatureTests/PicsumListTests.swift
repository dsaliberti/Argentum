import SharedModels
import Testing
import ComposableArchitecture
@testable import PicsumFeature

@MainActor
struct PicsumListTests {
  
  /// Test for fetching a list of photos and ensuring the correct state is updated
  @Test 
  func testTask_fetchPhotoList() async {
    let store = TestStore(
      initialState: PicsumListFeature.State(),
      reducer: {
        PicsumListFeature()
      },
      withDependencies: {
        $0.restAPIClient.fetchPhotosList = { .mock }
      }
    )
    
    await store.send(.task) {
      $0.isLoading = true
    }
    
    await store.receive(.photosUpdated(.mock)) {
      $0.isLoading = false
      $0.photos = .mock
    }
  }
  
  /// Test for fetching a list of photos when there is an error in the API call
  @Test 
  func testTask_fetchPhotoListWithError() async {
    let store = TestStore(
      initialState: PicsumListFeature.State(),
      reducer: {
        PicsumListFeature()
      },
      withDependencies: {
        $0.restAPIClient.fetchPhotosList = {
          struct NewError: Error {}
          
          throw NewError()
        }
      }
    )
    
    await store.send(.task) {
      $0.isLoading = true
    }
    
    await store.receive(.photosUpdatedFailure("Something went wrong, please try again")) {
      $0.isLoading = false
      $0.errorMessage = "Something went wrong, please try again"
    }
  }
  
  /// Test for toggling the favorite state of a photo and ensuring the correct state is updated
  @Test 
  func testTask_toggleFavorite() async {
    let store = TestStore(
      initialState: PicsumListFeature.State(),
      reducer: {
        PicsumListFeature()
      }
    )
    
    await store.send(.toggleFavorite(.mock)) {
      $0.$favorites.withLock { $0 = [PicsumItem.mock.id] }
    }
    
    await store.send(.toggleFavorite(.mock)) {
      $0.$favorites.withLock { $0 = [] }
    }
  }
  
  /// Test for tapping on a photo detail and ensuring the correct navigation or action is triggered
  @Test 
  func testTask_didTapDetail() async {
    let store = TestStore(
      initialState: PicsumListFeature.State(),
      reducer: {
        PicsumListFeature()
      }
    )
    
    await store.send(.didTapDetail(PicsumItem.mock.id)) {
      $0.detail = PicsumDetailFeature.State(selectedPhotoId: PicsumItem.mock.id)
    }
  }
}
