//
//  ContentView.swift
//  SurveyExample
//
//  Created by Inpyo Hong on 2023/06/21.
//

import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    let questionText: String
    let choices: [String]
    var selectedChoiceIndex: Int?
    var isAnswered: Bool {
        return selectedChoiceIndex != nil
    }
    var answerResult: String {
        guard let selectedChoiceIndex = selectedChoiceIndex else {
            return ""
        }
        return choices[selectedChoiceIndex]
    }
}

struct ContentView: View {
    @State private var questions: [Question] = [
        Question(questionText: "Question 1", choices: ["Choice 1-1", "Choice 1-2", "Choice 1-3", "Choice 1-4"], selectedChoiceIndex: nil),
        Question(questionText: "Question 2", choices: ["Choice 2-1", "Choice 2-2", "Choice 2-3", "Choice 2-4"], selectedChoiceIndex: nil),
        Question(questionText: "Question 3", choices: ["Choice 3-1", "Choice 3-2", "Choice 3-3", "Choice 3-4"], selectedChoiceIndex: nil)
    ]
    @State private var currentQuestionIndex = 0
    
    @State private var userAnswer: String = ""
    
    var body: some View {
        VStack {
            Text("Chat")
                .font(.largeTitle)
                .padding()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(0..<currentQuestionIndex, id: \.self) { index in
                        MessageBubble(text: questions[index].questionText, isUser: false)
                        if questions[index].isAnswered {
                            AnswerBubble(text: questions[index].answerResult, isUser: true)
                        }
                    }
                    
                    if currentQuestionIndex < questions.count {
                        QuestionBubble(question: questions[currentQuestionIndex]) { answer in
                            submitAnswer(answer)
                        }
                    }
                }
                .padding(.vertical)
            }
            
//            HStack {
//                TextField("Type your answer", text: $userAnswer)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//
//                Button(action: {
//                    submitAnswer(userAnswer)
//                }, label: {
//                    Text("Send")
//                        .padding(.horizontal)
//                        .padding(.vertical, 10)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                })
//            }
//            .padding()
        }
    }
    
    func submitAnswer(_ answer: String) {
        if !answer.isEmpty {
            questions[currentQuestionIndex].selectedChoiceIndex = Int(answer)
            currentQuestionIndex += 1
            userAnswer = ""
        }
    }
}

struct QuestionBubble: View {
    @State var question: Question
    let submitAnswer: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question.questionText)
                .padding(.horizontal)
            
            Picker("Answer", selection: Binding(
                get: { question.selectedChoiceIndex ?? 0 },
                set: { question.selectedChoiceIndex = $0 }
            )) {
                ForEach(question.choices.indices, id: \.self) { choiceIndex in
                    Text(question.choices[choiceIndex])
                        .tag(choiceIndex)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Button(action: {
                if let selectedChoiceIndex = question.selectedChoiceIndex {
                    submitAnswer(String(selectedChoiceIndex))
                }
            }) {
                Text("Submit")
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!question.isAnswered)
            .opacity(question.isAnswered ? 1.0 : 0.5)
            .padding(.top, 10)
            .padding(.horizontal)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
        .overlay(
            ArrowShape()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 20, height: 10)
                .position(x: 20, y: -5)
                .rotationEffect(Angle(degrees: 180))
        )
    }
}

struct MessageBubble: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        HStack {
            if !isUser {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }
            
            Text(text)
                .padding(10)
                .background(isUser ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            
            if isUser {
                Spacer()
            }
        }
        .padding(.horizontal)
        .alignmentGuide(.trailing, computeValue: { _ in
            isUser ? 0 : -30
        })
    }
}

struct AnswerBubble: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(text)
                .padding(10)
                .background(isUser ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            
            if isUser {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .alignmentGuide(.leading, computeValue: { _ in
            isUser ? 0 : -30
        })
    }
}

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
