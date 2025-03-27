//
//  WebViewModel.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import SwiftUI
import Foundation

class WebViewModel: ObservableObject {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}
