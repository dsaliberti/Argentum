import SharedModels
import SwiftUI

/// A View to show a stack of texts
/// e.g like a visual table
public struct SummaryPhotoView: View {
  public let photo: PicsumItem
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("**Id:** \(photo.id)")
      Text("**Author:** \(photo.author)")
      Text("**Width:** \(photo.width)")
      Text("**Height:** \(photo.height)")
      Text("**url:** \(photo.url)")
      Text("**downloadUrl:** \(photo.downloadUrl)")
    }
    .font(.caption)
  }
}

#Preview {
  SummaryPhotoView(photo: .mock)
}
