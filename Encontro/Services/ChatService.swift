//
//  ChatService.swift
//  CartaChat
//
//  Created by k on 2024-02-25.
//

import Foundation
import Firebase
import CoreData

class ChatService {
    
    let chatPartner: User
    let context: NSManagedObjectContext
    
    init(user: User, context: NSManagedObjectContext){
        self.chatPartner = user
        self.context = context
    }
    
    let messagesCollection = Firestore.firestore().collection("messages")
    
    func sendMesssage(_ text: String){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let chatPartnerId = chatPartner.id
        let currentUserMessageDoc = messagesCollection.document(currentUid).collection(chatPartnerId).document()
        let partnerChatRef =  messagesCollection.document(chatPartnerId).collection(currentUid)
        
        let recentCurrentUserRef = 
        AppConstants.MessagesCollection
            .document(currentUid)
            .collection("recent-messages")
            .document(chatPartnerId)
        
        let recentPartnerRef =
        AppConstants.MessagesCollection
            .document(chatPartnerId)
            .collection("recent-messages")
            .document(currentUid)
        
        let messageId = currentUserMessageDoc.documentID
        let message = Message(
            id: messageId,
            fromId: currentUid,
            toId: chatPartnerId,
            messageText: text,
            timestamp: Timestamp()
        )
        
        guard let messageData = try? Firestore.Encoder().encode(message) else {return}
        
        //Copy message to current user's and partner's collection
        currentUserMessageDoc.setData(messageData)
        partnerChatRef.document(messageId).setData(messageData)
        
        recentCurrentUserRef.setData(messageData)
        recentPartnerRef.setData(messageData)
    }
    
    func observeMesssages(completion: @escaping([Message]) -> Void){
        let oldMessages = loadOldMessages()
        let oldestMessage = oldMessages.last
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let oldDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))
        
        // isGreaterThan sometimes acts as greater than or equals
        let query = messagesCollection
            .document(currentUid)
            .collection(self.chatPartner.id)
            .whereField("timestamp", isGreaterThan: oldestMessage?.timestamp ?? Timestamp(date: oldDate! ))
            .order(by: "timestamp", descending: false)
 
        
        query.addSnapshotListener {snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added}) else { return }
            var messages = changes.compactMap({ try? $0.document.data(as: Message.self)})
            print("New messages from data \(messages.count)")
            //Save to coredata
            for message in messages {
                // isGreaterThan in query sometimes returns the last archived message.
                // Make sure not duplicate it in the archive
                if let existingIndex = oldMessages.firstIndex(where: { $0.id == message.id }) {
                    print("message already exist")
                }else{
                    print("A message was saved \(message.messageText)")
                    self.saveMessage(message: message, context: self.context)
                }
            }
            
            // Add partner information to messages from partner for displaying image bubbles etc... for their messages
            for(index, message) in messages.enumerated() where message.fromId != currentUid {
                messages[index].user = self.chatPartner
            }
            
            completion(oldMessages + messages)
        }
    }
    
    func save(context: NSManagedObjectContext){
        do{
            try context.save()
            print("Data Saved")
        }catch{
            print("Could not save the data: \(error)")
        }
    }
    
    func saveMessage(message: Message, context: NSManagedObjectContext){
        let archive = ArchiveMessage(context: context)
        archive.id = message.id
        archive.chatPartnerId = message.chatPartnerId
        archive.date = message.timestamp.dateValue()
        archive.fromId = message.fromId
        archive.isFromCurrentUser = message.isFromCurrentUser
        archive.messageText = message.messageText
        archive.toId = message.toId
        save(context: context)
    }
    
    
    func fetchData () -> [ArchiveMessage] {
        let fetchRequest: NSFetchRequest<ArchiveMessage> = ArchiveMessage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chatPartnerId == %@", chatPartner.id)

        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }
    
    func loadOldMessages() -> [Message]{
        let archives = self.fetchData()
        let sortedArchives = archives.sorted { $0.date! < $1.date! }
 
        let oldMessages = sortedArchives.map { archiveMessage in
            Message(id: archiveMessage.id!,
                    fromId: archiveMessage.fromId!,
                    toId: archiveMessage.toId!,
                    messageText: archiveMessage.messageText!,
                    timestamp: Timestamp(date: archiveMessage.date!))
        }
        for archive in oldMessages {
        
        }
        return oldMessages
    }
}
