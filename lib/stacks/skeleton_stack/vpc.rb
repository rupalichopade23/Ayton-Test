require "halloumi/flowlog"

module Concerns
  # VPC Resources for {Test}
  module Skeleton
    module VPC
      extend ActiveSupport::Concern
      included do
        resource :skeletons, type: Halloumi::Skeleton do |r|
          r.property(:vpc_cidr_block) { vpc_cidr_block }
          r.property(:enable_dns_support) { true }
          r.property(:enable_dns_hostnames) { true }
        end

        resource :vpc_flow_logs,
                 type: Halloumi::FlowLog do |r|
          r.property(:retention_days) { 30 }
          r.property(:resource_type) { "VPC" }
          r.property(:traffic_type) { "ALL" }
          r.property(:resource_id) { skeleton.vpc.ref }
        end
        ## subnets for webserver
        
      end
    end
  end
end
