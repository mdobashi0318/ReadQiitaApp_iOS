//
//  ContentView.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/04/17.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ArticleViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView()
            } else {
                articleList()
            }
        }
    }
    
    
    private func articleList() -> some View {
        List {
            ForEach(0..<viewModel.articles.count, id: \.self) { row in
                NavigationLink(destination:
                                ArticleView(article: viewModel.articles[row])
                ) {
                    ArticleRow(article: viewModel.articles[row])
                }
            }
        }
        .listStyle(.plain)
        .padding()
        .navigationTitle(Text("ReadQiitaApp"))
        .refreshable {
            Task {
                await viewModel.getItems()
            }   
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



