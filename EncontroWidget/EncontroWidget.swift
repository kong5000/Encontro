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
        SimpleEntry(date: Date(), emoji: "😀", text: "Sample")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", text:"Samp;e")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Assuming getWidgetMessage now fetches and decodes into WidgetMessage correctly
        if let sharedUserDefaults = UserDefaults(suiteName: "group.com.keith.Encontro") {
            if let userId = sharedUserDefaults.string(forKey: "uid") {
                
            }
        }
        fetchWidgetMessage { result in
            print(result)
            let date = Date()
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
            var entries: [SimpleEntry] = []

            switch result {
            case .success(let widgetMessage):
                let entry = SimpleEntry(date: date, emoji: widgetMessage.emoji, text: widgetMessage.text)
                entries.append(entry)
            case .failure(_):
                let entry = SimpleEntry(date: date, emoji: "😞", text: "Failed to load")
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    
}

func getUserId() -> String? {
    let sharedUserDefaults = UserDefaults(suiteName: "group.com.keith.Encontro")
    return sharedUserDefaults?.string(forKey: "uid")
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let text: String
}

struct WidgetMessage: Codable {
    let text: String
    let emoji: String
}

func fetchWidgetMessage(completion: @escaping (Result<WidgetMessage, Error>) -> Void) {
    guard let userId = getUserId() else {
        completion(.failure(NSError(domain: "UserDefaultsError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
        return
    }

    guard let url = URL(string: "https://us-central1-cartachat-ce6e9.cloudfunctions.net/getWidgetMessage?userId=\(userId)") else {
        completion(.failure(NSError(domain: "URLCreationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(error ?? NSError(domain: "NetworkRequestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data"])))
            return
        }

        do {
            let decoder = JSONDecoder()
            let widgetMessage = try decoder.decode(WidgetMessage.self, from: data)
            completion(.success(widgetMessage))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

struct EncontroWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.text)

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

//#Preview(as: .systemSmall) {
//    EncontroWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
