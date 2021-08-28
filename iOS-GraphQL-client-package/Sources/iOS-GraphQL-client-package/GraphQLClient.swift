import Foundation

public struct GraphQLClient {
    public func request() {
        let url = URL(string: "https://api.github.com/graphql")!
        var request: URLRequest = .init(url: url)
        let token = Secret.githubToken
        request.httpMethod = "POST"
        request.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let query = "query findUser { user(login: \"munakata-hisashi\") { bio starredRepositories( first: 3 ) { edges { node { name }}}}}"
        let body = ["query": query]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch let err {
                print("Parse error: \(err)")
            }
        })
        task.resume()
    }
}
