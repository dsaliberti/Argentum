import SwiftUI
import ComposableArchitecture

/// A view that displays a list of photos, grouped by author
public struct PicsumListView: View {
  
  /// The store containing the state and actions for `PicsumListFeature`
  @Bindable var store: StoreOf<PicsumListFeature>
  
  /// Initializes the list view with a given store
  /// - Parameter store: The `StoreOf<PicsumListFeature>` containing state and actions
  public init(store: StoreOf<PicsumListFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      
      switch store.photos.count {
      case 0:
        if let errorMessage = store.errorMessage {
          
          /// Displays an error message with a reload button
          ErrorView(errorMessage: errorMessage) {
            store.send(.didTapReload)
          }
        } else {
          /// Displays either a loading indicator or an empty state message
          if store.isLoading {
            LoadingView()
          } else {
            EmptyListView()
          }
        }
        
      default:
        /// Displays a list of photos grouped by author
        List(store.photosByAuthor.keys.sorted(), id: \.self) { author in
          Section {
            ForEach(store.photosByAuthor[author] ?? [], id: \.id) { photo in
              HStack {
                /// Navigates to the photo detail view when tapped
                Button {
                  store.send(.didTapDetail(photo.id))
                } label: {
                  HStack {
                    /// Displays an asynchronously loaded photo
                    ArgentumAsyncImageView(url: URL(string: photo.downloadUrl)!)
                      .frame(width: 100, height: 100)
                      .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    /// Displays a summary of the photo
                    SummaryPhotoView(photo: photo)
                      .truncationMode(.tail)
                    
                    Spacer()
                  }
                  .frame(maxWidth: .infinity)
                  .contentShape(Rectangle()) // Expands the tappable area
                }
                
                Divider()
                
                /// Favorite toggle button for marking/unmarking a photo
                FavoriteToggleView(photo: photo) {
                  store.send(.toggleFavorite(photo))
                }
                .frame(width: 56)
                
              }
            }
          } header: {
            Text(author) // Displays the author's name as a section header
          }
        }
        .buttonStyle(.plain)
        .refreshable { 
          store.send(.didPullToRefresh)
        }
      }
    }
    /// Triggers data loading when the view appears
    .task {
      await store.send(.task).finish()
    }
    /// Displays the photo detail view in a sheet when a photo is selected
    .sheet(item: $store.scope(state: \.detail, action: \.detail)) { store in
      NavigationStack {
        PicsumDetailView(store: store)
      }
      .presentationDetents([.medium, .large])
    }
  }
}


#Preview {
  PicsumListView(
    store: StoreOf<PicsumListFeature>(
      initialState: PicsumListFeature.State(),
      reducer: {
        PicsumListFeature()
      }
    )
  )
}

