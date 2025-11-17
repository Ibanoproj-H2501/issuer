def response_possible_credentials
  '
  {
    "batch_credential_issuance": {
      "batch_size": 100
    },
    "credential_configurations_supported": {
      "eu.europa.ec.eudi.employee_mdoc": {
        "credential_metadata": {
          "claims": [
            {
              "display": [
                {
                  "locale": "en",
                  "name": "Given Name(s)"
                }
              ],
              "mandatory": true,
              "path": [
                "eu.europa.ec.eudi.employee.1",
                "given_name"
              ],
              "value_type": "string"
            },
            {
              "display": [
                {
                  "locale": "en",
                  "name": "Family Name(s)"
                }
              ],
              "mandatory": true,
              "path": [
                "eu.europa.ec.eudi.employee.1",
                "family_name"
              ],
              "value_type": "string"
            },
            {
              "display": [
                {
                  "locale": "en",
                  "name": "Birth Date"
                }
              ],
              "mandatory": true,
              "path": [
                "eu.europa.ec.eudi.employee.1",
                "birth_date"
              ],
              "value_type": "full-date"
            },
            {
              "display": [
                {
                  "locale": "en",
                  "name": "Employee ID"
                }
              ],
              "mandatory": true,
              "path": [
                "eu.europa.ec.eudi.employee.1",
                "employee_id"
              ],
              "value_type": "string"
            },
            {
              "display": [
                {
                  "locale": "en",
                  "name": "Employer Name"
                }
              ],
              "mandatory": true,
              "path": [
                "eu.europa.ec.eudi.employee.1",
                "employer_name"
              ],
              "value_type": "string"
            },
            {
              "display": [
                {
                  "locale": "en",
                  "name": "Employment Start Date"
                }
              ],
              "mandatory": true,
              "path": [
                "eu.europa.ec.eudi.employee.1",
                "employment_start_date"
              ],
              "value_type": "full-date"
            },
            {
              "display": [
                {
                  "locale": "en",
                  "name": "Employment Type"
                }
              ],
              "mandatory": true,
              "path": [
                "eu.europa.ec.eudi.employee.1",
                "employment_type"
              ],
              "value_type": "string"
            },
            {
              "display": [
                {
                  "locale": "en",
                  "name": "Country Code"
                }
              ],
              "mandatory": true,
              "path": [
                "eu.europa.ec.eudi.employee.1",
                "country_code"
              ],
              "value_type": "string"
            }
          ],
          "display": [
            {
              "locale": "en",
              "logo": {
                "alt_text": "A square figure of a PID",
                "uri": "https://examplestate.com/public/pid.png"
              },
              "name": "Employee ID (MSO Mdoc)"
            }
          ]
        },
        "credential_signing_alg_values_supported": [
          -7
        ],
        "cryptographic_binding_methods_supported": [
          "jwk",
          "cose_key"
        ],
        "doctype": "eu.europa.ec.eudi.employee.1",
        "format": "mso_mdoc",
        "policy": {
          "batch_size": 15,
          "one_time_use": true
        },
        "proof_types_supported": {
          "jwt": {
            "proof_signing_alg_values_supported": [
              "ES256"
            ]
          }
        },
        "scope": "eu.europa.ec.eudi.employee_mdoc"
      }
    }
  }
  '
end