//
//  StartButtonView.swift
//  day4
//
//  Created by Doeun Kwon on 2024-09-15.
//

import SwiftUI

struct StartButtonView: View {
    
    let getAction: () -> Void
    
    var body: some View {
        Button(action: getAction, label: {
            Text(Strings.startButtonTitle)
                .foregroundStyle(.link)
                .font(.system(size: 30, weight: .bold, design: .rounded))
        })
    }
}

#Preview {
    StartButtonView(getAction: {print("hi")})
}
