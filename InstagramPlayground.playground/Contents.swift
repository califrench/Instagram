//: Playground - noun: a place where people can play

import Foundation

let api = InstagramAPI(clientId: "bcbe2c3e2971438b99083178e8614801", clientSecret: "9c0a376208c34d5d88a7db108e59a2bd")
api.accessToken = "404827908.bcbe2c3.8bbfa532f74040c7b98528710f4bb8a7"
api.searchForUser("califrench") { user in
    print(user)
}