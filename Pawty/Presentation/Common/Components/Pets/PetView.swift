import Foundation
import SwiftUI

struct PetView: View {
    @Bindable var pet: PetModel
    @State var kind = ""
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            Image.init(data: pet.image)?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            VStack{
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100, height: 74)
                    .foregroundColor(Color.white)
                    .overlay(
                        VStack {
                            Text(pet.name)
                                .font(.system(size: 35, weight: .regular))
                                .foregroundColor(.black)
                            Text(pet.breed)
                                .foregroundColor(.black)
                        }
                    )
            }
            .padding(.leading, 20)
            
            Spacer()
        }
        .onAppear(perform: {
            switch pet.kind {
            case .cat:
                kind = "cat"
            case .dog:
                kind = "dog"
            default:
                kind = "exotic"
            }
        })
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            Image(kind)
                .resizable(resizingMode: .tile)
                .opacity(0.2)
        )
    }
    
}


extension Image {
    /// Initializes a SwiftUI `Image` from data.
    init?(data: Data?) {
        guard let data = data else { return nil }
        
        #if canImport(UIKit)
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
        #elseif canImport(AppKit)
        if let nsImage = NSImage(data: data) {
            self.init(nsImage: nsImage)
        } else {
            return nil
        }
        #else
        return nil
        #endif
    }
}
