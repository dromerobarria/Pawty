import SwiftUI
import PhotosUI
import SwiftData

struct EditFormView: View {
    @Environment(\.dismiss) var dismiss
    var modelContext: ModelContext
    var pet: PetModel?
    @State var petName:String = ""
    @State var petNickName: String = ""
    @State var breed: String = ""
    @State private var selectedDate: Date = .now
    @State private var counter: Int = 0
    @State private var selColorIndex = 0
    var colors: [(Color, petType)] = [
        (.orange, .cat),
        (.red, .dog),
        (.yellow, .exotic),
    ]
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var avatarData: Data?
    
    
    init(petModel: PetModel, modelContext: ModelContext) {
        self.modelContext = modelContext
        self.pet = petModel
        _petName = State(initialValue: petModel.name)
        _petNickName = State(initialValue: petModel.nickname)
        _breed = State(initialValue: petModel.breed)
        _selectedDate = State(initialValue: petModel.birthDay)
        if let index = colors.firstIndex(where: { $0.1 == petModel.kind }) {
            self.selColorIndex = index
            colors.rearrange(from: index, to: 0)
        }
        _avatarData = State(initialValue: petModel.image)
        guard let image = petModel.image else { return }
        _avatarImage = State(initialValue: createImage(image))
    }
    
    
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
                            withAnimation {
                                    save()
                                    dismiss()
                            }
                        }
                        .disabled(disableForm)
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Button("Cancel") {
                            withAnimation {
                                dismiss()
                            }
                        }
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
    }
    
    private func save() {
        if let pet {
            pet.name = petName
            pet.nickname = petNickName
            pet.breed = breed
            pet.birthDay = selectedDate
            pet.kind = colors[selColorIndex].1
        }
    }
    
    func createImage(_ value: Data) -> Image {
    #if canImport(UIKit)
        let songArtwork: UIImage = UIImage(data: value) ?? UIImage()
        return Image(uiImage: songArtwork)
    #elseif canImport(AppKit)
        let songArtwork: NSImage = NSImage(data: value) ?? NSImage()
        return Image(nsImage: songArtwork)
    #else
        return Image(systemImage: "some_default")
    #endif
    }
}


extension RangeReplaceableCollection where Indices: Equatable {
    mutating func rearrange(from: Index, to: Index) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indices")
        insert(remove(at: from), at: to)
    }
}

