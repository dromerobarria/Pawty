import SwiftUI
import PhotosUI
import SwiftData

struct TextFormView: View {
    var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State var petName: String = ""
    @State var petNickName: String = ""
    @State var breed: String = ""
    @State private var selectedDate: Date = .now
    @State private var counter: Int = 0
    @State private var selColorIndex = 0
       let colors: [(Color, petType)] = [
        (.red, .dog),
        (.orange, .cat),
        (.yellow, .exotic),
       ]
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var avatarData: Data?
    
    var disableForm: Bool {
        petName.count < 2 || petNickName.count < 2 || breed.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name of your pet")) {
                    TextField("Tap to edit text", text: $petName)
                }
                
                Section(header: Text("Nickname of your pet"),
                        footer: Text("Add your funny nickname of your pet")) {
                    TextField("Tap to edit text", text: $petNickName)
                }
                Section(header: Text("Breed of your pet")) {
                    TextField("Tap to edit text", text: $breed)
                }
                Section(header: Text("Birthday"),
                        footer: Text("""
                      Please set up the birthday of your pet.
                      """
                                    )
                ) {
                    DatePicker("Please enter a time", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                }
                Section(header: Text("Type of pet"),
                        footer: Text("""
                      Set your kind of pet so we can desing the best style for it.
                      """
                                    )
                ) {
                    
                    Picker(selection: $selColorIndex,
                           label: pickerLabelView(
                            title: "Type of pet",
                            selColor: colors[selColorIndex].0)
                    ) {
                        ForEach(0 ..< colors.count, id: \.self) {
                            Text(self.colors[$0].1.description)
                        }
                    }
                }
                
                Section(header: Text("Photo of pet"),
                        footer: Text("""
                      Please share the good photo of your pet
                      """)
                ) {
                    
                    PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
                    avatarImage?
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 300, height: 300)
                }
                
                
              
                
                Section(header: Text("Are your sure?")) {
                    HStack{
                        Spacer()
                        Button("Save pet") {
                            let pet = PetModel(name: petName, birthDay: selectedDate, nickname: petNickName, breed: breed, kind: colors[selColorIndex].1, image: avatarData)
                            modelContext.insert(pet)
                            counter = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                
                                dismiss()
                            }
                        }
                        .disabled(disableForm)
                        Spacer()
                    }
                }
            }
        }
        .onChange(of: avatarItem) {
            Task {
                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                    avatarImage = loaded
                } else {
                    print("Failed")
                }
                
                if let loadedData = try? await avatarItem?.loadTransferable(type: Data.self) {
                    avatarData = loadedData
                } else {
                    print("Failed")
                }
            }
        }
        .confettiCannon(counter: $counter, num: 100)
    }
}


struct pickerLabelView: View {
    var title: String
    var selColor: Color

    var body: some View {
        HStack {
            Capsule()
                .fill(selColor)
                .frame(width: 15, height: 25)
            Text(title)
        }
    }
}
