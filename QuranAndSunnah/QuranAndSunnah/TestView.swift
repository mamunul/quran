//
//  TestVIew.swift
//  QuranAndSunnah
//
//  Created by newone on 28/6/22.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack{
            Image("home-home_symbol")
                .foregroundColor(.red)
            Image("vuesax-bold-tick-circle")
                .foregroundColor(.blue)
                .dynamicTypeSize(.xxxLarge)
//                .background(.yellow)
        }
    }
}

struct TestVIew_Previews: PreviewProvider {
    static var previews: some View {
        TestView().previewLayout(.sizeThatFits)
    }
}
