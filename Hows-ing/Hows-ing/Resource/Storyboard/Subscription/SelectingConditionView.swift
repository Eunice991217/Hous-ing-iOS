//
//  SelectingConditionView.swift
//  Hows-ing
//
//  Created by 윤지성 on 2023/10/08.
//

import SwiftUI

struct SelectingConditionView: View {
    var body: some View {
        VStack{
            ScrollView{
                Text("AI 청약 추천")
                    .font(.custom("Pretendard-SemiBold", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
        }
        
    }
}

struct SelectingConditionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectingConditionView()
    }
}
