//
//  Jogo_MIS_ArchiveApp.swift
//  Jogo MIS Archive
//
//  Created by Isabella Brum on 12/02/26.
//

import SwiftUI

@main
struct Jogo_MIS_LegacyApp: App {
    init() {
        registerFont(named: "Fonteisabrumgibi-Bold.otf")
        registerFont(named: "Fonteisabrumgibi-Regular.otf")
        registerFont(named: "IsaBrumManuscrita-Regular.otf")
    }
    
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
}


