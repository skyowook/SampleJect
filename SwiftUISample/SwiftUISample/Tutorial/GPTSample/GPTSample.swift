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
                debugPrint("test")
            }, label: {
                Text("검색")
            })
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
            debugPrint("Test")
        }, label: {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        })
    }
}

struct GPTContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
