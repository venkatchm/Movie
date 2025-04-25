//
//  TappableAttributedText.swift
//  RickyBuggy
//
//  Created by Venkatachalam Perumal on 23/01/25.
//
import SwiftUI

struct TappableAttributedText: View {
    
    private let attributedString: AttributedString
    
    init(_ string: String) {
        var attributedString = AttributedString(string)
        attributedString.link = URL(string: string)
        
        self.attributedString = attributedString
        
    }
    
    var body: some View {
        Text(attributedString)
            .environment(\.openURL, OpenURLAction { url in
                return .systemAction
            })
    }
}
