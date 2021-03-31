//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Adarsh Urs on 18/03/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var previousCorrectAnswer = -1
    @State private var showingScore = false
    @State private var score = 0
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var animationAmount = 0.0
    
        var body: some View {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing:  30){
                    VStack{
                        Text("Tap the flag of").foregroundColor(.white)
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
            
                    ForEach(0 ..< 3){ number in
                        Button(action:{
                            self.flagTapped(number)
                            withAnimation{
                                self.animationAmount += 360
                            }
                            }){
                                Image(self.countries[number])
                                    .renderingMode(.original)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                                    .shadow(color:.black,radius: 2)
                            }
                        .rotation3DEffect(
                            .degrees((self.score > 0 && number == self.previousCorrectAnswer) ? self.animationAmount : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .opacity((!self.showingScore) ? 1 : (self.score > 0 && number == self.previousCorrectAnswer) ? 1 : 0.5)
                        }
                    
                    Text("Your Score: \(score)").foregroundColor(.white)
                    
                    Spacer()
                    
                    }
                
                .alert(isPresented: $showingScore) {
                    Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Countries")){
                        self.askQuestion()
                    })
                }
                }
        }
    
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer{
            score += 1
            previousCorrectAnswer = correctAnswer
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
            showingScore = true
            
        } else{
            scoreTitle = "Wrong"
            scoreMessage = "That's the flag of \(countries[number]). \n Your score is \(score)"
            score = 0
            showingScore = true
            previousCorrectAnswer = -1
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        previousCorrectAnswer = -1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
