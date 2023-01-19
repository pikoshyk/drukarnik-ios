//
//  NSAttributedString.swift
//  Drukarnik
//
//  Created by Logout on 23.12.22.
//

import Foundation

extension NSAttributedString {
    class func string(htmlData: Data ) throws -> NSAttributedString? {
#if targetEnvironment(macCatalyst)
        let encoding = String.Encoding.utf8.rawValue
#elseif os(iOS)
        let encoding = NSUTF8StringEncoding
#endif
        return try NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: encoding ], documentAttributes: nil)
    }
}
