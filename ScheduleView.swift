//
//  ScheduleView.swift
//  REC_Schedule

import SwiftUI

class ScheduleList: ObservableObject {
    //日時、予定、場所
    @Published var Schedule : [String] {
           didSet {
        UserDefaults.standard.set(Schedule, forKey: "Schedule")
           }
    }
    //予定、場所
    @Published var  LimitSchedule: [String] {
           didSet {
        UserDefaults.standard.set(LimitSchedule, forKey: "LimitSchedule")
           }
    }
    //日付(文字型配列)
    @Published var YearDayString : [String] {
           didSet {
        UserDefaults.standard.set(YearDayString, forKey: "YearDayString")
           }
    }
    //日付(整数型配列)
    /*@Published var YearDayInt : [Int] {
           didSet {
        UserDefaults.standard.set(YearDayInt, forKey: "YearDayInt")
           }
    }*/
    //日時
    @Published var Time : [Date] {
           didSet {
        UserDefaults.standard.set(Time, forKey: "Time")
           }
    }
    // 初期化処理
    init() {
        Schedule = UserDefaults.standard.stringArray(forKey: "Schedule") ?? [String]()
        LimitSchedule = UserDefaults.standard.stringArray(forKey: "LimitSchedule") ?? [String]()
        //YearDayInt = UserDefaults.standard.object(forKey: "YearDayInt" ) as? [Int] ?? [Int]()
        YearDayString = UserDefaults.standard.stringArray(forKey: "YearDayString") ?? [String]()
        Time = UserDefaults.standard.object(forKey: "Time") as? [Date] ?? [Date]()
    }
}

//あったら良いな　ー＞
//日付に合わせて並び替え
//スケジュールをお知らせする
//過ぎた予定を削除

struct ScheduleView: View {
    @ObservedObject var contents: ScheduleList
    @ObservedObject var limitcontents: ScheduleList
    @ObservedObject var times: ScheduleList
    @ObservedObject var yeardaysint: ScheduleList
    @ObservedObject var yeardaysstring: ScheduleList
    @State var isPushedToday = true
    @State var isPushedTomorrow = false
    //ScheduleInputから引数として抜き出すための変数
    @State var showInputModal = false //追加モーダルの表示・非表示
    @State var newContents = "" //予定
    @State var newLocation = "" //場所
    @State var newstartTime = "" //開始時刻
    @State var newendTime = "" //終了時刻
    @State var newDay = "" //String型日付(yyyyMMdd(E))
    @State var newDayString = "" //String型日付(yyyyMMdd)
    @State var newDayInt = 0 //整数型日付
    @State var newDateschedule = "" //開始日時〜終了日時をまとめた文字列
    @State var newOnlyschedule = "" //開始日時〜終了日時をまとめた文字列
    @State var newday = Date() //日付
    @State var newstart = Date() //開始時間
    @State var newend = Date() //終了時間
    @State var dateFormatter = DateFormatter() //型変換
    //日付で分類するための変数
    @State var today = Date()
    //@State var TodayString = "" //開始日時〜終了日時をまとめた文字列
    @State var TodayScheduleString = ""
    @State var TodayScheduleInt = 0

