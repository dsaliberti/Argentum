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
      if let loadedPhotoItem = store.loadedPhotoItem {
        
        RemoteImageView(url: URL(string: loadedPhotoItem.downloadUrl))
          .frame(maxWidth: .infinity)
          .padding(.bottom, 16)
        
        HStack(alignment: .top, spacing: 16) {
          
          FavoriteToggleView(
            photo: loadedPhotoItem,
            isFavorite: store.favorites.contains(loadedPhotoItem.id)
          ) { 
            store.send(.toggleFavorite(loadedPhotoItem.id))
          }
          .frame(height: 65)
          
          SummaryPhotoView(photo: loadedPhotoItem)
          
        }
        .padding(.horizontal)
        
      } else {
        /// Display a placeholder image when no photo is loaded
        Image(systemName: "photo")
          .resizable()
          .frame(maxWidth: .infinity)
          .aspectRatio(contentMode: .fit)
          .padding(24)
          .foregroundStyle(Color.gray)
        
        if store.isLoading {
          ProgressView("loading details...")
            .progressViewStyle(.automatic)
        }
        
        /// Display an error view if there was an issue loading the photo
        if let errorMessage = store.errorMessage {
          ErrorView(
            errorMessage: errorMessage,
            reload: {
              store.send(.didTapReload)
            }
          )
        }
      }
      
      Spacer()
    }
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
        reducer: { PicsumDetailFeature() }
      )
    )
  }
}
