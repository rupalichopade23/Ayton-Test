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
      end
    end
  end
end
