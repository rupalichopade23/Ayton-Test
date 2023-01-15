module Concerns
  module LambdaAddParameter
    module Parameters
      extend ActiveSupport::Concern
      included do
        property :code,
                 template: File.expand_path(
                  "../../../lambda/lambda_ec2/index.py",
                  __dir__
                 )
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
        resource :lambdas,
                 type: Halloumi::AWS::Lambda::Function do |r|
          r.property(:handler) { "index.lambda_handler" }
          r.property(:timeout) { 180 }
          r.property(:runtime) { "python3.9" }
          r.property(:code) do
            {
              "S3Bucket": ENV["LAMBDA_BUCKET"],
              "S3Key": lambda_ec2
            }
          end
         # r.property(:code) { code }
          r.property(:role) { lambda_role.ref_arn }
          r.property(:environment) do
            {
              "Variables": {
                "ENVIRONMENT": stack_name,
                "PARAMETER_NAME": "/#{stack_name}/#{parameter_name}"
              }
            }
          end
          
        end
      end
    end
  end
end