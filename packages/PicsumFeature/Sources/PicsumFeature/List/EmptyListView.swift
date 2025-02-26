import SwiftUI

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

