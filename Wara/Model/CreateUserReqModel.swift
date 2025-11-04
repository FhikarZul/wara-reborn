//
//  CreateUserReqModel.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

/// Payload untuk membuat user di backend.
/// Field `user_id` akan dikirim sesuai spesifikasi API.
struct CreateUserReqModel: Encodable {
    let userId: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
