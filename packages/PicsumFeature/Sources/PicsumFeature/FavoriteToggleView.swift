import SwiftUI
import SharedModels
import ComposableArchitecture

/// A view that allows users to toggle the favorite status of a photo
public struct FavoriteToggleView: View {
  
  public let photo: PicsumItem
  
  public let toggleFavorite: () -> Void
  
  var isFavorite: Bool
  
  init(photo: PicsumItem, isFavorite: Bool, toggleFavorite: @escaping () -> Void) {
    self.photo = photo
    self.toggleFavorite = toggleFavorite
    self.isFavorite = isFavorite
  }
  
  public var body: some View {
    Button(action: toggleFavorite) {
      
      let imageName = isFavorite ? "star.fill" : "star"
      
      Image(systemName: imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(
          isFavorite
          ? .yellow
          : .accentColor.opacity(0.9)
        )
        .frame(maxHeight: .infinity)
        .contentShape(Rectangle())
    }
  }
}

#Preview {
  FavoriteToggleView(photo: .mock, isFavorite: false) {}
}
