//
//  PostTableViewModel.swift
//  AsyncAwaitExample
//
//  Created by SeungMin on 12/31/23.
//

final class PostTableViewModel {
    var posts: [Post] = []
    var filteredPosts: [Post] = []
    
    func request(requestType: RequestType) async {
        switch requestType {
        case .user:
            print("User")
        case .post:
            do {
                try await NetworkManager.shared.request(requestType: .post) { (result: Result<[Post], NetworkError>) in
                    switch result {
                    case .success(let posts):
                        self.posts = posts
                        if !posts.isEmpty && posts.count > 10 {
                            self.filteredPosts = Array(posts[0..<10]).reversed()
                        }
                    case .failure(let error):
                        print(error.description)
                    }
                }
            } catch {
                print(NetworkError.requestFailed)
            }
        }
    }
}
