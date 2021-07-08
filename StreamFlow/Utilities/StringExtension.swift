//
//  StringExtension.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 04.07.21.
//

import Foundation
import UIKit

extension String {
    func indexOfSubString(of subString: String) -> Index? {
        range(of: subString, options: [])?.lowerBound
    }
}
