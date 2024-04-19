//
//  Animal.swift
//  CatOrDogV1
//
//  Created by Liu, Emily on 4/8/24.
//

import Foundation

import CoreML
import Vision

//give us a label of cat or dog -> looks at giant database labeled cat and dog and looks at featuees of a cat and dog
//confidence of how accurate the answer is is also returned, also returns list of what it thinks it is

struct Results: Identifiable{
    var imageLabel: String
    var confidence: Double
    var id = UUID() //creating unique identifier-> unique number has to be tracked for that sepcific reference
    //class create different instances  strucutre: modifiable
    //mobilenetv2
    //sample file is how json looks like
}

class Animal {
    //url for the image
    var imageUrl: String
    //image data
    var imageData: Data?
    
    //results of classifier
    var results: [Results]
    
    //access to mobilenetv2
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration)
    
    init(){
        self.imageUrl = ""
        self.imageData = nil
        self.results = []
    }
    
    init?(json:[String: Any]){
    //check for url
    //throw catch - finds the problem and returns - similar to guard
    guard let imageUrl = json["url"] as? String else
    {
        return nil
    }
    
    //set image information
    self.imageUrl = imageUrl
    self.imageData = nil
    
    getImage()
    
}

    func getImage(){
        //to be coded
        //1. create url object
        let url = URL(string: imageUrl)
        
        //2. check url is not nil
        guard url != nil else{
            print("could not return url")
            return
        }
        
        //3. get a url session
        let session = URLSession.shared
        
        //4. create a data task
        let dataTask = session.dataTask(with: url!)
        {(data, response, error) in
            
            //get the data
            //we do not have to parse the data; its already available
            //because we got it in the AnimalModel Class using json
            
            //check if there are erros that data is not nil
            if error == nil && data != nil{
                self.imageData = data
                //classification call made here 
                self.classifyAnimal()
            }
            
        }
        //5. start a data task
        dataTask.resume()
    }
    
    func classifyAnimal(){
        //1. getting a reference to the model (e.g. mobilevnet2)
        let model = try! VNCoreMLModel(for: modelFile.model)
        //2. getting image handler
        let hamdler = VNImageRequestHandler(data: imageData!)
        //3. creating a request to the model
        let request = VNCoreMLRequest(model: model){
            (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Could not classify the animal") //? so it can return nil
                return
            }
            
            for classificiation in results{
                var identifier = classificiation.identifier
                
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                
                self.results.append(Results(imageLabel: identifier, confidence: Double(classification.confidence)))
            }
                    
            //try catch before u initialize a function
            //do catch after u initialize a function
            
            do{
                try handler.perform([request])
            }
            catch{
                print("Invalid Image")
            }
                    
            //if successful ....do this else ...do this (guard is successful first)
        }
        //4. execute the request
    }
    
    
}
