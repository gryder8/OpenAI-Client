//
//  APICaller.swift
//  OpenAI Client
//
//  Created by Gavin Ryder on 1/16/23.
//

import Foundation
import OpenAISwift

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    private var client: OpenAISwift?
    
    private let maxTokens = 100 //arbitary
    
    @frozen enum Constants {
        static let key: String = "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"
    }
    
    public func setup() {
        self.client = OpenAISwift(authToken: Constants.key)
    }
    
    public func getResponse(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, maxTokens: maxTokens, completionHandler: { result in
            switch result {
            case .success(let model):
                print("Got \(model.choices.count) choices")
                let output = model.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "ERROR"
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}
