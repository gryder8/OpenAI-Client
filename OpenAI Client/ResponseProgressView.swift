//
//  ResponseProgressView.swift
//  OpenAI Client
//
//  Created by Gavin Ryder on 1/16/23.
//

import SwiftUI

struct ResponseProgressView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray.opacity(0.4))
            ProgressView {
                Text("Awaiting\nResponse...")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, design: .rounded))
                
            }
            .scaleEffect(1.5)
        }
        .frame(width: 120, height: 120)
        .fixedSize()
    }
}

struct ResponseProgressViewV2: View {
    
    @State private var i = 0
    @State private var timer: Timer? = nil
    
    func demo(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            i = (i % 3) + 1
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray.opacity(0.4))
                .frame(width: 80, height: 30)
                .fixedSize()
            Text(String(repeating: ".", count: i))
                .font(.system(size: 64, design: .rounded))
                .padding(.bottom, 35)
                .foregroundColor(.black.opacity(0.65))
        }
        .frame(maxWidth: 50, maxHeight: 10)
        .onAppear {
            demo()
        }
        
        .onDisappear {
            if let _ = timer {
                timer!.invalidate()
                timer = nil
                print("Timer invalidated!")
            }
        }
    }
}


struct ResponseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ResponseProgressView()
            ResponseProgressViewV2()
        }
    }
}
