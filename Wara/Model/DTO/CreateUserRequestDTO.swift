//
//  CreateUserReqModel.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

/// Request DTO untuk membuat user di backend.
/// Field `user_id` akan dikirim sesuai spesifikasi API.
struct CreateUserRequestDTO: Encodable {
    let userId: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
