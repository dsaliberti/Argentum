import SwiftUI
import Kingfisher

struct RemoteImageView: View {

  // 16:9
  private let processor = DownsamplingImageProcessor(size: CGSize(width: 1280, height: 720))
  let url: URL?

  var body: some View {
    KFImage(url)
      .placeholder {
        ProgressView()
      }
      .setProcessor(processor)
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}

#Preview {
  RemoteImageView(url: nil)
}