    var body: some View {
        NavigationView {
            VStack() {
                Text("")
                .onAppear() {
                    dateFormatter.dateFormat = "yyyyMMdd"
                    TodayScheduleString = dateFormatter.string(from: today)
                    //TodayScheduleInt = Int(TodayScheduleString)!
                }
                //スケジュールが0件の場合
                if ( contents.Schedule.isEmpty ) {
                    Text("予定を記入しよう")
                        .font(.system(size: 30))
                //スケジュールが0件以外の場合
                } else {
                    HStack(){
                        //今日の予定ボタンを押すと、関連部分が表示
                        Button(action: {
                            isPushedToday = true
                            isPushedTomorrow = false
                        }) {
                            Text("今日の予定")
                        }
                        .padding()
                        .font(.system(size: 25))
                        .accentColor(Color.black)
                        Divider()
                        //明日以降の予定ボタンを押すと、関連部分が表示
                        Button(action: {
                            isPushedToday = false
                            isPushedTomorrow = true
                        }) {
                            Text("明日以降の予定")
                        }
                        .padding()
                        .font(.system(size: 25))
                        .accentColor(Color.black)
                    }.fixedSize()
                    ScrollView() {
                        if ( isPushedToday == true && isPushedTomorrow == false ) {
                            ZStack() {
                                List {
                                    Text("今日の予定")
                                        .font(.system(size: 25))
                                    ForEach( 0..<contents.Schedule.count, id: \.self ) { num in
                                        if ( TodayScheduleString ==  self.yeardaysstring.YearDayString[num]) {
                                            Text(self.limitcontents.LimitSchedule[num])
                                                .font(.system(size: 25))
                                        }
                                    }
                                    // 行削除操作時に呼び出す処理の指定
                                    .onDelete(perform: rowRemove)
                                    // 行入れ替え操作時に呼び出す処理の指定
                                    .onMove(perform: rowReplace)
                                }.frame(height:1000)
                            }
                         }
                        else if ( isPushedToday == false && isPushedTomorrow == true ) {
                           ZStack() {
                               List {
                                   Text("明日以降の予定")
                                       .font(.system(size: 25))
                                   ForEach( 0..<contents.Schedule.count, id: \.self ) { num in
                                       if ( TodayScheduleString != self.yeardaysstring.YearDayString[num] )
                                       {
                                           Text(self.contents.Schedule[num])
                                               .font(.system(size: 25))
                                }
                            }
                            // 行削除操作時に呼び出す処理の指定
                            .onDelete(perform: rowRemove)
                            // 行入れ替え操作時に呼び出す処理の指定
                            .onMove(perform: rowReplace)
                           }.frame(height:1000)
                        }
                    }
                }
                }
            }
          .sheet(isPresented: $showInputModal, onDismiss:
          {
          if (self.newContents != "") {
            //リストに追加
            self.contents.Schedule.append(self.newDateschedule)
            self.limitcontents.LimitSchedule.append(self.newOnlyschedule)
            self.yeardaysstring.YearDayString.append(self.newDayString)
            //self.yeardaysint.YearDayInt.append(self.newDayInt)
            //self.times.Time.append(self.newstart)
            //データ保存
            UserDefaults.standard.set(self.contents.Schedule, forKey:"Schedule")
            UserDefaults.standard.set(self.limitcontents.LimitSchedule, forKey:"LimitSchedule")
            UserDefaults.standard.set(self.yeardaysstring.YearDayString, forKey:"YearDayString")
            //UserDefaults.standard.set(self.yeardaysint.YearDayInt, forKey:"YearDayInt")
            //UserDefaults.standard.set(self.times.Time, forKey:"Time")
            //空にする
            self.newDateschedule = ""
            self.newOnlyschedule = ""
            self.newDayString = ""
          }
          })
            {   ScheduleInputView(content: self.$newContents, location: self.$newLocation,
                                  Day: self.$newDay, DayString: self.$newDayString, DayInt: self.$newDayInt,startTime : self.$newstartTime, endTime: self.$newendTime, Dateschedule: self.$newDateschedule, Onlyschedule: self.$newOnlyschedule, day : self.$newday, start: self.$newstart, end : self.$newend)
       }
        .navigationBarItems(leading:
                                EditButton()
                                .font(.system(size: 30))
                                .environment(\.locale, Locale(identifier: "ja_JP")),
                            trailing: Button(action: {
                                self.showInputModal.toggle()
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 30))
                            }
        )
        .navigationBarTitle("予定表")
        }
    }
   
    // 行削除処理
   func rowRemove(offsets: IndexSet) {
        self.contents.Schedule.remove(atOffsets: offsets)
        self.limitcontents.LimitSchedule.remove(atOffsets: offsets)
        //self.yeardaysint.YearDayInt.remove(atOffsets: offsets)
        self.yeardaysstring.YearDayString.remove(atOffsets: offsets)
        //self.times.Time.remove(atOffsets: offsets)
        UserDefaults.standard.set(self.contents.Schedule, forKey:"Schedule")
        UserDefaults.standard.set(self.yeardaysstring.YearDayString, forKey:"YearDayString")
        //UserDefaults.standard.set(self.yeardaysint.YearDayInt, forKey:"YearDayInt")
        UserDefaults.standard.set(self.limitcontents.LimitSchedule, forKey:"LimitSchedule")
    }
    
    // 行入れ替え処理
    func rowReplace(_ from: IndexSet, _ to: Int) {
        self.contents.Schedule.move(fromOffsets: from, toOffset: to)
        self.limitcontents.LimitSchedule.move(fromOffsets: from, toOffset: to)
        self.yeardaysstring.YearDayString.move(fromOffsets: from, toOffset: to)
        //self.yeardaysint.YearDayInt.move(fromOffsets: from, toOffset: to)
        //self.times.Time.move(fromOffsets: from, toOffset: to)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScheduleView(contents: ScheduleList(),limitcontents: ScheduleList(),times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList())
            ScheduleView(contents: ScheduleList(),limitcontents: ScheduleList(),times: ScheduleList(),yeardaysint: ScheduleList(),yeardaysstring: ScheduleList())
        }
    }
}

