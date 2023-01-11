# Hamli-Network-Layer
A simple network layer based on URLSession


### Current Features:

- Simple and Flexible
- Support Multi-Part 
- Unit Tests are added
- Different ranges of HTTP errors handled

## TODO
- [ ] Download Task
- [ ] Upload Task

## Usage

First you need to define your own Network manager class to customize your Error Model.

This class can be something like this:

```swift

import Foundation

class NetworkManager<EndPoint: EndPointType, ErrorModel: Codable> {
    
    // MARK: Variable
    private var router = Router<EndPoint, ErrorModel>()
    typealias ResponseCompletion<T: Decodable> = (_ result: Result<T, NetworkError<ErrorModel>>) -> Void
    typealias DownloadedCompletion = (_ result: Result<Data, NetworkError<ErrorModel>>) -> Void
    
    
    // MARK: Function
    func requestToRouter<ModelType>(_ route: EndPoint, modelType: ModelType.Type, completion: @escaping ResponseCompletion<ModelType>) where ModelType: Decodable {
        router.request(route) {[weak self] result in
            guard let _self = self else { return }
            _self.handleResponse(result, _self, completion: completion)
        }
    }
    
    func download<ModelType>(_ route: EndPoint, modelType: ModelType.Type, completion: @escaping DownloadedCompletion) {
        router.request(route) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(networkError):
                completion(.failure(networkError))
            }
        }
    }

    private func handleResponse<U>(_ result: Result<Data, NetworkError<ErrorModel>>, _ _self: NetworkManager<EndPoint, ErrorModel>, completion: @escaping ResponseCompletion<U>) where U: Decodable {
        switch result {
        case let .success(data):
            let result = _self.decodeData(data, modelType: U.self)
            completion(result)
        case let .failure(networkError):
            completion(.failure(networkError))
        }
    }
    
    private func decodeData<T>(_ data: Data, modelType: T.Type) -> Result<T, NetworkError<ErrorModel>> where T: Decodable {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return .success(model)
        } catch {
            return .failure(.noData)
        }
    }
}
```

Now you can instantiate from this class and perform your request just by passing your request endpoint and specifying the decoding model.
