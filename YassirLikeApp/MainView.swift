//
//  MainView.swift
//  YassirLikeApp
//
//  Created by Samy Mehdid on 20/5/2022.
//

import SwiftUI
import MapKit

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color(red: 0.014, green: 0.565, blue: 0.817))
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        ).onTapGesture {
            self.isOpen.toggle()
        }
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = 100
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .background(Color(red: 0, green: 0.663, blue: 0.965))
            .cornerRadius(0)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: 10)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}

struct MainView: View {
    let radius: CGFloat = 20
    var squareSide: CGFloat {
            2.0.squareRoot() * radius
        }
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
            self.showSheet = false
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: radius * 2, height: radius * 2)
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.black)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: squareSide, height: squareSide)
                }
                
            }
        }
    @State var destination = ""
    @State var location = ""
    @State var showSheet: Bool = false
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 25.7617,
                longitude: 80.1918
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 10,
                longitudeDelta: 10
            )
        )

    var body: some View {
        NavigationView{
                GeometryReader { geometry in
                    Map(coordinateRegion: $region).ignoresSafeArea()
                    BottomSheetView(
                        isOpen: self.$showSheet,
                        maxHeight: geometry.size.height
                    ) {
                        if(!self.showSheet){
                            ZStack{
                                Color(red: 0, green: 0.663, blue: 0.965)
                                VStack(alignment: HorizontalAlignment.leading, content: {
                                    Text("Content de vous voir, Bilal !").font(Font.title).bold().foregroundColor(Color.white)
                                    TextField("Où aller, alors ?", text: $destination).padding(EdgeInsets.init(top: 10, leading: 20, bottom: 10, trailing: 20)).background(Color.white).cornerRadius(15).onTapGesture {
                                        self.showSheet = true
                                    }
                                    Text("Vos destinations récentes").foregroundColor(Color.white)
                                    HStack{
                                        Image(systemName: "clock.arrow.circlepath").foregroundColor(Color.white)
                                        Text("Les dunes, el mohammadia, Alger").foregroundColor(Color.white.opacity(0.7))
                                    }
                                    Spacer()
                                }).padding(EdgeInsets.init(top: 60, leading: 30, bottom: 0, trailing: 30))
                            }
                        } else{
                             ZStack{
                                Color(red: 0, green: 0.663, blue: 0.965)
                                 VStack(alignment: HorizontalAlignment.leading) {
                                     VStack{
                                         HStack{
                                             Image("blueCircle").scaleEffect(2)
                                             TextField("Rue Hadji Messaoud, BEK", text: $location).padding(EdgeInsets.init(top: 0, leading: 5, bottom: 0, trailing: 0))
                                         }.padding().background(Color.white)
                                         HStack{
                                             Image("pinkCircle").scaleEffect(2)
                                             TextField("Destination", text: $destination).padding(EdgeInsets.init(top: 0, leading: 5, bottom: 0, trailing: 0))
                                         }.padding().background(Color.white)
                                     }.cornerRadius(10).padding(EdgeInsets.init(top: 0, leading: 30, bottom: 0, trailing: 30))
                                     VStack(alignment: HorizontalAlignment.leading, spacing: 20){
                                         HStack{
                                             Image("location").scaleEffect(2)
                                             Text("Current Loction").bold()
                                         }.foregroundColor(Color.white)
                                         HStack{
                                             Image(systemName: "map")
                                             Text("Set on map").bold()
                                         }.foregroundColor(Color.white)
                                     }.padding(EdgeInsets(top: 20, leading: 50, bottom: 10, trailing: 0))
                                     Divider().frame(height: 3).background(Color.white).padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                                     VStack(alignment: HorizontalAlignment.leading, spacing: 20){
                                         HStack{
                                             Image(systemName: "clock.arrow.circlepath")
                                             VStack(alignment: HorizontalAlignment.leading) {
                                                 Text("Les dunes, el mohammadia, Alger").bold()
                                                 Text("El Mohammadia").bold()
                                             }
                                         }.foregroundColor(Color.white)
                                         HStack{
                                             Image(systemName: "clock.arrow.circlepath")
                                             VStack(alignment: HorizontalAlignment.leading) {
                                                 Text("Rue bordj badji Moukhtar").bold()
                                                 Text("Algiers").bold()
                                             }
                                         }.foregroundColor(Color.white)
                                         HStack{
                                             Image(systemName: "clock.arrow.circlepath")
                                             VStack(alignment: HorizontalAlignment.leading) {
                                                 Text("Central park").bold()
                                                 Text("Bordj el kiffan").bold()
                                             }
                                         }.foregroundColor(Color.white)
                                         HStack{
                                             Image(systemName: "clock.arrow.circlepath")
                                             VStack(alignment: HorizontalAlignment.leading) {
                                                 Text("Rue Dahmane Remdani").bold()
                                                 Text("El Madania").bold()
                                             }
                                         }.foregroundColor(Color.white)
                                     }.padding(EdgeInsets.init(top: 10, leading: 50, bottom: 100, trailing: 0))
                                 }
                            }
                        }
                    }.ignoresSafeArea()
                }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.landscapeLeft)
            MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
