//
//  File.swift
//  SwiftUISample
//
//  Created by skw on 10/15/24.
//

import Foundation

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색 바
                SearchBar()
                    .padding()

                // 뉴스 카드 리스트
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(0..<5) { index in
                            NewsCard(index: index)
                        }
                    }
                    .padding()
                }

                // 카테고리 아이콘
                HStack {
                    ForEach(["뉴스", "스포츠", "연예", "생활"], id: \.self) { category in
                        CategoryButton(title: category)
                    }
                }
                .padding()
            }
            .navigationTitle("네이버")
            .navigationBarHidden(true) // 네비게이션 바 숨기기
        }
    }
}

struct SearchBar: View {
    @State private var searchText: String = ""

    var body: some View {
        HStack {
            TextField("검색어를 입력하세요", text: $searchText)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            Button(action: {
                // 검색 버튼 동작
            }) {
                Text("검색")
            }
        }
    }
}

struct NewsCard: View {
    var index: Int

    var body: some View {
        VStack(alignment: .leading) {
            Image("sample_image") // 이미지 이름은 실제 이미지로 대체해야 함
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(10)

            Text("뉴스 제목 \(index + 1)")
                .font(.headline)
                .padding(.top, 5)

            Text("뉴스 내용 설명입니다. 더 많은 내용을 확인하세요.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct CategoryButton: View {
    var title: String

    var body: some View {
        Button(action: {
            // 카테고리 버튼 동작
        }) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

struct GPTContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//import SwiftUI
//
//struct GPTContentView: View {
//    @State private var showDetail = false // 상세 화면 표시 상태
//
//    var body: some View {
//        ZStack {
//            Color.black
//                .edgesIgnoringSafeArea(.all) // 전체 화면 사용
//            
//            // 자식 뷰: 메인 화면
//            GPTMainView(showDetail: $showDetail) // showDetailState 제거
//                .frame(maxWidth: .infinity, maxHeight: .infinity) // 전체 화면 크기 유지
//            
//            // 상세 화면
//            if showDetail {
//                GPTDetailView(showDetail: $showDetail) // 상세 화면
//                    .transition(.move(edge: .bottom)) // 아래에서 위로 전환
//                    .animation(.easeInOut) // 애니메이션 효과
//                    .edgesIgnoringSafeArea(.bottom) // 바닥까지 차지
//            }
//        }
//    }
//}
//
//struct GPTMainView: View {
//    @Binding var showDetail: Bool // 부모 뷰와의 연결
//
//    var body: some View {
//        VStack {
//            Text("안녕하세요")
//                .font(.largeTitle)
//                .foregroundColor(.black) // 글자색을 검정색으로 변경
//                .padding()
//
//            Button(action: {
//                withAnimation {
//                    showDetail = true // 상세 화면으로 전환
//                }
//            }) {
//                Text("다음 화면으로 넘어가기")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .frame(width: showDetail ? UIScreen.main.bounds.width * 0.9 : UIScreen.main.bounds.width,
//               height: showDetail ? UIScreen.main.bounds.height * 0.95 : UIScreen.main.bounds.height) // DetailView가 나타날 때만 크기 조정
//        .background(Color.white) // 흰색 배경 추가
//        .cornerRadius(10) // 라운딩 추가
//        .shadow(radius: 10) // 그림자 추가
//        .offset(y: showDetail ? UIScreen.main.bounds.height * 0.05 : 0) // DetailView가 나타날 때 하단에 붙도록 조정
//        .edgesIgnoringSafeArea(.all) // 마지막에 추가
//    }
//}
//
//struct GPTDetailView: View {
//    @Binding var showDetail: Bool // 부모 뷰와의 연결
//
//    var body: some View {
//        VStack {
//            Text("두번째 화면입니다") // 타이틀
//                .font(.largeTitle)
//                .padding()
//
//            Button(action: {
//                withAnimation {
//                    showDetail = false // 뒤로 가기
//                }
//            }) {
//                Text("뒤로 가기")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.94) // 세로 크기 조정
//        .background(Color.white) // 흰색 배경
//        .cornerRadius(10) // 라운딩 추가
//        .shadow(radius: 20) // 깊이감 있는 그림자 추가
//        .offset(y: UIScreen.main.bounds.height * 0.06) // 하단에 붙도록 오프셋 조정
//        .edgesIgnoringSafeArea(.all) // 전체 화면 사용
//    }
//}
//
//struct GPTContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        GPTContentView()
//    }
//}
