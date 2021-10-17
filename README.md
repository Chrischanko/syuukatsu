# syuukatsu
就活管理を行うアプリのスクリプトのみ

#REC_SCHeduleApp.swift
ランチスクリーンを表示するスクリプト

#LaunchScreen.swift<br>
アプリ起動時にアイコンの表示後、ContentViewを表示するスクリプト<br>

#ContentView.swift
タブとタブのクリックでScheduleView、CompanyView、MapView、NewsView、SupportViewのそれぞれを表示するスクリプト
また、1、11、21日以降の起動初日に10日間、1ヶ月目標を見直すアラート文を表示する。

#ScheduleView.swift
スケジュールをリスト化して、表示するスクリプト
今日の予定と明日以降の予定という2種類に分けて、日付、時間、内容、場所を表示する。

＞課題点
　　　日付に合わせて並び替える
　　　スケジュールをお知らせする
   　過ぎた予定を削除する
    
#ScheduleInputView.swift
スケジュールの入力を行うスクリプト

#CompanyView.swift
気になる企業をリスト化して、表示するスクリプト
    
#CompanyDetailView.swift
企業に関する情報をメモしておくスクリプト

＞課題点
　　　企業URLやマイページのURLなども添付出来るようにする？
   　もう少し、細かい表示にする？
    
#MapView.swift
マップ検索を行えるスクリプト

＞課題点
　　　地名が入る場所を入力すると、上手く狙いの場所が表示されない時がある。
     ＞MapKitの精度の限界

#NewsView.swift

#NewsInputView.swift

#SupportView.swift

