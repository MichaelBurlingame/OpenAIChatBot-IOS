//
//  ChatView.swift
//  OpenAIChatBot-IOS
//
//  Created by Michael Burlingame on 2/23/23.
//

import SwiftUI
import OpenAISwift

struct ChatView: View {
    
    @ObservedObject var vm = ViewModel()
    @State var userInput = ""
    @State var responses = [String]()
    
    var body: some View {
        
        VStack {
            
            LogoView()
            
            ScrollView {
                
                ForEach(responses, id: \.self) { message in
                    
                    // Checks Who The Message Belongs Too
                    // By Checking For The [USER] Tag
                    // If User, Show On Right With Blue Bubble
                    
                    if message.contains("[USER]") {
                        
                        let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                        
                        HStack {
                            
                            Spacer()
                            
                            Text(newMessage)
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue.opacity(0.75))
                                .cornerRadius(15)
                                .padding(.horizontal, 15)
                                .padding(.bottom, 10)
                            
                        }
                        
                    } else {
                        
                        // Else, Show On Left With Gray Bubble
                        
                        HStack {
                            
                            Text(message)
                                .padding()
                                .background(.gray.opacity(0.25))
                                .cornerRadius(15)
                                .padding(.horizontal, 15)
                                .padding(.bottom, 10)
                            
                            Spacer()

                        }
                    }
                    
                }
                .rotationEffect(.degrees(180))
            }
            .rotationEffect(.degrees(180))

            // Bottom TextField Section
            
            HStack {
                
                TextField("Type Here...", text: $userInput)
                    .padding(15)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(30)
                    .onSubmit { send() }
                
                Button {
                    send()
                } label: {
                    
                   Image(systemName: "paperplane.fill")
                        .font(.system(size: 30))
                        .padding(.horizontal)
                    
                }
            }
            .padding()
        }
        .onAppear { vm.setUp() }
    }
    
    func send() {
        
        // Do Not Send If Empty
        
        guard !userInput.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        // Add [User] Tag Too User's Text For Identification
        
        responses.append("[USER]\(userInput)")
        
        // Add The AI's Response To The Model Array
        // And Reset text Var To Clear TextField
        
        vm.sendMessage(message: userInput) { response in
            DispatchQueue.main.async {
                self.responses.append(response)
                self.userInput = ""
            }
        }
    }
}

struct LogoView: View {
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            Text("GPT")
                .font(.system(size: 50,weight: .bold, design: .rounded))
                .bold()
            
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
