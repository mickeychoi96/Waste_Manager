//
//  ChatGPTService.swift
//  Waste Manager
//
//  Created by 최유현 on 12/4/23.
//

import OpenAI

class OpenAIService {
    let openAI = OpenAI(apiToken: "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")
    
    func getAIService(prompt: String, completion: @escaping(String) -> Void) {
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: prompt)])
        var answer = ""
        
        openAI.chatsStream(query: query) { partialResult in
            switch partialResult {
            case .success(let result):
                for choice in result.choices {
                    answer += choice.delta.content ?? ""
                }
            case .failure(let error):
                print(error)
            }
        } completion: { error in
            if let error = error {
                print("Completion Error: \(error)")
                completion("")
            } else {
                completion(answer)
            }
        }
    }
}



