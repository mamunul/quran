//
//  BookMarkView.swift
//  QuranAndSunnah
//
//  Created by newone on 12/6/22.
//

import SwiftUI

struct HighlightsView: View {
    var body: some View {
        Text("")
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
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        NoteBookView()
    }
}
