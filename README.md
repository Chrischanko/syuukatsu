# syuukatsu<br>
就活管理を行うアプリのスクリプトのみ<br>

#REC_SCHeduleApp.swift<br>
ランチスクリーンを表示するスクリプト<br>

#LaunchScreen.swift<br>
アプリ起動時にアイコンの表示後、ContentViewを表示するスクリプト<br>

#ContentView.swift<br>
タブとタブのクリックでScheduleView、CompanyView、MapView、NewsView、SupportViewのそれぞれを表示するスクリプト<br>
また、1、11、21日以降の起動初日に10日間、1ヶ月目標を見直すアラート文を表示する。<br>

#ScheduleView.swift<br>
スケジュールをリスト化して、表示するスクリプト<br>
今日の予定と明日以降の予定という2種類に分けて、日付、時間、内容、場所を表示する。<br>

＞課題点<br>
　　　日付に合わせて並び替える<br>
　　　スケジュールをお知らせする<br>
   　過ぎた予定を削除する<br>
    
#ScheduleInputView.swift<br>
スケジュールの入力を行うスクリプト<br>

#CompanyView.swift<br>
気になる企業をリスト化して、表示するスクリプト<br>
    
#CompanyDetailView.swift<br>
企業に関する情報をメモしておくスクリプト<br>

＞課題点<br>
　　　企業URLやマイページのURLなども添付出来るようにする？<br>
   　もう少し、細かい表示にする？<br>
    
#MapView.swift<br>
マップ検索を行えるスクリプト<br>

＞課題点<br>
　　　地名が入る場所を入力すると、上手く狙いの場所が表示されない時がある。<br>
     ＞MapKitの精度の限界<br>

#NewsView.swift<br>
気になるニュースをリスト化して、表示するスクリプト

#NewsInputView.swift<br>
ニュースに関する情報をメモしておくスクリプト<br>

#SupportView.swift<br>
10日間、1ヶ月目標、Todoリスト、反省点、今日の名言を表示するスクリプト<br>
目標、Todoリスト、反省点に関しては、編集可能です。
