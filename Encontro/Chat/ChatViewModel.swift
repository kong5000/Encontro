//
//  ChatViewModel.swift
//  CartaChat
//
//  Created by k on 2024-02-25.
//

import Foundation
import CoreData
import Firebase

class ChatViewModel: ObservableObject {
    
    @Published var messageText = ""
    @Published var messages = [Message]()
    
    let service: ChatService
    let viewContext: NSManagedObjectContext
    let container = NSPersistentContainer(name: "DataModel")
    
    init(user: User){
        container.loadPersistentStores{desc, error in
            if let error {
                print(error.localizedDescription)
            }
        }
        viewContext = container.viewContext
        
        self.service = ChatService(user: user, context: viewContext)
        observeMessages()
    }
    
    
    func sendMessage(){
        service.sendMesssage(messageText)
        messageText = ""
    }
    
    func observeMessages(){
        service.observeMesssages{ messages in
            for i in 0..<messages.count {
                let message = messages[i]
            
                if let existingIndex = self.messages.firstIndex(where: { $0.id == message.id }) {
                    self.messages[existingIndex] = messages[i]
                } else {
                    self.messages.append(messages[i])
                }
            }
        }
//        self.messages.append(contentsOf: messages   )
    }
    
    func addDummyMessages(){
        for i in 0...5{
            self.messages.append(Message(id: UUID().uuidString, fromId: UUID().uuidString, toId: UUID().uuidString, messageText: "\(i) test", timestamp: Timestamp()))

        }
    }
}

