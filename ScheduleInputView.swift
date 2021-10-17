//
//  CalendarVIew.swift
//  REC_Schedule

import SwiftUI
//Date型の表示形式を変換する
var dateFormat: DateFormatter {
    let format = DateFormatter()
    format.dateStyle = .full
    format.timeStyle = .full
    format.locale = Locale(identifier: "ja_JP")
    format.calendar = Calendar(identifier: .japanese)
    format.dateFormat = "yyyy-MM-dd HH:mm"
    return format
}
//テキストフィールドとキーボードの位置を見やすくする
class ViewModel: ObservableObject {
    @Published var bottomPadding: CGFloat = 0.0
    init() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] (notification: Notification) -> Void in
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            withAnimation {
                self?.bottomPadding = keyboardFrame.size.height
            }
        }
    }
}
//キーボード部分以外をクリックすることで、キーボードを収納
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ScheduleInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ViewModel()
    @State var flg = true
    //@State var DayString = ""
    @Binding var content: String //予定内容
    @Binding var location: String //場所
    @Binding var Day: String //文字型日付(yyyyMMdd(E))
    @Binding var DayString: String //文字型日付(yyyyMMdd)
    @Binding var DayInt: Int //整数型日付(yyyyMMdd)
    @Binding var startTime: String //開始時刻
    @Binding var endTime: String //終了時刻
    @Binding var Dateschedule: String //日付＋開始時刻＋終了時刻+予定内容＋場所
    @Binding var Onlyschedule: String //開始時刻＋終了時刻+予定内容＋場所
    @State var dateFormatter = DateFormatter() //型変換
    @Binding var day : Date //日付
    @Binding var start : Date //開始時間
    @Binding var end : Date //終了時間
    
    var body: some View {
        ScrollView(.vertical) {
            Section () {
                DatePicker("日付", selection: $day, displayedComponents: [.date])
                    .datePickerStyle(WheelDatePickerStyle())
                    .font(.system(size: 25))
                    .frame(height: 150)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                    }
                }
                Spacer().frame(height:30)
            Section () {
                DatePicker("開始時刻", selection: $start, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .font(.system(size: 25))
                    .frame(height: 150)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                    }
                }
                Spacer().frame(height:30)
            Section () {
                DatePicker("終了時刻", selection: $end, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .font(.system(size: 25))
                    .frame(height: 150)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                    }
                }
            Section () {
                TextField("予定を入力", text: $content)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 25))
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                    }
                TextField("場所を入力", text: $location)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 25))
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                    }
                    .padding(.bottom, viewModel.bottomPadding)
            }
        }
        HStack() {
            Section {
                Button(action: {
                    self.content = ""
                    self.location = ""
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("キャンセル")
                        .font(.system(size: 25))
                }
            }
            Section {
                Button(action: {
                    dateFormatter.dateFormat = "yyyyMMdd"
                    DayString = dateFormatter.string(from: day)
                    DayInt = Int(DayString)!
                    dateFormatter.dateFormat = "yyyy/MM/dd(E)"
                    Day = dateFormatter.string(from: day)
                    dateFormatter.dateFormat = "HH:mm"
                    startTime = dateFormatter.string(from: start)
                    dateFormatter.dateFormat = "HH:mm"
                    endTime = dateFormatter.string(from: end)
                    if ( location.isEmpty) {
                        Dateschedule = Day + "\n" + startTime + "~" + endTime + "\n" + content
                        Onlyschedule = startTime + "~" + endTime + "\n" + content
                    } else {
                        Dateschedule = Day + "\n" + startTime + "~" + endTime + "\n" + content + "\n" + "@" + location
                        Onlyschedule = startTime + "~" + endTime + "\n" + content + "\n" + "@" + location
                    }
                    self.presentationMode.wrappedValue.dismiss()
            }){
                Text("スケジュールに追加")
                    .font(.system(size: 25))
            }
            .disabled(content.count == 0)
        }
        }
    }
}
