import SwiftUI
import MapKit

struct UICMapView: View {

    @State private var region = UICServiceArea.region

    var body: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
    }
}

#Preview {
    UICMapView()
}
