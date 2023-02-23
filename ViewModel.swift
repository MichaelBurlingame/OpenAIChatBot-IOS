//
//  ViewModel.swift
//  OpenAIChatBot-IOS
//
//  Created by Michael Burlingame on 2/23/23.
//

import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    func setUp() {
        client = OpenAISwift(authToken: "[YOUR_API_KEY_HERE]")
        
    }
    
    func sendMessage(message: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: message,
                               maxTokens: 500,
                               completionHandler: { result in
            
            switch result {
                
            case .success(let model):
                
                let output = model.choices.first?.text ?? ""
                completion(output)
                
            case .failure:
                // ADD ERROR HANDLING
                break
            }
            
        })
    }
}
