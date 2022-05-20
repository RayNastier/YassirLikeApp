//
//  YassirLikeAppApp.swift
//  YassirLikeApp
//
//  Created by Samy Mehdid on 19/5/2022.
//

import SwiftUI

@main
struct YassirLikeAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PhoneRegisterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
