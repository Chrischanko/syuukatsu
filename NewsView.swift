//
//  NewsView.swift
//  REC_Schedule

import SwiftUI

class NewsList: ObservableObject {
    //ニュース見出しリスト
    @Published var Newsname : [String] {
           didSet {
        UserDefaults.standard.set(Newsname, forKey: "News")
           }
    }
    // 初期化処理
    init() {
         Newsname = UserDefaults.standard.stringArray(forKey: "News") ?? [String]()
    }
}

class DetailNewsList: ObservableObject {
    //ニュース詳細
    @Published var ValueNews : [String] {
        didSet {
            UserDefaults.standard.set(ValueNews, forKey: "ValueNews")
        }
    }
    // 初期化処理
    init()
    {
        ValueNews = UserDefaults.standard.stringArray(forKey: "ValueNews") ?? [String]()
    }
}

struct NewsView: View {
    @Environment(\.editMode) var envEditMode
    @ObservedObject var News : NewsList
    @ObservedObject var Value_News : DetailNewsList
    @State var newnews = ""
    @State private var newsstate = ""
    @State private var isPushedNews = false
    var body : some View {
        NavigationView{
        VStack() {
            ZStack(alignment: .trailing) {
                HStack {
                    if ( isPushedNews == true )
                    { TextField("ニュース見出し", text: $newnews)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            self.News.Newsname.append(self.newnews)
                            self.newnews = ""
                            self.newsstate = "ニュース詳細や自分が感じたことをメモしよう"
                            self.Value_News.ValueNews.append(self.newsstate)
                            UserDefaults.standard.set(self.News.Newsname, forKey: "News")
                            UserDefaults.standard.set(self.Value_News.ValueNews,forKey: "ValueNews")
                        }) {
                            Text("追加")
                                 .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
            //リストが空の時
            if ( News.Newsname.isEmpty ) {
                Text("気になるニュースを"+"\n"+"リスト化しよう")
                    .font(.system(size: 30))
            } else {
            //リストがある時
            List {
                ForEach ( 0..<News.Newsname.count,id: \.self )
                { item in
                    NavigationLink(destination:NewsDetailView( Value_News: DetailNewsList(), namenews:self.News.Newsname[item], number:item).onDisappear(perform: {
                        UserDefaults.standard.set(self.Value_News.ValueNews, forKey: "ValueNews");
                    }))
                    {
                        Text(self.News.Newsname[item])
                            .font(.system(size: 25))
                            .onAppear(){
                                self.Value_News.ValueNews = UserDefaults.standard.stringArray(forKey: "ValueNews") ?? [String]()
                            }
                    }
                }
                //行削除操作時に呼び出す処理の指定
                .onDelete(perform: rowRemove)
                
                // 行入れ替え操作時に呼び出す処理の指定
                .onMove(perform: rowReplace)
            }
            }
        }
        .navigationBarItems( leading:
                                EditButton()
                                .font(.system(size: 30))
                                .environment(\.locale, Locale(identifier: "ja_JP")),
                             trailing: Button( action:{ self.isPushedNews.toggle()
                             })
                             { if ( isPushedNews == false ) {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 30))
                             } else if (isPushedNews == true) {
                                Image(systemName: "minus.circle")
                                    .font(.system(size: 30))
                             }
                             }
                            )
        .navigationBarTitle("ニュースリスト")}
    }
    // 行削除処理
    func rowRemove(offsets: IndexSet) {
        self.News.Newsname.remove(atOffsets: offsets)
        UserDefaults.standard.set(self.News.Newsname, forKey:"News")
        self.Value_News.ValueNews.remove(atOffsets: offsets)
        UserDefaults.standard.set(self.Value_News.ValueNews, forKey:"ValueNews")
    }
    // 行入れ替え処理
    func rowReplace(_ from: IndexSet, _ to: Int) {
        self.News.Newsname.move(fromOffsets: from, toOffset: to)
        UserDefaults.standard.set(self.News.Newsname, forKey:"News")
        self.Value_News.ValueNews.move(fromOffsets: from, toOffset: to)
        UserDefaults.standard.set(self.Value_News.ValueNews, forKey:"ValueNews")
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(News:NewsList(),Value_News: DetailNewsList())
    }
}
