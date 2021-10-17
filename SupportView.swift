//  PositiveView.swift
//  REC_Schedule

//あったら良いな　ー＞　横スクロールで移動

import SwiftUI
//格言に関する保存
class CounterList: ObservableObject {
    //日時、予定、場所
    @Published var counter : Int {
           didSet {
        UserDefaults.standard.set(counter, forKey: "Counter")
           }
    }
    @Published var before : Date {
           didSet {
        UserDefaults.standard.set(before, forKey: "Before")
           }
    }
    // 初期化処理
    init() {
        counter = UserDefaults.standard.integer(forKey: "Counter")
        before = UserDefaults.standard.object(forKey: "Before") as? Date ?? Date()
    }
}
//目標・Todo・反省点に関する保存
class GoalList: ObservableObject {
    //1ヶ月目標
    @Published var MonthGoal : String {
        didSet {
            UserDefaults.standard.set(MonthGoal, forKey: "MonthGoal")
        }
    }
    //10間目標
    @Published var TenGoal : String {
        didSet {
            UserDefaults.standard.set(TenGoal, forKey: "TenGoal")
        }
    }
    //TODO
    @Published var TodoPoint: String {
        didSet {
            UserDefaults.standard.set(TodoPoint, forKey: "TodoPoint")
        }
    }
    //反省点
    @Published var Reflection : String {
        didSet {
            UserDefaults.standard.set(Reflection, forKey: "Reflection")
        }
    }
    // 初期化処理
    init()
    {
        MonthGoal = UserDefaults.standard.string(forKey: "MonthGoal") ?? ""
        TenGoal = UserDefaults.standard.string(forKey: "TenGoal") ?? ""
        TodoPoint = UserDefaults.standard.string(forKey: "TodoPoint") ?? ""
        Reflection = UserDefaults.standard.string(forKey: "Reflection") ?? ""
    }
}

