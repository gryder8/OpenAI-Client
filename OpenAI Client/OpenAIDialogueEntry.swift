//
//  OpenAIDialogueEntry.swift
//  OpenAI Client
//
//  Created by Gavin Ryder on 1/16/23.
//

import Foundation


internal enum DialogueEntry {
    case query(String)
    case response(String)
}

internal func stringForDialogue(_ entry: DialogueEntry) -> String {
    switch entry {
    case .query(let text): return text
    case .response(let text): return text
    }
}

