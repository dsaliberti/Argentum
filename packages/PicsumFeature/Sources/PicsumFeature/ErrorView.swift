import SwiftUI

/// A view that displays an error message with a reload button
public struct ErrorView: View {
  
  /// The error message to be displayed
  let errorMessage: String
  
  /// A callback function triggered when the reload button is tapped
  let reload: () -> Void
  
  public var body: some View {
    VStack {
      Image(systemName: "exclamationmark.octagon.fill")
        .resizable()
        .renderingMode(.template)
        .aspectRatio(contentMode: .fit)
        .frame(width: 40)
        .foregroundStyle(.red.opacity(0.7))
      
      Text(errorMessage)
        .foregroundStyle(.opacity(0.7))
      
      Button(action: reload) {
        Text("Reload")
      }
      .buttonStyle(BorderedButtonStyle())
    }
  }
}

#Preview {
  ErrorView(errorMessage: "Oops") { }
}
