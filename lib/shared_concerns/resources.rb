# frozen_string_literal: true

module Concerns
  # Shared Resources for {Test}.
  module Shared
    module Resources
      extend ActiveSupport::Concern
      included do
        resource :vpcs, type: Halloumi::VirtualResource do |r|
          r.parameter { "SkeletonVpcId" }
          r.property(:cidr_block) { vpc_cidr_block }
        end

        resource :internet_gateways, type: Halloumi::VirtualResource do |r|
          r.parameter { "SkeletonInternetGatewayId" }
        end

        resource :route_tables, type: Halloumi::VirtualResource do |r|
          r.parameter { "SkeletonRouteTableId" }
        end

        resource :skeletons, type: Halloumi::Skeleton do |r|
          r.resource(:vpcs) { vpcs }
          r.resource(:route_tables) { route_tables }
          r.resource(:routes) { [] } # prevent the default route to be recreated
          r.resource(:vpc_gateway_attachments) { [] } # prevent overattachment
          r.resource(:internet_gateways) { internet_gateways }
          r.property(:vpc_cidr_block) { vpc_cidr_block }
        end
      end
    end
  end
end
