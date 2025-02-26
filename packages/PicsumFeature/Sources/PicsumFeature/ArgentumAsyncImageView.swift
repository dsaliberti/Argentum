import SwiftUI
import class UIKit.UIImage
import Foundation

/// A view that asynchronously loads, displays an image from a given URL
/// and resizes proportionally to the given `height`
public struct ArgentumAsyncImageView: View {
  
  /// The downloaded image, if available
  @State private var image: Image?
  
  /// The URL of the image to be loaded
  public let url: URL
  
  /// The height of the displayed image (defaults to 100)
  public var height: Int = 100
  
  public var body: some View {
    ZStack {
      if let image {
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      } else {
        ProgressView()
      }
    }
    .frame(height: CGFloat(height))
    .task(id: url, priority: .background) {
      do {
        guard !Task.isCancelled else { return }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let image = UIImage(data: data) {
          withAnimation { 
            self.image = Image(uiImage: image.aspectFittedToHeight(CGFloat(height)))
          }
        }
      } catch {
        print("Image failed to load with error:", error.localizedDescription)
      }
    }
  }
}

/// An extension to scale a `UIImage` while maintaining its aspect ratio
extension UIImage {
  
  /// Resizes the image to fit a given height while preserving the aspect ratio
  /// - Parameter newHeight: The target height for the image
  /// - Returns: A new `UIImage` scaled to fit the specified height
  func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
    let scale = newHeight / self.size.height
    let newWidth = self.size.width * scale
    let newSize = CGSize(width: newWidth, height: newHeight)
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    return renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
  }
}

#Preview {
  @Previewable @State
  var height = 200
  
  ArgentumAsyncImageView( 
    url: URL(string: "https://picsum.photos/id/2/5000/3333")!,
    height: height
  )
  .frame(height: CGFloat(height))
  .clipShape(Rectangle())
}
