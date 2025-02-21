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
        Text("Loading...")
      default:
        List(store.photosByAuthor.keys.sorted(), id: \.self) { author in
          
          Section {
            ForEach(store.photosByAuthor[author] ?? [], id: \.id) { photo in
              HStack {
                Button {
                  store.send(.didTapDetail(photo.id))
                } label: {
                  
                  HStack {
                    AsyncImage(url: URL(string: photo.downloadUrl)) { phase in
                      switch phase {
                        
                      case .success(let image):
                        image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                        
                      case let .failure(error):
                        //TODO: report issue, send failure to reducer
                        let _ = print(error.localizedDescription)
                        
                        Image(systemName: "photo.badge.exclamationmark")
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                          .task {
                            
                          }
                        
                      default: ProgressView()
                      }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    VStack(alignment: .leading) {
                      Text("Id: \(photo.id)")
                      Text("width: \(photo.width)")
                      Text("width: \(photo.width)")
                    }
                    .font(.caption)
                    
                    Spacer()
                  }
                  .frame(maxWidth: .infinity)
                  .contentShape(Rectangle())
                }
                
                Divider()
                
                // 􀋃
                Button {
                  store.send(.toggleFavorite(photo))
                } label: {
                  
                  let isFavorite = store.favorites.contains(photo.id)
                  
                  let imageName = isFavorite ? "star.fill" : "star"
                  Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 33)
                    .foregroundStyle(
                      isFavorite 
                      ? .yellow
                      : .black
                    )
                    .frame(maxHeight: .infinity)
                    .padding(.leading, 16)
                    .contentShape(Rectangle())
                }
              }
            }
          } header: {
            Text(author)
          }
        }
        .buttonStyle(.plain)
      }
    }
    
    .task {
      await store.send(.task).finish()
    }
    .sheet(item: $store.scope(state: \.detail, action: \.detail)) { store in
      NavigationStack {
        PicsumDetailView(store: store)
      }
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


