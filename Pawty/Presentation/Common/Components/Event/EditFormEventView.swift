import SwiftUI
import PhotosUI
import SwiftData

struct EditFormEventView: View {
    @Environment(\.dismiss) var dismiss
    var modelContext: ModelContext
    var event: EventModel?
    @State var eventName:String = ""
    @State var eventDetail: String = ""
    @State var eventLocation: String = ""
    @State private var selectedDate: Date = .now
    @State private var counter: Int = 0
    @State private var selColorIndex = 0
    var colors: [(Color, eventType)] = [
     (.red, .medicament),
     (.orange, .operation),
     (.yellow, .veterinary),
    ]
    
    
    init(eventModel: EventModel, modelContext: ModelContext) {
        self.modelContext = modelContext
        self.event = eventModel
        _eventName = State(initialValue: eventModel.name)
        _eventDetail = State(initialValue: eventModel.detail)
        _eventLocation = State(initialValue: eventModel.location)
        _selectedDate = State(initialValue: eventModel.date)
        if let index = colors.firstIndex(where: { $0.1 == eventModel.kind }) {
            self.selColorIndex = index
            colors.rearrange(from: index, to: 0)
        }
    }
    
    
    var disableForm: Bool {
        eventName.isEmpty || eventDetail.isEmpty || eventLocation.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name of the Event")) {
                    TextField("Tap to edit text", text: $eventName)
                }
                
                Section(header: Text("Detail of the event"),
                        footer: Text("Add a little description of the event")) {
                    TextField("Tap to edit text", text: $eventDetail)
                }
                Section(header: Text("Location of the event")) {
                    TextField("Tap to edit text", text: $eventLocation)
                }
                Section(header: Text("Date"),
                        footer: Text("""
                      Please set up the date of the event.
                      """
                                    )
                ) {
                    DatePicker("Please enter a time", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                }
                Section(header: Text("Type of event"),
                        footer: Text("""
                      Set your type of event.
                      """
                                    )
                ) {
                    
                    Picker(selection: $selColorIndex,
                           label: pickerLabelView(
                            title: "Type of event",
                            selColor: colors[selColorIndex].0)
                    ) {
                        ForEach(0 ..< colors.count, id: \.self) {
                            Text(self.colors[$0].1.description)
                        }
                    }
                }
                    
                
                Section(header: Text("Are your sure?")) {
                    HStack{
                        Spacer()
                        Button("Save event") {
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
    }
    
    private func save() {
        if let event {
            event.name = eventName
            event.detail = eventDetail
            event.location = eventLocation
            event.date = selectedDate
            event.kind = colors[selColorIndex].1
        }
    }
}
