# frozen_string_literal: true

module Concerns
  # Shared Properties for {Test}.
  module Shared
    module Properties
      extend ActiveSupport::Concern

      included do
        # @!group Properties

        # @!attributes [rw] aws_account_id
        #   Property aws_account_id
        #   @return [Integer] aws_account_id
        property :aws_account_id,
                 env: :AWS_ACCOUNT,
                 required: true

        # @!attributes [rw] aws_region
        #   Property aws_region
        #   @return [String] aws_region
        property :aws_region,
                 env: :AWS_REGION,
                 required: true

        # @!attribute [r] calculated_hosted_zone_name
        #   Property calculated_hosted_zone_name.
        #   @return [String] calculated_hosted_zone_name
        property :calculated_hosted_zone_name,
                 filter: :calc_hosted_zone_name,
                 required: true

        # @!attribute [rw] chef_artifacts_bucket
        #   Property chef_artifacts_bucket.
        #   @return [Object] chef_artifacts_bucket
        property :chef_artifacts_bucket,
                 env: :CHEF_ARTIFACTS_BUCKET,
                 required: true

        # @!attribute [rw] lambda_artifacts_bucket
        #   Property lambda_artifacts_bucket.
        #   @return [Object] lambda_artifacts_bucket
        property :lambda_artifacts_bucket,
                 env: :LAMBDA_ARTIFACTS_BUCKET,
                 required: true

        # @!attribute [rw] enable_patch_scanning
        #   Property enable_patch_scanning
        #   @return [Boolean] enable_patch_scanning
        property :enable_patch_scanning,
                 env: :ENABLE_PATCH_SCANNING,
                 filter: Halloumi::Filters.to_bool,
                 required: true

        # @!attribute [rw] management_subnets
        #   Allow management access from the subnets in this string.
        #   Specify one ore more IP addresses or CIDRs separated by commas
        #   and/or spaces.
        #
        #   @example
        #     "123.45.67.89"
        #   @example
        #     "123.45.67.89/32"
        #   @example
        #     "123.45.67.89 234.56.78.92/30"
        #   @example
        #     "123.45.67.89, 234.56.78.92/30"
        #
        #   @return [String] management_subnets
        property :management_subnets,
                 filter: Halloumi::Filters.string_to_array,
                 env: :MANAGEMENT_SUBNETS

        # @!attribute [rw] stack_name
        #   Property stack_name.
        #   @return [Object] stack_name
        property :stack_name,
                 env: :STACK_NAME,
                 required: true
        # @!attribute [rw] vpc_cidr_block
        #   Property vpc_cidr_block
        #   @return [String] vpc_cidr_block
        property :vpc_cidr_block,
                 env: :SKELETON_VPC_CIDR_BLOCK,
                 default: "10.0.0.0/16",
                 required: true
        property :vpc_public_subnet,
        filter: Halloumi::Filters.string_to_array,
        env: :VPC_PUBLIC_SUBNETS,
        required: true
        property :web_user_data,
                 template: File.expand_path(
          "../../templates/userdata.sh.erb",
          __dir__
        )
      end
    end
  end
end
