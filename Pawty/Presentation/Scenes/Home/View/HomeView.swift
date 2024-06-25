import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    var modelContext: ModelContext
    @StateObject private var viewModel: HomeViewModel
    @State private var showingOptions = false
    @State private var showLogs = false
    @State private var selectedPet: PetModel?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _viewModel = StateObject(wrappedValue: HomeViewModel(fetchPetListUseCase: FetchPetListUseCase(petRepository: PetsRepositoryImplementation(modelContext: modelContext))))
        
        
    }
    
    @State private var timeOfTheDay = ""
    @State private var isShowingSettings = false
    @State private var isShowingLogs = false
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
            listView(petItems: viewData.petItems)
        case .error(let message):
            ContentUnavailableView {
                Label("Error for \"\(message)\"", systemImage: "doc.richtext.fill")
            } description: {
                Text("Try again.")
            }
        }
    }
}

private extension HomeView {

    func listView(petItems: [PetModel]) -> some View {
            List {
                Section {
                    ForEach(petItems) { pet in
                        Button(action: {
                            selectedPet = pet
                        }, label: {
                            PetView(pet: pet)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .overlay {
                if petItems.isEmpty{
                    ContentUnavailableView {
                        Label("No Pets", systemImage: "pawprint.circle")
                    } description: {
                        Text("Try to add a new Pet.")
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
                TextFormView(modelContext: modelContext)
            }
            .sheet(item: $selectedPet, onDismiss: {
                viewModel.handle(.onAppear)

            }) { pet in
                OptionView(pet: pet, modelContext: modelContext).presentationDetents([.fraction(0.18)])
            }
            .listStyle(.insetGrouped)
            .listRowSpacing(15)
            .navigationTitle("\(timeOfTheDay)")
            .onAppear {
                let hour = Calendar.current.component(.hour, from: Date())
                switch hour {
                case 6..<12 : timeOfTheDay = "Good morning☀️"
                case 12..<19 : timeOfTheDay = "Good evening 🌤️"
                default: timeOfTheDay = "Good night 🌑"
                }
            }
    }
    
    private func addItem() {
        withAnimation(.spring()) {
            isShowingSettings.toggle()
        }
    }
}


