import SwiftUI
import SharedModels
import ComposableArchitecture

public struct FavoriteToggleView: View {
  
  public let photo: PicsumItem
  public let toggleFavorite: () -> Void
  
  @Shared(.inMemory("favorites")) var favorites: [PicsumItem.ID] = []
  
  public var body: some View {
    // 􀋃
    Button(action: toggleFavorite) {
      
      let isFavorite = favorites.contains(photo.id)
      
      let imageName = isFavorite ? "star.fill" : "star"
      Image(systemName: imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 33)
        .foregroundStyle(
          isFavorite
          ? .yellow
          : .accentColor.opacity(0.9)
        )
        .frame(maxHeight: .infinity)
        .padding(.leading, 16)
        .contentShape(Rectangle())
    }
  }
}

#Preview {
  FavoriteToggleView(photo: .mock, toggleFavorite: {})
}

