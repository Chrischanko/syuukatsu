//
//  CompanyDetailView.swift
//  REC_Schedule
//
import SwiftUI

struct CompanyDetailView: View {
    @ObservedObject var ValueCompany : DetailContentsList
    //@ObservedObject var Company : CompanyList
    @State var name = ""
    @State var number : Int
    @State private var rewriteContents = false
     
    var body: some View {
        HStack() {
            Text("")
                .navigationBarTitle(name)
                .navigationBarItems(trailing:
                                        Button( action:{
                                            self.rewriteContents.toggle()
                                        })
                                        { if ( rewriteContents == false ) {
                                            Text("編集")
                                                .buttonStyle(BorderlessButtonStyle())
                                        } else if ( rewriteContents == true ) {
                                            Text("完了")
                                                .buttonStyle(BorderlessButtonStyle())
                                        }
                                        }
                )
            HStack(alignment: .center) {
                VStack() {
                    if ( rewriteContents ==  true ) {
                        Section {
                            Text("メモ")
                                .font(.system(size: 20))
                        }
                        TextEditor( text: self.$ValueCompany.ValueCompanies[number] )
                            .border(Color.black, width: 1)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                    } else {
                        Text( self.ValueCompany.ValueCompanies[number] )
                    }
                }
                }
        }
    }
}
