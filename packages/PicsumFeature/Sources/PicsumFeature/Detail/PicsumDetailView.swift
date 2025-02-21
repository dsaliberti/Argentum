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
      if let loadedPhoto = store.loadedPhoto,
         let url = URL(string: loadedPhoto.downloadUrl) {
        
        AsyncImage(url: url) { phase in
          switch phase {
          case let .success(image):
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
            
          case let .failure(error):
            //TODO: report issue, send failure to reducer
            let _ = print(error.localizedDescription)
            
            Image(systemName: "photo.badge.exclamationmark")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .padding(24)
              .background(.red.opacity(0.2))
            
          default: ProgressView()
              .padding()
              .background(.gray.opacity(0.1))
            
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .frame(height: 250)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("**id:** \(loadedPhoto.id)")
          Text("**author:** \(loadedPhoto.author)")
          Text("**width:** \(loadedPhoto.width)")
          Text("**height:** \(loadedPhoto.height)")
          Text("**url:** \(loadedPhoto.url)")
          Text("**downloadUrl:** \(loadedPhoto.downloadUrl)")
        }
        .padding(16)
        
        // 􀋃
        Button {
          store.send(.toggleFavorite(loadedPhoto.id))
        } label: {
          
          let isFavorite = store.favorites.contains(loadedPhoto.id)
          
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
        
      } else {
        Image(systemName: "photo")
          .resizable()
          .frame(maxWidth: .infinity)
          .aspectRatio(contentMode: .fit)
          .padding(24)
          .foregroundStyle(Color.gray)
        
        ProgressView("loading details...")
          .progressViewStyle(.automatic)
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
        initialState: PicsumDetailFeature.State(selectedPhotoId: "0"),
        reducer: { PicsumDetailFeature() }
      )
    )
  }
}
