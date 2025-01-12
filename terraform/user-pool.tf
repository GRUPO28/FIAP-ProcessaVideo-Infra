module "cognito_user_pool" {
  source  = "lgallard/cognito-user-pool/aws"
  version = "0.33.0"

  user_pool_name           = "processa-video"
  auto_verified_attributes = ["email"]

  deletion_protection = "INACTIVE"

  admin_create_user_config = {
    email_subject = "Processa Video - Código de Verificação"
    email_message = "{username}, seu código de verificação é {####}"
    allow_admin_create_user_only = false
  }

  email_configuration = {
    email_sending_account  = "COGNITO_DEFAULT"
  }

  username_configuration = {
    case_sensitive = false
  }

  password_policy = {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
    temporary_password_validity_days = 7
  }

  recovery_mechanisms = [
    {
      name     = "verified_email"
      priority = 1
    }
  ]

    string_schemas = [
        {
            attribute_data_type      = "String"
            developer_only_attribute = false
            mutable                  = false
            name                     = "email"
            required                 = true

            string_attribute_constraints = {
                min_length = 5
                max_length = 50
            }
        }
    ]

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}

resource "aws_cognito_user_pool_client" "userpool_client" {
  name                                 = "processa-video-client"
  user_pool_id                         = module.cognito_user_pool.id
  callback_urls                        = ["https://google.com"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  depends_on = [ module.cognito_user_pool ]
}

resource "aws_cognito_user_pool_domain" "userpool_domain" {
  domain       = "processa-video-domain"
  user_pool_id = module.cognito_user_pool.id

  depends_on = [ module.cognito_user_pool ]
}