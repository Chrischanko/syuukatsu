//
//  NewsDetail.swift
//  REC_Schedule
//
//  Created by KURISUAkira on 2021/10/01.
//

import SwiftUI

struct NewsDetailView: View {
    @ObservedObject var Value_News : DetailNewsList
    @State var namenews = ""
    @State var number : Int
    @State private var rewriteNews = false
         
    var body: some View {
            HStack() {
                Text("")
                    .navigationBarTitle(namenews)
                    .navigationBarItems(trailing:
                                            Button( action:{
                                                self.rewriteNews.toggle()
                                            })
                                            { if ( rewriteNews == false ) {
                                                Text("編集")
                                                    .buttonStyle(BorderlessButtonStyle())
                                            } else if ( rewriteNews == true ) {
                                                Text("完了")
                                                    .buttonStyle(BorderlessButtonStyle())
                                            }
                                            }
                    )
                HStack(alignment: .center) {
                    VStack() {
                        if ( rewriteNews ==  true ) {
                            Section {
                                Text("メモ")
                                    .font(.system(size: 20))
                            }
                            TextEditor( text: self.$Value_News.ValueNews[number] )
                                .border(Color.black, width: 1)
                                .environment(\.locale, Locale(identifier: "ja_JP"))
                        } else {
                            Text( self.Value_News.ValueNews[number] )
                        }
                    }
                }
            }
        }
    }

/*struct NewsDetail_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView()
    }
}*/
