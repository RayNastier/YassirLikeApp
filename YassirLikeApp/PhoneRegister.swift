//
//  ContentView.swift
//  YassirLikeApp
//
//  Created by Samy Mehdid on 19/5/2022.
//

import SwiftUI
import CoreData
import iPhoneNumberField

struct PhoneRegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var text = ""
    @State var isEditing: Bool = false
    
    var btnBack : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left") // set image here
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
            }
        }

    var body: some View {
        NavigationView{
            ZStack {
                Color(red: 0, green: 0.663, blue: 0.965).ignoresSafeArea()
                VStack{
                    VStack(alignment: HorizontalAlignment.leading, content: {
                        Text("Salut ! Quel est votre numéro de téléphone ?").foregroundColor(Color.white).font(.title).bold().frame(maxWidth: 300).padding(EdgeInsets.init(top: 0, leading: 30, bottom: 0, trailing: 0))
                        iPhoneNumberField("(000) 000-0000", text: $text, isEditing: $isEditing)
                            .placeholderColor(Color.black)
                            .maximumDigits(10)
                            .clearButtonMode(.always)
                            .foregroundColor(Color.black).flagHidden(false)
                            .flagSelectable(true)
                            .accentColor(Color.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.3), radius: 5).padding(EdgeInsets(top: 20, leading: 20, bottom: 8, trailing: 20))
                            
                        Text("En cliquant sur 'Suivant', vous acceptez nos conditions générales.").foregroundColor(Color.white).frame(maxWidth: 270).padding(EdgeInsets(top: 10, leading: 40, bottom: 0, trailing: 0))
                        Spacer()
                    })
                    NavigationLink(destination: MainView()) {
                            HStack{
                                Text("Suivant")
                                    .padding(EdgeInsets.init(top: 0, leading: 70, bottom: 0, trailing: 60))
                                Image(systemName: "arrow.right")
                            }
                    }.foregroundColor(Color.white)
                        .frame(minWidth: 200)
                        .padding()
                        .background(Color(red: 0.976, green: 0.384, blue: 0.255))
                        .cornerRadius(20).padding(EdgeInsets.init(top: 0, leading: 0, bottom: 20, trailing: 0))
                }.padding(EdgeInsets.init(top: 40, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct PhoneRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneRegisterView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
