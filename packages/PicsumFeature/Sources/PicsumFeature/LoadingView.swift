import SwiftUI

/// A View that represents a loading state
public struct LoadingView: View {
  public var body: some View {
    ContentUnavailableView {
      ProgressView()
      Text("Loading...")
    }
    .foregroundStyle(.opacity(0.7))
  }
}

#Preview {
  LoadingView()
}

