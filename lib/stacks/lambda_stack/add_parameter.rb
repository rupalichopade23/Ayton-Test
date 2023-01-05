module Concerns
    module LambdaAddParameter
      module Parameters
      extend ActiveSupport::Concern
      included do
        property :lambda_ec2,
                 env: :LAMBDA_LAMBDA_EC2,
                 required: true
        property :lambda_ec2,
                 env: :LAMBDA_LAMBDA_EC2,
                 required: true
        resource :lambda_roles,
                 type: Halloumi::AWS::IAM::Role do |r|
          r.property(:path) { "/" }
          r.property(:assume_role_policy_document) do
            {
              Version: "2012-10-17",
              Statement: [
                {
                  Effect: :Allow,
                  Principal: {
                    Service: "lambda.amazonaws.com"
                  },
                  Action: [
                    "sts:AssumeRole"
                  ]
                }
              ]
            }
          end
          r.property(:policies) do
            [
              {
                PolicyName: "AllowAccess",
                PolicyDocument: {
                  "Statement": [
                    {
                      "Effect": "Allow",
                      "Action": [
                        "ssm:PutParameter",
                  
                      ],
                      "Resource": "*"
                    },
                    
                  ]
                }
              }
            ]
          end
          
        end
        resource :lambda,
                 type: Halloumi::AWS::Lambda::Function do |r|
          r.property(:handler) { "index.handler" }
          r.property(:timeout) { 180 }
          r.property(:runtime) { "python3.9" }
          r.property(:code) do
            {
              "S3Bucket": ENV["LAMBDA_BUCKET"],
              "S3Key": lambda_ec2
            }
          end
          r.property(:role) { lambda_role.ref_arn }
          # r.property(:environment) do
          #   {
          #     "Variables": {
          #       "ENVIRONMENT": stack_name,
          #       "SOURCE_HOST": "rds-#{stack_name}.#{hosted_zone_name}",
          #       "SECRETNAME": db_secret_name
          #     }
          #   }
          # end
          
        end