module Concerns
  # Stacks for {Test}
  module Main
    module Substacks
      extend ActiveSupport::Concern
      included do
        resource :skeleton_stacks,
                 type: Halloumi::AWS::CloudFormation::Stack do |r|
          r.property(:template_url) do
            "#{ENV["STACK_NAME"]}-skeleton-stack.json"
          end
        end
        resource :web_stacks,
                 type: Halloumi::AWS::CloudFormation::Stack do |r|
          r.property(:template_url) do
            "#{ENV["STACK_NAME"]}-web-stack.json"
          end 
          r.property(:parameters) do
            {
              SkeletonVpcId: skeleton_stack.ref_output_SkeletonVpcId,
              SkeletonInternetGatewayId: skeleton_stack.ref_output_SkeletonInternetGatewayId,
              SkeletonRouteTableId: skeleton_stack.ref_output_SkeletonRouteTableId
            }
          end
        end
        resource :lambda_stacks,
                 type: Halloumi::AWS::CloudFormation::Stack do |r|
          r.property(:template_url) do
          "#{ENV["STACK_NAME"]}-lambda-stack.json"
          end
           
        end
      end
    end
  end
end
