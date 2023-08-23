//
//  ArticleWidget.swift
//  ArticleWidget
//
//  Created by 土橋正晴 on 2023/08/15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), articles: Article.placeholder)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), articles: Article.mockArray)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [SimpleEntry] = []
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, articles: try! await APIManager.get(request: "items" + Article.per_page(3)))
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let articles: [Article]
}

struct ArticleWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) private var family: WidgetFamily
    
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            VStack {
                ForEach(entry.articles) { article in
                    Link(destination: URL(string: "readQiitaApp://deeplink?\(article.id)")!, label: {
                        ArticleWidgetRow(article: article)
                    })
                }
            }
        default:
            EmptyView()
        }
    }
}

struct ArticleWidget: Widget {
    let kind: String = "ArticleWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ArticleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Article List")
        .description("You can see the latest 3 articles")
        .supportedFamilies([.systemMedium])
    }

}

struct ArticleWidget_Previews: PreviewProvider {
    static var previews: some View {
        ArticleWidgetEntryView(entry: SimpleEntry(date: Date(), articles: Article.mockArray))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


