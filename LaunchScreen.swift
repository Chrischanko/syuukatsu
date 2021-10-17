//
//  LaunchScreen.swift
//  REC_Schedule
//
//  Created by KURISUAkira on 2021/10/07.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            ZStack {
                Image("TopIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        } else {
            ContentView(DateBefore : DateBeforeList())
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
