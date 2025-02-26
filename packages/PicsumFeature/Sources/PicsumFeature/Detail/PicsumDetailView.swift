import SwiftUI
import SwiftNavigation
import ComposableArchitecture

/// A View that displays the details of a photo
public struct PicsumDetailView: View {
  
  /// Bindable store for managing the state of the `PicsumDetailFeature`
  @Bindable var store: StoreOf<PicsumDetailFeature>
  
  /// Initializes the `PicsumDetailView` with a store for `PicsumDetailFeature`
  public init(store: StoreOf<PicsumDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      
      /// If the photo item is loaded and the download URL is valid, display the photo
      if let loadedPhotoItem = store.loadedPhotoItem,
         let url = URL(string: loadedPhotoItem.downloadUrl) {
        
        /// Async image view that loads the image from the provided URL and resizes it to the provided `height`
        ArgentumAsyncImageView(url: url, height: 250)
        
        /// A custom view to display a summary of the photo
        SummaryPhotoView(photo: loadedPhotoItem)
          .padding(16)
        
        /// A toggle to mark the photo as a favorite
        FavoriteToggleView(photo: loadedPhotoItem) { 
          store.send(.toggleFavorite(loadedPhotoItem.id))
        }
        .frame(width: .infinity)
        .frame(maxHeight: 100)
        .frame(minHeight: 50)
        
      } else {
        /// Display a placeholder image when no photo is loaded
        Image(systemName: "photo")
          .resizable()
          .frame(maxWidth: .infinity)
          .aspectRatio(contentMode: .fit)
          .padding(24)
          .foregroundStyle(Color.gray)
        
        /// Show a loading indicator if the photo details are still loading
        if store.isLoading {
          ProgressView("loading details...")
            .progressViewStyle(.automatic)
        }
        
        /// Display an error view if there was an issue loading the photo
        if let errorMessage = store.errorMessage {
          ErrorView(
            errorMessage: errorMessage,
            reload: {
              /// Trigger a reload action when the user taps reload
              store.send(.didTapReload)
            }
          )
        }
      }
      
      /// Spacer to push content to the top of the view
      Spacer()
    }
    /// Asynchronously trigger the task to load the photo details when the view is loaded
    .task {
      await store.send(.task).finish()
    }
  }
}

#Preview {
  
  @Previewable @State var isPresented = true
  
  Button {
    isPresented.toggle()
  } label: {
    Text("Present")
  }
  .sheet(isPresented: $isPresented) { 
    PicsumDetailView(
      store: StoreOf<PicsumDetailFeature>(
        initialState: PicsumDetailFeature.State(
          selectedPhotoId: "0"
        ),
        reducer: { PicsumDetailFeature()
        }
      )
    )
  }
}
