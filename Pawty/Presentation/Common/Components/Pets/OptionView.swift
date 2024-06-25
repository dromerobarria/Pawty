import SwiftUI
import SwiftData

struct OptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var pet: PetModel
    var modelContext: ModelContext
    @State private var isShowingSettings = false
   
    
    init(pet: PetModel, modelContext: ModelContext) {
        self.pet = pet
        self.modelContext = modelContext
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10){
                Text(pet.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                Text("-")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                
                Text(pet.nickname)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                Spacer()
                
            }
            
            Text("Birthday at \(pet.birthDay.formatted(.dateTime.day().month(.wide).year()))")
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
                    modelContext.delete(pet)
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
            EditFormView(petModel: pet, modelContext: modelContext)
        }
    }
    
    func didDismiss() {
        dismiss()
    }
}
