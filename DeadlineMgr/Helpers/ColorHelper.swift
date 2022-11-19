//
//  ColorHelper.swift
//  DeadlineMgr
//
//  Created by Sophie on 11/17/22.
//

import SwiftUI

struct ColorHelper: View {
    @State private var bgColor = Color.blue
    
    var body: some View {
        VStack {
            ColorPicker("Set the background color", selection: $bgColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(bgColor)
    }
}

struct ColorHelper_Previews: PreviewProvider {
    static var previews: some View {
        ColorHelper()
    }
}
