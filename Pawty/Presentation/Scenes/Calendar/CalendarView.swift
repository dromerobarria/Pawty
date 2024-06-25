import SwiftUI
import SwiftData

struct CalendarView: View {
    var modelContext: ModelContext
    @StateObject private var viewModel: EventViewModel
    @State private var showingOptions = false
    @State private var selectedEvent: EventModel?
    @State private var favoriteInfo = "List"
    var information = ["List"]
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _viewModel = StateObject(wrappedValue: EventViewModel(fetchPetListUseCase: FetchPetListUseCase(petRepository: PetsRepositoryImplementation(modelContext: modelContext))))
    }
    @State private var isShowingSettings = false
    
    var body: some View {
        contentView
            .redacted(if: viewModel.state == .loading)
            .backgroundColor()
            .onAppear {
                viewModel.handle(.onAppear)
            }
    }
    
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()

        case .loading:
            EmptyView()

        case .loaded(let viewData):
            listView(events: viewData.eventsItems)
        case .error(let message):
            ContentUnavailableView {
                Label("Error for \"\(message)\"", systemImage: "doc.richtext.fill")
            } description: {
                Text("Try again.")
            }
        }
    }
}

private extension CalendarView {

    func listView(events: [EventModel]) -> some View {
        VStack {
            Picker("Calendar", selection: $favoriteInfo) {
                ForEach(information, id: \.self) {
                    Text($0)
                }
            }
            .padding(.horizontal, 16)
            .pickerStyle(.segmented)
            
            ZStack{
                List {
                    Section {
                        ForEach(events) { event in
                            Button(action: {
                                selectedEvent = event
                            }, label: {
                                EventView(event: event)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .overlay {
                    if events.isEmpty{
                        ContentUnavailableView {
                            Label("No Events", systemImage: "pawprint.circle")
                        } description: {
                            Text("Try to add a new event.")
                        }
                    }
                }
                .refreshable {
                    viewModel.handle(.onAppear)
                }
                .toolbar {
                    ToolbarItem {
                        
                        Button(action: addItem) {
                            Label("Add Pet", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isShowingSettings, onDismiss: {
                    viewModel.handle(.onAppear)

                }) {
                    TextFormEventView(modelContext: modelContext)
                }
                .sheet(item: $selectedEvent, onDismiss: {
                    viewModel.handle(.onAppear)

                }) { event in
                    OptionEventView(event: event, modelContext: modelContext).presentationDetents([.fraction(0.18)])
                }
                .opacity(favoriteInfo == "List" ? 1 : 0)
                .listStyle(.insetGrouped)
                .listRowSpacing(15)
                .navigationTitle("Calendar")
                
                
                
                ShortCalendarView(calendar: Calendar(identifier: .gregorian))
                    .opacity(favoriteInfo == "Calendar" ? 1 : 0)
            }
        }
        .task {
            try? await LogStore.shared.addLog(log: DailyLogs(title: "2", message: "2", category: .warning))
        }
    }
    
    private func addItem() {
        withAnimation(.spring()) {
            isShowingSettings.toggle()
        }
    }
}
