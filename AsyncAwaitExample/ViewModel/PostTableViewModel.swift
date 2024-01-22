//
//  PostTableViewModel.swift
//  AsyncAwaitExample
//
//  Created by SeungMin on 12/31/23.
//

final class PostTableViewModel {
    var posts: [Post] = []
    var filteredPosts: [Post] = []
    
    func request(requestType: TargetType) async {
        switch requestType {
        case .getUsers:
            print("User")
        case .getPosts:
            do {
                try await NetworkManager.shared.request(requestType: .getPosts) { (result: Result<[Post], NetworkError>) in
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
