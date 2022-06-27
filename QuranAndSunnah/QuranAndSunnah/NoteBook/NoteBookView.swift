//
//  BookMarkView.swift
//  QuranAndSunnah
//
//  Created by newone on 12/6/22.
//

import SwiftUI

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
                    BookmarksView()
                } label: {
                    Text("Bookmarks")
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
                SuggestedView()
                Spacer()
            }
            .listStyle(PlainListStyle())
            .navigationTitle("My Readings")
        }.onAppear {
            presenter.loadSurah()
            presenter.getBookmarks()
            presenter.getHighlights()
        }
        .environmentObject(presenter)
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        NoteBookView()
    }
}
