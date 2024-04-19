//
//  AnimalModel.swift
//  CatOrDogV1
//
//  Created by Liu, Emily on 4/8/24.
//

import Foundation
//this file is for requesting data from the network

class AnimalModel: ObservableObject{
    @Published var animal = Animal() //create an instance that u want to see anywhere -> use @published
    
    func getAnimal(){
        let stringUrl = Bool.random() ?catUrl:dogUrl
        
        //1. create a url objecct - get url for API
        let url = URL(string: stringUrl)
        
        //2. check if url is not nil - make sure url exists
        guard url != nil else
        {
            print ("Couldn't create the url object")
            return
        }
        
        //3. get url session - connect to the url
        let session = URLSession.shared
        
        //4. create a data task
        let dataTask = session.dataTask(with: url!){
            (data, response, error) in
            //check for error
            if error == nil && data != nil{ //means there are no errors
                //attempt o parse jsoon
                do{
                    if let json = try
                        JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]{ //using json serialization to read the format of the file
                        
                        let item = json.isEmpty ? [:] : json[0]
                        //json [0] gives us the first response
                        
                        if let animal = Animal(json: item){
                            //put image data and instance of animal in here
                            DispatchQueue.main.async {
                                while animal.results.isEmpty{}
                                self.animal = animal
                            }
                        }
                    }//end of try
                }//end of do
                catch{
                    print("Could not parse JSON")
                }
            }
            
        }
            
        
        //5. start the data task
        dataTask.resume()
        
    }
    
}
