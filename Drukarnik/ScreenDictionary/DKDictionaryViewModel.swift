//
//  DKDictionaryViewModel.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import Foundation
import Combine

class DKDictionaryViewModel: ObservableObject {
    @Published var presentSearchText: String = ""
}
