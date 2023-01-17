module Concerns
    # VPC Resources for {FirstProject}
  module EC2
    module WebServer
      extend ActiveSupport::Concern
      included do
        property :keypairname,
                  env: :WEB_KEYPAIR_NAME
        property :image_id,
                  env: :BASTION_AMI,
                  required: true
        property :setup_HelloWorld,
                  template: File.expand_path(
                    "../../../../config/" \
            "hello.sh.erb",
          __FILE__
            )
        property :setup_SQL,
                  template: File.expand_path(
                   "../../../../config/" \
            "hello.sql",
          __FILE__
            )
        def with_rds_cloning
          0
        end
        
        def count_script_yn
          params = {}
          unless with_rds_cloning.zero?
            params = {
              '/opt/count/hello.sh' => {
                mode: '000755',
                owner: :root,
                group: :root,
                content: setup_HelloWorld
              },
              '/opt/count/hello.sql' => {
                mode: '000755',
                owner: :root,
                group: :root,
                content: "setup_SQL"
              }
            }
          end
          params # return
        end
        def count_script_exe_yn
          param = {}
          unless with_rds_cloning.zero?
            param = { run_count_script:
            "PARAM=$(aws ssm get-parameter --name /#{stack_name}/#{parameter_name} --region eu-central-1" \
                    '| jq -r ".Parameter.Name");' \
                    "[[ #{with_rds_cloning} -eq 1 ]] && [[ ! -z  \"$PARAM\" ]] && aws ssm delete-parameter --name /#{stack_name}/#{parameter_name} --region eu-central-1 && /opt/count/hello.sh"
                }
          end
          param # return
        end

        resource :web_security_groups,
                  type: Halloumi::AWS::EC2::SecurityGroup do |r|
          r.property(:group_description) { "Web SG" }
          r.property(:group_name) { "Web" }
          r.property(:vpc_id) { vpc.ref }
        end
        resource :web_sg_http_inbounds,
                  type: Halloumi::AWS::EC2::SecurityGroupIngress do |r|
          r.property(:cidr_ip) { "0.0.0.0/0" }
          r.property(:ip_protocol) { "tcp" }
          r.property(:from_port) { 80 }
          r.property(:to_port) { 80 }
          r.property(:group_id) { web_security_group.ref }
        end
        resource :web_sg_ssh_inbounds,
                  type: Halloumi::AWS::EC2::SecurityGroupIngress do |r|
          r.property(:cidr_ip) { "0.0.0.0/0" }
          r.property(:ip_protocol) { "tcp" }
          r.property(:from_port) { 22 }
          r.property(:to_port) { 22 }
          r.property(:group_id) { web_security_group.ref }
        end
        resource :web_subnets,
                  type: Halloumi::AWS::EC2::Subnet do |r|
          r.property(:vpc_id) { vpc.ref }
          r.property(:cidr_block) { "10.0.0.16/28" }
          r.property(:map_public_ip_on_launch) { true }
        end
        resource :pr_route_table_associations,
                  type: Halloumi::AWS::EC2::SubnetRouteTableAssociation do |r|
          r.property(:route_table_id) { route_table.ref }
          r.property(:subnet_id) { web_subnet.ref }
        end
        resource :web_key_pairs,
                  type: Halloumi::AWS::EC2::KeyPair do |r|
          r.property(:key_name) { keypairname }
        end
        resource :setup_skeletons,
              type: Halloumi::Skeleton,
              amount: -> { 1 } do |r|
          r.resource(:vpcs) { skeleton.vpcs }
          r.resource(:internet_gateways) { skeleton.internet_gateways }
          r.resource(:vpc_gateway_attachments) do
            skeleton.vpc_gateway_attachments
          end
        end
        def setup_instance_policy
          [
            {
              Action: [

                "ssm:GetParameter",
                "ssm:DeleteParameter"

              ],

              Effect: :Allow,
              Resource: "*"
            }
          ]
        end
        # resource :web_servers,
        #           type: Halloumi::AWS::EC2::Instance do |r|
        #   r.property(:image_id) { image_id }
        #   r.property(:instance_type) { "t2.micro" }
        #   r.property(:security_group_ids) do
        #     [
        #         web_security_group.ref 
        #     ]
        #   end
        #   r.property(:subnet_id) { web_subnet.ref }
        #   r.property(:key_name) { web_key_pair.ref }
        #   r.property(:user_data) do
        #     { 'Fn::Base64': web_user_data

        #     }
        #   end
        # end

        resource :tenant_setups,
                  type: Halloumi::AutoScaling do |r|
          r.metadata('AWS::CloudFormation::Init') do
            {
              config: {
                commands: {
                  # run_count_script: {
                    
                    # command: "PARAM=$(aws ssm get-parameter --name /#{stack_name}/#{parameter_name} --region eu-central-1" \
                    # '| jq -r ".Parameter.Name");' \
                    # "[[ #{with_rds_cloning} -eq 1 ]] && [[ ! -z  \"$PARAM\" ]] && aws ssm delete-parameter --name /#{stack_name}/#{parameter_name} --region eu-central-1 && /opt/count/hello.sh"
                  #}
                }.merge(count_script_exe_yn),
                files: {}.merge(count_script_yn)
                    # "[[ #{with_rds_cloning} -eq 1 ]] && '/opt/count/hello.sh'" => {
                    #   mode: '000755',
                    #   owner: :root,
                    #   group: :root,
                    #   content: setup_HelloWorld
                    # }
              }
            }
          end
          r.property(:no_load_balancer) { true }
          r.property(:image_id) { image_id }
          r.property(:instance_type) { "t2.micro" }
          r.property(:key_name) { web_key_pair.ref }
          r.property(:max_size) { 2 }
          r.property(:min_size) { 1 }
         #  r.property(:ebs_size) { 8 }
          r.resource(:skeletons) { setup_skeletons }
          r.property(:service_ip_offset) { 2 }
          r.property(:instance_policies) { setup_instance_policy }
          r.property(:user_data) do
            { 'Fn::Base64': web_user_data
              }
          end
          r.property(:subnet_amount) { 2 }
        end

      end
    end
  end
end