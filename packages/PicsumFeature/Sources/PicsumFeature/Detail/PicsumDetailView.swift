import SwiftUI
import SwiftNavigation
import ComposableArchitecture

public struct PicsumDetailView: View {
  
  @Bindable var store: StoreOf<PicsumDetailFeature>
  
  public init(store: StoreOf<PicsumDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      
      // 􀏅
      if let loadedPhotoItem = store.loadedPhotoItem,
         let url = URL(string: loadedPhotoItem.downloadUrl) {
        
        ArgentumAsyncImageView(url: url, height: 250)
        
        SummaryPhotoView(photo: loadedPhotoItem)
          .padding(16)
        
        // 􀋃
        FavoriteToggleView(photo: loadedPhotoItem) { 
          store.send(.toggleFavorite(loadedPhotoItem.id))
        }
        
      } else {
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
        reducer: { PicsumDetailFeature()
        }
      )
    )
  }
}
