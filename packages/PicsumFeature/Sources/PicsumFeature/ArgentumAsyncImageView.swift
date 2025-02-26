import SwiftUI
import class UIKit.UIImage
import Foundation

public struct ArgentumAsyncImageView: View {
  @State private var image: Image?
  public let url: URL
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

extension UIImage {
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
