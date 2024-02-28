//
//  EncontroWidget.swift
//  EncontroWidget
//
//  Created by k on 2024-02-28.
//

import WidgetKit
import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", messageData: WidgetMessage(text: "test", timestamp: Timestamp()))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", messageData: WidgetMessage(text: "test", timestamp: Timestamp()))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let date = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15 ,to: date)!
        
        fetchWidgetMessage { widgetMessage in
            let entry = SimpleEntry(date: Date(), emoji: "emoji", messageData: widgetMessage)
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            
            completion(timeline)
        }
    }
    
    func fetchWidgetMessage(completion: @escaping(WidgetMessage) -> Void ){
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("widgetMesssages").document(userId).getDocument { snapshot, error in
            
            guard let message = try? snapshot?.data(as: WidgetMessage.self) else {
                completion(WidgetMessage(text: "", timestamp: Timestamp() ))
                return
            }
            
            completion(message)
            return
        }
    }
}


struct WidgetMessage: Decodable {
    var text: String
    var timestamp: Timestamp
    var date: Date {
        Timestamp.dateValue(timestamp)()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    var messageData: WidgetMessage
}

struct EncontroWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
            
            Text("Emoji:")
            Text(entry.emoji)
            
            Text(entry.messageData.text)
        }
    }
}

struct EncontroWidget: Widget {
    
    init(){
        FirebaseApp.configure()
        do{
//            try Auth.auth().useUserAccessGroup("\(teamId)keith.Encontro.EncontroWidget")

        }
    }
    let kind: String = "EncontroWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EncontroWidgetEntryView(entry: entry)
                .padding()
                .background()
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    EncontroWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀", messageData: WidgetMessage(text: "test", timestamp: Timestamp()))
    SimpleEntry(date: .now, emoji: "😀", messageData: WidgetMessage(text: "test", timestamp: Timestamp()))
}
