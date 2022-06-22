//
//  BookMarkView.swift
//  QuranAndSunnah
//
//  Created by newone on 12/6/22.
//

import SwiftUI

struct HighlightsView: View {
    @EnvironmentObject var presenter: NotebooksPresenter
    var body: some View {
        List {
            ForEach(presenter.highlights) { highlight in
                VStack {
                    Text("\(highlight.markedText)")
                    Text("\(highlight.chapterTitle)")
                    HStack {
                        Text("\(highlight.contentNo)")
                        Text("\(highlight.bookName)")
                    }
                }
            }
        }.onAppear {
            presenter.getHighlights()
        }
    }
}

struct FrequentlyUsedView: View {
    var body: some View {
        TabView {
            HStack {
                Text("FrequentlyUsedView 1")
            }

            HStack {
                Text("FrequentlyUsedView 2")
            }

            HStack {
                Text("FrequentlyUsedView 3")
            }
        }
        .frame(height: 200)
        .tabViewStyle(.page)
    }
}

struct SuggestedView: View {
    var body: some View {
        TabView {
            HStack {
                Text("SuggestedView 1")
            }

            HStack {
                Text("SuggestedView 2")
            }

            HStack {
                Text("SuggestedView 3")
            }
        }
        .frame(height: 200)
        .tabViewStyle(.page)
    }
}

struct NoteBookView: View {
    @StateObject var presenter = NotebooksPresenter()
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    HighlightsView()
                } label: {
                    Text("Highlights")
                        .padding()
                }
                NavigationLink {
                    HighlightsView()
                } label: {
                    Text("Tags")
                        .padding()
                }
                NavigationLink {
                    HighlightsView()
                } label: {
                    Text("Notes")
                        .padding()
                }
                NavigationLink {
                    HighlightsView()
                } label: {
                    Text("Bookmarks")
                        .padding()
                }
                FrequentlyUsedView()
                SuggestedView()
                Spacer()
            }
            .listStyle(PlainListStyle())
        }
        .environmentObject(presenter)
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        NoteBookView()
    }
}
