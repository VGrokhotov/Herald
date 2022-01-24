//
//  Payload.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 02.06.2021.
//

import JWTKit

struct Payload: JWTPayload {
    
    enum CodingKeys: String, CodingKey {
        case username = "usrn"
        case expiration = "exp"
    }

    var username: String

    var expiration: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
