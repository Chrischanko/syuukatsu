//
//  MapView.swift
//  REC_Schedule
//

import SwiftUI
import MapKit

//履歴を閲覧
//精度悪くない？
struct MapView: View {
    // 入力中の文字列
    @State var inputText:String = ""
    // 検索キーワード
    @State var dispSearchKey:String = ""
    // マップ種類
    @State var dispMapType:MKMapType = .standard

    var body: some View {
        // 垂直にレイアウト（縦方向にレイアウト）
        VStack {
            // テキストフィールド（文字入力）
            TextField("キーワードを入力してください",
                      text: $inputText , onCommit: {

                // 入力が完了したので検索キーワードに設定する
                dispSearchKey = inputText
                
                // 検索キーワードをデバックエリアに出力する
                print("入力したキーワード：" + dispSearchKey)
                
            })
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .onTapGesture {
                        UIApplication.shared.closeKeyboard()
            }
            // 余白を追加
            .padding()
            ZStack(alignment: .bottomTrailing) {
                // マップを表示
                MapViewUI(searchKey: dispSearchKey, mapType: dispMapType)
                
                //マップ種類切り替え
                Button(action: {
                    if (dispMapType == .standard ){
                        dispMapType = .satellite
                    } else if (dispMapType == .satellite ){
                        dispMapType = .hybrid
                    } else if (dispMapType == .hybrid) {
                        dispMapType = .standard
                    }})
                {
                    Image(systemName: "map")
                        .resizable()
                        .frame(width:35.0,
                                height:35.0,
                                alignment: .leading)
                }
            }
        }
    }
}
    
struct MapViewUI: UIViewRepresentable {
    // 検索キーワード
    let searchKey:String
    // マップ種類
    let mapType: MKMapType
    
    // 表示する View を作成するときに実行
    func makeUIView(context: Context) -> MKMapView {
        // MKMapViewのインスタンス生成
        MKMapView()
    }

    // 表示した View が更新されるたびに実行
    func updateUIView(_ uiView: MKMapView, context: Context) {

        // 入力された文字をデバックエリアに表示
        print(searchKey)

        // マップ種類の設定
        uiView.mapType = mapType

        // CLGeocoderインスタンスを取得
        let geocoder = CLGeocoder()

        // 入力された文字から位置情報を取得
        geocoder.geocodeAddressString(
            searchKey ,
            completionHandler: { (placemarks,error) in
            // リクエストの結果が存在し、1件目の情報から位置情報を取り出す
            if let unwrapPlacemarks = placemarks ,
               let firstPlacemark = unwrapPlacemarks.first ,
               let location = firstPlacemark.location {

                // 位置情報から緯度経度をtargetCoordinateに取り出す
                let targetCoordinate = location.coordinate

                // 緯度経度をデバッグエリアに表示
                print(targetCoordinate)

                // MKPointAnnotationインスタンスを取得し、ピンを生成
                let pin = MKPointAnnotation()

                // ピンの置く場所に緯度経度を設定
                pin.coordinate = targetCoordinate

                // ピンのタイトルを設定
                pin.title = searchKey

                // ピンを地図に置く
                uiView.addAnnotation(pin)

                // 緯度経度を中心にして半径500mの範囲を表示
                uiView.region = MKCoordinateRegion(
                    center: targetCoordinate,
                    latitudinalMeters: 500.0,
                    longitudinalMeters: 500.0)
            }
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
