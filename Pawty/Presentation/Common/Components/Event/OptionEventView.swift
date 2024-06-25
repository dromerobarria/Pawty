import SwiftUI
import SwiftData

struct OptionEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var eventModel: EventModel
    var modelContext: ModelContext
    @State private var isShowingSettings = false
   
    
    init(event: EventModel, modelContext: ModelContext) {
        self.eventModel = event
        self.modelContext = modelContext
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10){
                Text(eventModel.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                Text("-")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                Text(eventModel.detail)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                Spacer()
                
            }
            
            Text("On \(eventModel.location)")
            .bold()
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            
            Text("At \(eventModel.date.formatted(.dateTime.day().month(.wide).year()))")
            .bold()
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            
          
            HStack {
                Button {
                    isShowingSettings.toggle()
                } label: {
                    Text("Editar")
                        .frame(width: 150, height: 20)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                
                Button {
                    modelContext.delete(eventModel)
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                        .frame(height: 20)
                }
                .buttonStyle(.bordered)
                .tint(.pink)
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .frame(height: 20)
                }
                .buttonStyle(.bordered)
                .tint(.pink)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $isShowingSettings, onDismiss: didDismiss) {
            EditFormEventView(eventModel: eventModel, modelContext: modelContext)
        }
    }
    
    func didDismiss() {
        dismiss()
    }
}
