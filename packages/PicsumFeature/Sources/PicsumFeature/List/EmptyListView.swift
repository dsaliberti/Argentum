import SwiftUI

/// A View to use as a placeholder when eventually there's no photo in the list
/// i.e the fetch operation was successful and the payload has no photo
public struct EmptyListView: View {
  public var body: some View {
    ContentUnavailableView {
      Image(systemName: "questionmark.folder.fill")
      Text("No photos found")
    }
    .foregroundStyle(.opacity(0.7))
  }
}

#Preview {
  EmptyListView()
}

