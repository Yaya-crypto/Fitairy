//
//  Search.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 12/12/22.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {
    enum State {
        case notSearchedYet
        case noResults
        case results(FoodEntry)
    }
    
    private(set) var state: State = .notSearchedYet
    private var dataTask: URLSessionDataTask?
    
    
    func performSearch(for text: String, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()
            
            let url = performAPI(searchText: text)
            let session = URLSession.shared
            
            dataTask = session.dataTask(with: url as URLRequest) {
                data, response, error in
                var newState = State.notSearchedYet
                var success = false
                
                if let error = error as NSError?, error.code == -999 {
                    print("ERRORRRR?????")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 || httpResponse.statusCode == 404, let data = data {
                    let searchResults = self.parseJSON(data: data)
                    if searchResults == nil || searchResults!.foods.isEmpty {
                        newState = .noResults
                    } else {
                        newState = .results(searchResults!)
                    }
                    success = true
                }
                
                DispatchQueue.main.async {
                    self.state = newState
                    completion(success)
                }
            }
            dataTask?.resume()
        }
    }
    
    
    /*
     Required Headers
     Body is user input (e.g "One cup on orange juice")
     */
    private func performAPI(searchText: String) -> NSMutableURLRequest {
        let headers = [
            "x-app-id": "6aed71f3",
            "x-app-key": "7a0d942304579d189e44f433f28c8c0d",
            "x-remote-user-id": "0"
        ]
        
        let body: [String: String] = ["query": searchText]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        let request = NSMutableURLRequest(url: NSURL(string: "https://trackapi.nutritionix.com/v2/natural/nutrients")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
        
    }
    
    /*
     Parse the results from /vs/natural/nutrients API to a FoodEntry
     */
    private func parseJSON(data: Data) -> FoodEntry? {
        
        var returnValue: FoodEntry?
        
        do {
            returnValue = try JSONDecoder().decode(FoodEntry.self, from: data)
        } catch {
            print("Error took place\(error.localizedDescription).")
        }
        
        return returnValue
    }
}
