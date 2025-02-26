import SwiftUI
import SharedModels
import ComposableArchitecture

/// A view that allows users to toggle the favorite status of a photo
public struct FavoriteToggleView: View {
  
  /// The photo associated with this favorite toggle
  public let photo: PicsumItem
  
  /// A closure that toggles the favorite state of the photo
  public let toggleFavorite: () -> Void
  
  /// A shared in-memory store for tracking favorite photo IDs
  @Shared(.inMemory("favorites")) var favorites: [PicsumItem.ID] = []
  
  public var body: some View {
    Button(action: toggleFavorite) {
      
      // Check if the photo is in the favorites list
      let isFavorite = favorites.contains(photo.id)
      
      // Choose the appropriate system image
      let imageName = isFavorite ? "star.fill" : "star"
      
      Image(systemName: imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(
          isFavorite
          ? .yellow // Highlighted when marked as favorite
          : .accentColor.opacity(0.9) // Default color
        )
        .frame(maxHeight: .infinity)
        .contentShape(Rectangle()) // Increases tappable area
    }
  }
}

#Preview {
  FavoriteToggleView(photo: .mock, toggleFavorite: {})
}
