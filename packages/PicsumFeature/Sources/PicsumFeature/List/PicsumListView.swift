import SwiftUI
import ComposableArchitecture

/// A view that displays a list of photos, grouped by author
public struct PicsumListView: View {
  
  @Bindable var store: StoreOf<PicsumListFeature>
  
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
          if store.isLoading {
            LoadingView()
          } else {
            EmptyListView()
          }
        }
        
      default:
        /// Displays a list of photos grouped by author
        List(store.authorsNamesSorted, id: \.self) { author in
          Section {
            ForEach(store.photosByAuthor[author] ?? [], id: \.id) { photo in
              HStack {
                
                Button {
                  store.send(.didTapDetail(photo.id))
                } label: {
                  
                  HStack {
                    RemoteImageView(url: URL(string: photo.downloadUrl))
                      .frame(width: 100, height: 100)
                      .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    SummaryPhotoView(photo: photo)
                      .truncationMode(.tail)
                    
                    Spacer()
                  }
                  .frame(maxWidth: .infinity)
                  .contentShape(Rectangle())
                }
                
                Divider()
                
                FavoriteToggleView(
                  photo: photo,
                  isFavorite: store.favorites.contains(photo.id)
                ) {
                  store.send(.toggleFavorite(photo))
                }
                .frame(width: 56)
                
              }
            }
          } header: {
            Text(author)
          }
        }
        .buttonStyle(.plain)
        .refreshable { 
          store.send(.didPullToRefresh)
        }
      }
    }
    .task {
      await store.send(.task).finish()
    }
    .sheet(item: $store.scope(state: \.detail, action: \.detail)) { store in
      NavigationStack {
        PicsumDetailView(store: store)
      }
      .presentationDetents([.large])
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

