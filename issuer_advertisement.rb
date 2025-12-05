def credential_advertisement
  '
  {
    "credential_issuer": "https://bpissuer.dev:5000",
    "credential_endpoint": "https://bpissuer.dev:5000/credential",
    "authorization_endpoint": "https://issuer.eudiw.dev/authorizationV3",
    "batch_credential_issuance": {
      "batch_size": 100
    },
    "credential_configurations_supported": {
        "eu.europa.ec.eudi.pid_vc_sd_jwt":{
           "format":"dc+sd-jwt",
           "scope":"eu.europa.ec.eudi.pid_vc_sd_jwt",
           "cryptographic_binding_methods_supported":[
              "jwk",
              "cose_key"
           ],
           "credential_signing_alg_values_supported":[
              "ES256"
           ],
           "proof_types_supported":{
              "jwt":{
                 "proof_signing_alg_values_supported":[
                    "ES256"
                 ]
              }
           },
           "display":[
              {
                 "name":"Buypass PID test (sd-jwt-vc)",
                 "locale":"en",
                 "logo":{
                    "uri":"https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/8d/82/e4/8d82e4a3-9920-498e-b1ed-e39f3014fb19/AppIcon-0-1x_U007emarketing-0-7-0-85-220.png/1200x630wa.png",
                    "alt_text":"A square figure of a PID"
                 }
              }
           ],
           "vct":"urn:eudi:pid:1",
           "claims":[
              {
                 "path":[
                    "family_name"
                 ],
                 "mandatory":true,
                 "value_type":"string",
                 "source":"user",
                 "display":[
                    {
                       "name":"Family Name(s)",
                       "locale":"en"
                    }
                 ]
              },
              {
                 "path":[
                    "given_name"
                 ],
                 "mandatory":true,
                 "value_type":"string",
                 "source":"user",
                 "display":[
                    {
                       "name":"Given Name(s)",
                       "locale":"en"
                    }
                 ]
              }
           ],
           "issuer_config":{
              "issuing_authority":"Test PID issuer",
              "organization_id":"EUDI Wallet Reference Implementation",
              "validity":90,
              "organization_name":"Test PID issuer",
              "doctype":"eu.europa.ec.eudi.pid.1"
           }
        }
      }
  }
  '
end

def oauth_server_advertisement
  '   {
    "version": "3.0",
    "token_endpoint_auth_methods_supported": [
        "public"
    ],
    "claims_parameter_supported": true,
    "request_parameter_supported": true,
    "request_uri_parameter_supported": true,
    "require_request_uri_registration": false,
    "grant_types_supported": [
        "authorization_code",
        "implicit",
        "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "refresh_token"
    ],
    "jwks_uri": "https://bpissuer.dev:5000/static/jwks.json",
    "scopes_supported": [
        "openid"
    ],
    "response_types_supported": [
        "code"
    ],
    "response_modes_supported": [
        "query",
        "fragment",
        "form_post"
    ],
    "subject_types_supported": [
        "public",
        "pairwise"
    ],
    "id_token_signing_alg_values_supported": [
        "RS256",
        "RS384",
        "RS512",
        "ES256",
        "ES384",
        "ES512",
        "PS256",
        "PS384",
        "PS512",
        "HS256",
        "HS384",
        "HS512"
    ],
    "userinfo_signing_alg_values_supported": [
        "RS256",
        "RS384",
        "RS512",
        "ES256",
        "ES384",
        "ES512",
        "PS256",
        "PS384",
        "PS512",
        "HS256",
        "HS384",
        "HS512"
    ],
    "request_object_signing_alg_values_supported": [
        "RS256",
        "RS384",
        "RS512",
        "ES256",
        "ES384",
        "ES512",
        "HS256",
        "HS384",
        "HS512",
        "PS256",
        "PS384",
        "PS512"
    ],
    "frontchannel_logout_supported": true,
    "frontchannel_logout_session_required": true,
    "backchannel_logout_supported": true,
    "backchannel_logout_session_required": true,
    "code_challenge_methods_supported": [
        "S256"
    ],
    "issuer": "https://bpissuer.dev:5000",
    "registration_endpoint": "https://oauth-mock.mock.beeceptor.com/registration",
    "introspection_endpoint": "https://bpissuer.dev:5000/introspection",
    "authorization_endpoint": "https://bpissuer.dev:5000/mock/authorization",
    "token_endpoint": "https://bpissuer.dev:5000/mock/token",
    "userinfo_endpoint": "https://oauth-mock.mock.beeceptor.com/userinfo",
    "end_session_endpoint": "https://bpissuer.dev:5000/session",
    "pushed_authorization_request_endpoint": "https://bpissuer.dev:5000/pushed_authorization",
    "credential_endpoint": "https://bpissuer.dev:5000/credential"
}
'
end