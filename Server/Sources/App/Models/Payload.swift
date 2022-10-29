//
//  Payload.swift
//  
//
//  Created by Vladislav Grokhotov on 29.10.2022.
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
