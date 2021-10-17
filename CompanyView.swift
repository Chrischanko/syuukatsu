//
//  ListView.swift
//  REC_Schedule

import SwiftUI
//企業リストの携帯への保存
class CompanyList: ObservableObject {
    //企業リスト
    @Published var Companyname : [String] {
           didSet {
        UserDefaults.standard.set(Companyname, forKey: "Company")
           }
    }
    // 初期化処理
    init() {
         Companyname = UserDefaults.standard.stringArray(forKey: "Company") ?? [String]()
    }
}
//企業内容の携帯への保存
class DetailContentsList: ObservableObject {
    
    @Published var ValueCompanies : [String] {
        didSet {
            UserDefaults.standard.set(ValueCompanies, forKey: "ValueCompany")
        }
    }
    // 初期化処理
    init()
    {
        ValueCompanies = UserDefaults.standard.stringArray(forKey: "ValueCompany") ?? [String]()
    }
}

//企業名を書き換え可能とする
//リストの例を載せる
//スクロール

struct CompanyView: View {
    @Environment(\.editMode) var envEditMode
    @ObservedObject var Company : CompanyList
    @ObservedObject var ValueCompany : DetailContentsList
    @State var new = ""
    @State private var newstate = ""
    @State private var isPushed = false
    var body : some View {
        NavigationView{
            VStack() {
                ZStack(alignment: .trailing) {
                HStack {
                    if ( isPushed == true )
                    { TextField("企業名", text: $new)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            self.Company.Companyname.append(self.new)
                            self.new = ""
                            self.newstate = "企業理念・面接内容などをメモしよう"
                            self.ValueCompany.ValueCompanies.append(self.newstate)
                            UserDefaults.standard.set(self.Company.Companyname, forKey: "Company")
                            UserDefaults.standard.set(self.ValueCompany.ValueCompanies,forKey: "ValueCompany")
                        }) {
                            Text("追加")
                                 .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }.padding([.leading, .trailing])
            //リストが空の時
            if ( Company.Companyname.isEmpty ) {
                Text("企業リストを作成しよう")
                    .font(.system(size: 30))
            } else {
            //リストがある時
            List {
               
                ForEach ( 0..<Company.Companyname.count,id: \.self )
                { item in
                    NavigationLink(destination:CompanyDetailView( ValueCompany: DetailContentsList(), name:self.Company.Companyname[item], number:item).onDisappear(perform: {
                        UserDefaults.standard.set(self.ValueCompany.ValueCompanies, forKey: "ValueCompany");
                    }))
                    {
                        Text(self.Company.Companyname[item])
                            .font(.system(size: 25))
                            .onAppear(){
                                self.ValueCompany.ValueCompanies = UserDefaults.standard.stringArray(forKey: "ValueCompany") ?? [String]()
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
                             trailing: Button( action:{ self.isPushed.toggle()
                             })
                             { if ( isPushed == false ) {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 30))
                             } else if (isPushed == true) {
                                Image(systemName: "minus.circle")
                                    .font(.system(size: 30))
                             }
                             }
                            )
        .navigationBarTitle("企業リスト")
    }
    }
    
    // 行削除処理
    func rowRemove(offsets: IndexSet) {
        self.Company.Companyname.remove(atOffsets: offsets)
        UserDefaults.standard.set(self.Company.Companyname, forKey:"Company")
        self.ValueCompany.ValueCompanies.remove(atOffsets: offsets)
        UserDefaults.standard.set(self.ValueCompany.ValueCompanies, forKey:"ValueCompany")
    }
    // 行入れ替え処理
    func rowReplace(_ from: IndexSet, _ to: Int) {
        self.Company.Companyname.move(fromOffsets: from, toOffset: to)
        UserDefaults.standard.set(self.Company.Companyname, forKey:"Company")
        self.ValueCompany.ValueCompanies.move(fromOffsets: from, toOffset: to)
        UserDefaults.standard.set(self.ValueCompany.ValueCompanies, forKey:"ValueCompany")
    }
}
struct CompanyView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyView(Company:CompanyList(),ValueCompany: DetailContentsList())
    }
}
