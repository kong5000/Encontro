//
//  EncontroWidget.swift
//  EncontroWidget
//
//  Created by k on 2024-02-28.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        if let sharedUserDefaults = UserDefaults(suiteName: "group.com.keith.Encontro") {
            if let userId = sharedUserDefaults.string(forKey: "uid") {
               
                print(userId)
                
                getWidgetMessage(userId: userId) { response, error in
                    print(response)
                }
                
            }else{
                print("No user id found")
            }
        }else{
            print("no connect")
        }
        
        let date = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15 ,to: date)!
        
//        fetchWidgetMessage { widgetMessage in
//            let entry = SimpleEntry(date: Date(), emoji: "emoji", messageData: widgetMessage)
//            
//            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
//            
//            completion(timeline)
//        }
    }
    
    
}

func getWidgetMessage(userId: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let url = URL(string: "https://us-central1-cartachat-ce6e9.cloudfunctions.net/getWidgetMessage") else {
            let error = NSError(domain: "https://us-central1-cartachat-ce6e9.cloudfunctions.net", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, error)
            return
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "userId", value: userId)]
        guard let finalURL = components.url else {
            let error = NSError(domain: "URLComponentsError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL components"])
            completion(nil, error)
            return
        }

        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }

            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    completion(jsonResponse, nil)
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }.resume()
    }

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct EncontroWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct EncontroWidget: Widget {
    let kind: String = "EncontroWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                EncontroWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                EncontroWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    EncontroWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
