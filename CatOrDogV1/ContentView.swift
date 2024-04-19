//
//  ContentView.swift
//  CatOrDogV1
//
//  Created by Liu, Emily on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: AnimalModel //plug in user interface, anyone should be able to see and access
    //observable object- ensure I can see this object from anywhere
    var body: some View {
        VStack {
            Image (uiImage: UIImage(data: model.animal.imageData ?? Data()) ?? UIImage()) 
                .resizable()
               .scaledToFit()
                .clipped()
            .edgesIgnoringSafeArea(.all)
                //data has to be converted to image using a class ??= if it is nil make data blank. If blank image give me blank UIImage (blank frame)
            HStack{
                Text("What is it").font(.title)
                    .bold()
                    .padding(.leading, 10)
                Spacer()
                Button(action: {self.model.getAnimal()}, label: {Text("Next").bold()})
                    .padding(.trailing,10)
                
            }
            List(model.animal.results){
                result in
                HStack{
                    Text(result.imageLabel)
                    Spacer()
                    Text(String(format: "%.2f%%", result.confidence*100))
                }
            }
            
        }
        .onAppear(perform: model.getAnimal) //get picture to show up in the beginning
        //.opacity(model.animal.imageData == nil ? 0:1)
        .padding()
    }
}

#Preview {
    ContentView(model: AnimalModel())
}
