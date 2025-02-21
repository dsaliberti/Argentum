import SwiftUI
import ComposableArchitecture
import PicsumFeature

struct ContentView: View {
  let store = StoreOf<PicsumListFeature>(
    initialState: PicsumListFeature.State(), 
    reducer: {
      PicsumListFeature()
    }
  )
  
  var body: some View {
    PicsumListView(store: store)
  }
}

#Preview {
  ContentView()
}
