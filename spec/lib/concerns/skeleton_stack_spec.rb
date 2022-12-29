require "spec_helper"

describe "SkeletonStack" do
  let(:compiler) { Halloumi::Compilers::CloudFormation.new SkeletonStack }
  subject { compiler }

  it { should be_a_kind_of Halloumi::Compilers::CloudFormation }

  context "#to_json" do
    let(:parsed) { JSON.parse(compiler.to_json) }

    context "includes" do
      context "AWSTemplateFormatVersion" do
        subject { parsed["AWSTemplateFormatVersion"] }

        it { should eq "2010-09-09" }
      end

      context "Outputs" do
        let(:outputs) { parsed["Outputs"] }
        subject { outputs }

        it { should have_key "SkeletonInternetGatewayId" }
        it { should have_key "SkeletonRouteTableId" }
        it { should have_key "SkeletonVpcId" }
      end

      context "Resources" do
        let(:resources) { parsed["Resources"] }
        subject { resources }

        it { should have_key "SkeletonInternetGateway" }
        it { should have_key "SkeletonRouteTable" }
        it { should have_key "SkeletonVpc" }
        it { should have_key "SkeletonVpcGatewayAttachment" }
        it { should have_key "SkeletonVpcGatewayAttachment" }
        it { should_not have_key "FirewallSecurityGroup" }

        context "SkeletonInternetGateway" do
          let(:skeleton_internet_gateway) do
            resources["SkeletonInternetGateway"]
          end
          subject { skeleton_internet_gateway }

          it { should have_key "Type" }
          it { should_not have_key "Properties" }

          context "Type" do
            subject { skeleton_internet_gateway["Type"] }

            it { should eq "AWS::EC2::InternetGateway" }
          end
        end

        context "SkeletonRoute" do
          let(:skeleton_route) { resources["SkeletonRoute"] }
          subject { skeleton_route }

          it { should have_key "Type" }
          it { should have_key "Properties" }

          context "Type" do
            subject { skeleton_route["Type"] }

            it { should eq "AWS::EC2::Route" }
          end

          context "Properties" do
            let(:properties) { skeleton_route["Properties"] }
            subject { properties }

            it { should have_key "DestinationCidrBlock" }
            it { should have_key "GatewayId" }
            it { should have_key "RouteTableId" }
          end
        end

        context "SkeletonVpc" do
          let(:skeleton_vpc) { resources["SkeletonVpc"] }
          subject { skeleton_vpc }

          it { should have_key "Type" }
          it { should have_key "Properties" }

          context "Type" do
            subject { skeleton_vpc["Type"] }

            it { should eq "AWS::EC2::VPC" }
          end

          context "Properties" do
            let(:properties) { skeleton_vpc["Properties"] }
            subject { properties }

            it { should have_key "CidrBlock" }
          end
        end

        context "SkeletonVpcGatewayAttachment" do
          let(:skeleton_vpc_gateway_attachment) do
            resources["SkeletonVpcGatewayAttachment"]
          end
          subject { skeleton_vpc_gateway_attachment }

          it { should have_key "Type" }
          it { should have_key "Properties" }

          context "Type" do
            subject { skeleton_vpc_gateway_attachment["Type"] }

            it { should eq "AWS::EC2::VPCGatewayAttachment" }
          end

          context "Properties" do
            let(:properties) { skeleton_vpc_gateway_attachment["Properties"] }
            subject { properties }

            it { should have_key "InternetGatewayId" }
            it { should have_key "VpcId" }
          end
        end
      end
    end
  end
end
