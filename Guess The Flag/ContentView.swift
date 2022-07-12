//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Meitar Basson on 29/06/2022.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}


extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var question_asked = 0
    
    // Properties for animating the chosen flag
     @State private var animateCorrect = 0.0
     @State private var animateOpacity = 1.0
     @State private var besidesTheCorrect = false
     @State private var besidesTheWrong = false
     @State private var selectedFlag = 0
    
    struct FlagImage: View {
        var image: String
        
        var body: some View {
            Image(image)
                .renderingMode(.original)
                .shadow(radius: 5.0)
        }
    }

    
    var body: some View {
        ZStack {
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            self.selectedFlag = number
                            self.flagTapped(number)
                        } label: {
                            FlagImage(image: countries[number])
                        }
                        // Animate the flag when the user tap the correct one:
                        // Rotate the correct flag
                        .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animateCorrect : 0), axis: (x: 0, y: 1, z: 0))
                        // Reduce opacity of the other flags to 25%
                        .opacity(number != self.correctAnswer && self.besidesTheCorrect ? self.animateOpacity : 1)
                        
                        // Animate the flag when the user tap the wrong one:
                        // Create a red background to the wrong flag
                        .background(self.besidesTheWrong && self.selectedFlag == number ? Capsule(style: .circular).fill(Color.red).blur(radius: 30) : Capsule(style: .circular).fill(Color.clear).blur(radius: 0))
                        // Reduce opacity of the other flags to 25% (including the correct one)
                        .opacity(self.besidesTheWrong && self.selectedFlag != number ? self.animateOpacity : 1)
                        
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score) / \(question_asked)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }.padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            if question_asked < 8 {
                Button("Continue", action: askQuestion)
            } else {
                Button("Cancel", role: .cancel, action: {})
                Button("Reset", action: reset)
            }
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            
            self.score += 1
            
            // Create animation for the correct answer
            withAnimation {
                self.animateCorrect += 360
                self.animateOpacity = 0.25
                self.besidesTheCorrect = true
            }
        } else {
            scoreTitle = "Wrong!"
            
            // Create animation for the wrong answer
            withAnimation {
                self.animateOpacity = 0.25
                self.besidesTheWrong = true
            }
        }
        showingScore = true
    }
    
    func askQuestion() {
        // Return the booleans to false
         besidesTheCorrect = false
         besidesTheWrong = false
         countries = countries.shuffled()
         correctAnswer = Int.random(in: 0...3)
    }
    
    func reset() {
        question_asked = 0
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
