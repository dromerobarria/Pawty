import SwiftUI
import PhotosUI
import SwiftData

struct TextFormEventView: View {
    var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State var eventName: String = ""
    @State var eventLocation: String = ""
    @State var eventDetail: String = ""
    @State private var selectedDate: Date = .now
    @State private var counter: Int = 0
    @State private var selColorIndex = 0
       let colors: [(Color, eventType)] = [
        (.red, .medicament),
        (.orange, .operation),
        (.yellow, .veterinary),
       ]
    
    var disableForm: Bool {
        eventName.isEmpty || eventLocation.isEmpty || eventDetail.isEmpty
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
                            let event = EventModel(name: eventName, date: selectedDate, location: eventLocation, detail: eventDetail, kind: colors[selColorIndex].1)
                            modelContext.insert(event)
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
        .confettiCannon(counter: $counter, num: 100)
    }
}
