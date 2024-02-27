//
//  MessagesViewModel.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import Foundation
import Firebase
import Combine

class InboxViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    
    private var subscriptions = Set<AnyCancellable>()
    private let service: RecentMessagesService
    
    init(){
        service  = RecentMessagesService()
        setupSubscribers()

        service.observeRecentMessages()
    }
    
    private func setupSubscribers(){
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &subscriptions)
        
        service.$documentChanges.sink{ [weak self] changes in
            self?.loadInitialMessages(fromChanges: changes)
        }.store(in: &subscriptions)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]){
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self)})
        var tempMessages = [Message]()

        for i in 0..<messages.count {
            let message = messages[i]
                        
            UserService.fetchUser(withUid: message.chatPartnerId) { user in
                messages[i].user = user
                
                if let existingIndex = self.recentMessages.firstIndex(where: { $0.chatPartnerId == message.chatPartnerId }) {
                    self.recentMessages[existingIndex] = messages[i]
                } else {
                    self.recentMessages.append(messages[i])
                }
                self.recentMessages = self.recentMessages.sorted { chat1, chat2 in
                    chat1.timestamp.dateValue() > chat2.timestamp.dateValue()
                }
            }
        }
    }
}
