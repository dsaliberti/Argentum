import SharedModels
import Testing
import ComposableArchitecture
@testable import PicsumFeature

@MainActor
struct PicsumDetailTests {
  
  @Test 
  func testTask_fetchPhotoDetails() async {
    let store = TestStore(
      initialState: PicsumDetailFeature.State(selectedPhotoId: PicsumItem.mock.id),
      reducer: {
        PicsumDetailFeature()
      },
      withDependencies: {
        $0.restAPIClient.fetchPhotoDetail = { @MainActor _ in .mock }
      }
    )
    
    await store.send(.task)
    
    await store.receive(.detailUpdated(.mock)) {
      $0.loadedPhotoItem = .mock
    }
  }
  
  @Test
  func test_fetchPhotoDetailsWithError() async {
    let store = TestStore(
      initialState: PicsumDetailFeature.State(selectedPhotoId: PicsumItem.mock.id),
      reducer: {
        PicsumDetailFeature()
      },
      withDependencies: {
        $0.restAPIClient.fetchPhotoDetail = { @MainActor _ in
          struct NewError: Error {}
          
          throw NewError()
        }
      }
    )
    
    await store.send(.detailUpdatedFailure("Something went wrong, please try again")) {
      $0.errorMessage = "Something went wrong, please try again"
    }
    
  }
  
  @Test
  func testToggleFavorite() async {
    let store = TestStore(
      initialState: PicsumDetailFeature.State(selectedPhotoId: PicsumItem.mock.id),
      reducer: {
        PicsumDetailFeature()
      }
    )
    
    // on
    await store.send(.toggleFavorite("0")) {
      $0.$favorites.withLock { $0 = ["0"] }
    }
    
    // off
    await store.send(.toggleFavorite("0")) {
      $0.$favorites.withLock { $0 = [] }
    }
  }  
}
