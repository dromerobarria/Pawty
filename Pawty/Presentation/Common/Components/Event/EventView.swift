import Foundation
import SwiftUI

struct EventView: View {
    @Bindable var event: EventModel
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            VStack(alignment: .leading) {
                Text(event.name)
                    .foregroundColor(.black)
                    .font(.title)
                    .bold()
                Text(event.detail)
                    .foregroundColor(.black)
                    .font(.title)
                    .bold()
                
                Text(event.location)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
                
                Text("At \(event.date.formatted(.dateTime.day().month(.wide).year()))")
                .bold()
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            }
            .padding(.leading, 20)
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
    
}
