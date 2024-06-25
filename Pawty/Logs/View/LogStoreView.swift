import SwiftUI

struct LogStoreView: View {
    @StateObject private var store = LogStore()
    
    init (){}
    
    var body: some View {
        VStack{
            Text("I ❤️ logs :) ").font(.headline)
            List {
                Button {
                    Task {
                        try await store.saves(logs: store.logs)
                    }
                } label: {
                    Text("Save")
                }
                Button {
                    Task {
                        try await store.delete()
                    }
                } label: {
                    Text("Borrar")
                }

                Section {
                    ForEach(store.logs) { log in
                        VStack(alignment: .leading){
                            Text(log.title)
                                .font(.headline)
                                .accessibilityAddTraits(.isHeader)
                            Text(log.message)
                                .font(.subheadline)
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                            Label("\(log.date)", systemImage: "clock")
                                .accessibilityLabel("\(log.date) Date")
                            
                            Spacer()
                            
                            switch log.category {
                            case .success:
                                Label("😃 SUCCESS", systemImage: "poweroutlet.type.l")
                                    .accessibilityLabel("SUCCESS Type")
                            case .failed:
                                Label("🤒 FAILED", systemImage: "poweroutlet.type.l")
                                    .accessibilityLabel("FAILED Type")
                            case .warning:
                                Label("🤔 WARNING", systemImage: "poweroutlet.type.l")
                                    .accessibilityLabel("WARNING Type")
                            case .info:
                                Label("🐷 INFO", systemImage: "poweroutlet.type.l")
                                    .accessibilityLabel("INFO Type")
                            default:
                                Label("🐹 OTHER", systemImage: "poweroutlet.type.l")
                                    .accessibilityLabel("OTHER Type")
                            }
                            
                            Spacer()
                            
                            Text("VALUES LOG:")
                                .font(.subheadline)
                                .accessibilityAddTraits(.isHeader)
                            
                            ForEach(log.info, id: \.self) { info in
                                Text(info)
                            }
                            .padding(.horizontal)
                            .background(log.theme.accentColor)
                        }
                        .padding(.horizontal)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .task {
            Task {
                try await store.load()
            }
        }
    }
}
