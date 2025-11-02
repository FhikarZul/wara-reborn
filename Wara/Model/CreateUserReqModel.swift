//
//  CreateUserReqModel.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

struct CreateUserReqModel: Encodable {
    let userId: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
