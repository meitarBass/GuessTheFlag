//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Meitar Basson on 29/06/2022.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
////        ZStack {
////            VStack {
////                Color.red
////                Color.blue
////            }
////
////            Text("Your Content")
////                .foregroundStyle(.secondary)
////                .padding(50)
////                .background(.ultraThinMaterial)
////
////        }.ignoresSafeArea()
//////        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
////        VStack {
////            Button("Button 1") { }
////                .buttonStyle(.bordered)
////            Button("Button 2", role: .destructive) { }
////                .buttonStyle(.bordered)
////            Button("Button 3") { }
////                .buttonStyle(.borderedProminent)
////                    .tint(.mint)
////            Button("Button 4", role: .destructive) { }
////                .buttonStyle(.borderedProminent)
////        }
//        Button {
//            print("Edit button was tapped")
//        } label: {
//            Image(systemName: "pencil")
//        }
//    }
//}

struct ContentView: View {
    @State private var showingAlert = false

    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important message", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please read this.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
