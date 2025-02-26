import SwiftUI
import ComposableArchitecture

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
        List(store.photosByAuthor.keys.sorted(), id: \.self) { author in
          Section {
            ForEach(store.photosByAuthor[author] ?? [], id: \.id) { photo in
              HStack {
                Button {
                  store.send(.didTapDetail(photo.id))
                } label: {
                  
                  HStack {
                    ArgentumAsyncImageView(url: URL(string: photo.downloadUrl)!)
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
                
                FavoriteToggleView(photo: photo) {
                  store.send(.toggleFavorite(photo))
                }
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

