//  TabView.swift
//  REC_Schedule

import SwiftUI
//1日、11日、21日にアラート画面を表示
//最初の画面表示
//前回のログイン情報を残す
class DateBeforeList: ObservableObject {
    //日時
    @Published var datebefore : Int {
           didSet {
        UserDefaults.standard.set(datebefore, forKey: "DateCounter")
           }
    }
    // 初期化処理
    init() {
        datebefore = UserDefaults.standard.object(forKey: "DateCounter") as? Int ?? 0
    }
}
struct ContentView: View {
    @ObservedObject var DateBefore : DateBeforeList
    @State private var selection = 1
    @State var showingAlert = true
    @State var Today = Date()
    @State var dateFormatter = DateFormatter() //型変換
    @State var TodayString = "" //今日の日付のみ
    @State var TodayInt = 0 //今日の日付のみ
    
    var body: some View {
        Text( "" )
            .onAppear() {
                //アラート文を出すために、今日の日時から日付を抽出
                dateFormatter.dateFormat = "dd"
                TodayString = dateFormatter.string(from: Today)
                TodayInt = Int(TodayString)!
            }
            //Viewを非表示にするタイミングで値を引き渡す
            .onDisappear{
                //次回アラート文を出すか判断するために、今回の日付(整数型)を記録
                self.DateBefore.datebefore = TodayInt
            }
        
        TabView(selection: $selection){
            //1,11,21日に出す目標再設定に関するアラート文を表示
            //11~20日に初めてログインしたとき、目標再設定に関するアラート文を表示
            if ( TodayInt >= 11 && TodayInt <= 20 && self.DateBefore.datebefore <= 10 ) {
                ScheduleView(contents: ScheduleList(),limitcontents: ScheduleList(),times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList())
                //ScheduleView(contents: ScheduleList(), times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList()
                //             ,limitcontents: ScheduleList())
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("予定表")
                        }
                    }
                    .alert(isPresented: self.$showingAlert) {
                        Alert(title: Text("確認"), message: Text("10日間目標を見直して、"+"\n"+"反省点にメモしておこう"),
                        dismissButton: .default(Text("OK")))
                    }
            //21~31日に初めてログインしたとき、目標再設定に関するアラート文を表示
            } else if ( TodayInt >= 21 && TodayInt <= 31 && self.DateBefore.datebefore <= 20  ) {
                ScheduleView(contents: ScheduleList(),limitcontents: ScheduleList(),times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList())
                //ScheduleView(contents: ScheduleList(), times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList()
                             //,limitcontents: ScheduleList())
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("予定表")
                        }
                    }
                    .alert(isPresented: self.$showingAlert) {
                        Alert(title: Text("確認"), message: Text("10日間目標を見直して、"+"\n"+"反省点にメモしておこう"),
                        dismissButton: .default(Text("OK")))
                    }
            //1~10日に初めてログインしたとき、目標再設定に関するアラート文を表示, yeardaysstring:
            } else if ( TodayInt >= 1 && TodayInt <= 10 && self.DateBefore.datebefore >= 21 && self.DateBefore.datebefore <= 31 ) { //1日に出す目標再設定に関するアラート文を表示
                ScheduleView(contents: ScheduleList(),limitcontents: ScheduleList(),times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList())
                //ScheduleView(contents: ScheduleList(), times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList(),limitcontents: ScheduleList())
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("予定表")
                        }
                    }
                    .alert(isPresented: self.$showingAlert) {
                        Alert(title: Text("確認"), message: Text("今月の目標と10日間目標を見直して、"+"\n"+"反省点にメモしておこう"),
                        dismissButton: .default(Text("OK")))
                    }
            } else {
                ScheduleView(contents: ScheduleList(),limitcontents: ScheduleList(),times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList())
                //ScheduleView(contents: ScheduleList(), times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList(),limitcontents: ScheduleList())
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("予定表")
                        }
                    }
            }
            
            //企業リスト
            CompanyView(Company:CompanyList(),ValueCompany: DetailContentsList())
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("企業リスト")
                    }
                }
            //マップ検索
            MapView()
               .tabItem {
                   VStack {
                       Image(systemName: "map.fill")
                       Text("マップ検索")
                   }
               }
            //ニュースリスト
            NewsView(News:NewsList(),Value_News: DetailNewsList())
               .tabItem {
                   VStack {
                       Image(systemName: "newspaper.fill")
                       Text("ニュースリスト")
                   }
               }
            //サポート
            SupportView(MonthGoals:GoalList(),TenGoals:GoalList(),Reflections:GoalList(), TodoPoints:GoalList(),Counter:CounterList(),Before:CounterList())
               .tabItem {
                   VStack {
                       Image(systemName: "heart.fill")
                       Text("サポート")
                   }
               }
        }
    }
}