struct SupportView: View {
    //目標・TODOリスト・反省・今日の名言　共通の変数宣言
    @State private var isPushedSupport = false // 編集・完了ボタンにより変更可
    //目標に関する変数宣言
    @State private var isPushedGoal = true // ボタンにより変更可
    @ObservedObject var MonthGoals : GoalList
    @ObservedObject var TenGoals : GoalList
    //反省点に関する変数宣言
    @State private var isPushedReflection = false
    @ObservedObject var Reflections : GoalList
    //TODOリストに関する変数宣言
    @State private var isPushedTodoPoint = false
    @ObservedObject var TodoPoints : GoalList
    //格言に関する変数宣言
    @State private var isPushedWitticism = false
    @ObservedObject var Counter : CounterList
    @ObservedObject var Before : CounterList
    @State var Now = Date()
    @State var witticism = ["「好きなこと」は人を動かす原動力になる。","唯一ネガティブな時間から逃れられる人生の隠しコマンド、それが“没頭”である", "才能とは「ご褒美を見つけられる能力」のこと","自ら機会を創り出し、機会によって自らを変えよ","努力は必ず報われる。"+"\n"+" もし報われない努力があるのならば、それはまだ努力と呼べない。","The journey is the reward"+"\n"+"（旅の過程にこそ価値がある）","賛否両論が巻き起こるというのも、作り手にとってはすごく面白いこと","みんなと同じだったら、一番楽だろう。不安もなくなる。でも、その代わり個性もないってことになる。あいつは変わってる、と言われるのは光栄なことだ。１回きりしかない人生なんだから、自分の好きなように、自分に正直に生きようよ。","If you can dream it, you can do it"+"\n"+" (夢見ることができれば、それは実現できる)","「ガムシャラにやる」だけでは足りない。"+"\n"+"「先を想定し、課題を見つけて考える」課題は未来のために必要なこと","Failure is inevitable. Success is elusive."+"\n"+"(失敗とは避けられないものであり、成功とは手に入れにくいものだ)","どうやってヒットを打ったのかが問題です。たまたま出たヒットではなにも得られません。"]
    @State var person = ["星野源","若林正恭", "岩田聡","江副浩正","王貞治","スティーブ・ジョブズ","新海誠","志村けん","Walt Disney","中村俊輔","スティーブン・スピルバーグ","イチロー"]
    @State var profession = ["歌手・俳優・文筆家","お笑い芸人", "任天堂前社長","リクルート創業者","プロ野球選手","Apple創業者","映画監督","コメディアン","アニメーター","プロサッカー選手","映画監督","プロ野球選手"]
    @State var source = ["ORIKON NEWS","ナナメの夕暮れ","ほぼ日刊イトイ新聞","GLOBIS知見録","NONE","NONE","Yahoo!Japan映画","NONE","NONE","NONE","NONE","NONE"]
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack() {
                    ScrollView(.horizontal) {
                        HStack(){
                            //赤色の目標ボタンを押すと、関連部分が表示
                            Button(action: {
                                isPushedGoal = true
                                isPushedTodoPoint = false
                                isPushedReflection = false
                                isPushedWitticism = false
                            }) {
                                Text("目標")
                            }
                            .padding()
                            .font(.system(size: 20))
                            .accentColor(Color.white)
                            .background(Color.red)
                            //青色のTodoボタンを押すと、関連部分が表示
                            Button(action: {
                                isPushedGoal = false
                                isPushedTodoPoint = true
                                isPushedReflection = false
                                isPushedWitticism = false
                            }) {
                                Text("Todo")
                            }
                            .padding()
                            .font(.system(size: 20))
                            .accentColor(Color.white)
                            .background(Color.blue)
                            //緑色の反省点を押すと、関連部分が表示
                            Button(action: {
                                isPushedGoal = false
                                isPushedTodoPoint = false
                                isPushedReflection = true
                                isPushedWitticism = false
                            }) {
                                Text("反省点")
                            }
                            .padding()
                            .font(.system(size: 20))
                            .accentColor(Color.white)
                            .background(Color.green)
                            //黄色の今日の名言ボタンを押すと、関連部分が表示
                            Button(action: {
                                isPushedGoal = false
                                isPushedTodoPoint = false
                                isPushedReflection = false
                                isPushedWitticism = true
                            }) {
                                Text("今日の名言")
                            }
                            .padding()
                            .font(.system(size: 20))
                            .accentColor(Color.white)
                            .background(Color.yellow)
                        }
                        
                    }.frame(height: 40)
                }
                //目標を表示
                if ( isPushedGoal == true ) {
                    Color.red
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 20)
                    Section() {
                        //今月目標
                        Text("今月の目標")
                            .font(.system(size: 25))
                            .padding()
                            .onAppear(){
                            //中身を確認
                                if ( self.MonthGoals.MonthGoal == "" ) {
                                    self.MonthGoals.MonthGoal = "今月の目標を記入"
                                }
                            }
                        if (isPushedSupport == true) {
                            TextEditor( text: self.$MonthGoals.MonthGoal )
                                .font(.system(size: 25))
                                .border(Color.black, width: 1)
                                .environment(\.locale, Locale(identifier: "ja_JP"))
                        } else {
                            Text( self.MonthGoals.MonthGoal )
                                .font(.system(size: 25))
                                .onAppear(){
                                //中身を確認
                                    if ( self.MonthGoals.MonthGoal == "" ) {
                                        self.MonthGoals.MonthGoal = "今月の目標を記入"
                                    }
                                }
                        }
                        //10日間目標
                        Text("10日間目標")
                            .font(.system(size: 25))
                            .padding()
                            .onAppear(){
                                //中身を確認
                                if ( self.TenGoals.TenGoal == "" ) {
                                    self.TenGoals.TenGoal = "10日間目標を記入"
                                }
                            }
                        if (isPushedSupport == true) {
                            TextEditor( text: self.$TenGoals.TenGoal )
                                .font(.system(size: 25))
                                .border(Color.black, width: 1)
                                .environment(\.locale, Locale(identifier: "ja_JP"))
                        } else {
                            Text( self.TenGoals.TenGoal )
                                .font(.system(size: 25))
                                .onAppear(){
                                    //中身を確認
                                    if ( self.TenGoals.TenGoal == "" ) {
                                        self.TenGoals.TenGoal = "10日間目標を記入"
                                    }
                                }
                        }
                    }
                }
                //Todoを表示
                if ( isPushedTodoPoint == true ) {
                    Color.blue
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 20)
                    Section() {
                        //今日のTODO
                        Text("今日のTodo")
                            .font(.system(size: 25))
                            .padding()
                            .onAppear(){
                            //中身を確認
                                if ( self.TodoPoints.TodoPoint == "" ) {
                                    self.TodoPoints.TodoPoint = "今日のTodoリストを記入"
                                }
                            }
                        if (isPushedSupport == true) {
                            TextEditor( text: self.$TodoPoints.TodoPoint )
                                .font(.system(size: 25))
                                .border(Color.black, width: 1)
                                .environment(\.locale, Locale(identifier: "ja_JP"))
                        } else {
                            Text( self.TodoPoints.TodoPoint )
                                .font(.system(size: 25))
                                .onAppear(){
                                //中身を確認
                                    if ( self.TodoPoints.TodoPoint == "" ) {
                                        self.TodoPoints.TodoPoint = "今日のTodoリストを記入"
                                    }
                                }
                        }
                    }
                }
                //反省点を表示
                if ( isPushedReflection == true ) {
                    Color.green
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 20)
                    Section() {
                        //先月の反省点
                        Text("先月の反省点")
                            .font(.system(size: 25))
                            .padding()
                            .onAppear(){
                                if ( self.Reflections.Reflection == "" ) {
                                    self.Reflections.Reflection = "先月の反省点を記入"
                                }
                            }
                        if (isPushedSupport == true) {
                            TextEditor( text: self.$Reflections.Reflection )
                                .font(.system(size: 25))
                                .border(Color.black, width: 1)
                                .environment(\.locale, Locale(identifier: "ja_JP"))
                        } else {
                            Text( self.Reflections.Reflection )
                                .font(.system(size: 25))
                                .onAppear(){
                                    if ( self.Reflections.Reflection == "" ) {
                                        self.Reflections.Reflection = "先月の反省点を記入"
                                    }
                                }
                        }
                    }
                }
                //今日の格言を表示
                if ( isPushedWitticism == true ) {
                    Color.yellow
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 20)
                    Section() {
                        //今日の名言を１日１つ表示
                        Text("今日の名言")
                            .font(.system(size: 25))
                            .padding()
                        //.border(Color.black, width: 3)
                        Text("\(witticism[self.Counter.counter])")
                            .font(.system(size: 25))
                        Text("-\(person[self.Counter.counter])(\(profession[self.Counter.counter]))-")
                            .font(.system(size: 20))
                            .onAppear(){
                                let TodayDC = Calendar.current.dateComponents([.year, .month, .day], from:Now)
                                let BeforeDC = Calendar.current.dateComponents([.year, .month, .day], from: self.Before.before)
                                if ( self.Counter.counter == witticism.count ) {
                                    self.Counter.counter = 0
                                }
                                if (  TodayDC != BeforeDC ) {
                                    self.Counter.counter += 1
                                }
                                self.Before.before = Now
                                UserDefaults.standard.set(self.Before.before,forKey: "Before")
                                UserDefaults.standard.set(self.Counter.counter,forKey: "Counter")
                            }
                    }
                }
            }
        //ナビゲーションバーの編集
        .navigationBarItems(
            leading:
                Button( action:{
                    self.isPushedSupport.toggle()})
                { if ( isPushedSupport == false ) {
                    Text("編集")
                        .buttonStyle(BorderlessButtonStyle())
                        .font(.system(size: 30))
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                } else if ( isPushedSupport == true ) {
                Text("完了")
                        .buttonStyle(BorderlessButtonStyle())
                        .font(.system(size: 30))
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                }
                }
        )
        .navigationBarTitle("サポート")
    }
}
}
struct Support_Previews: PreviewProvider {
    static var previews: some View {
        SupportView(MonthGoals:GoalList(),TenGoals:GoalList(),Reflections:GoalList(), TodoPoints:GoalList(),Counter:CounterList(),Before:CounterList())
    }
}
