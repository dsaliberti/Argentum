import SwiftUI

/// A view that displays an error message with a reload button
public struct ErrorView: View {
  
  let errorMessage: String
  
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
