require "spec_helper"

describe Test do
  let(:compiler) { Halloumi::Compilers::CloudFormation.new Test }
  subject { compiler }

  it { should be_a_kind_of Halloumi::Compilers::CloudFormation }

  context "#to_json" do
    let(:parsed) { JSON.parse(compiler.to_json) }

    context "includes" do
      context "AWSTemplateFormatVersion" do
        subject { parsed["AWSTemplateFormatVersion"] }

        it { should eq "2010-09-09" }
      end
      context "Resources" do
        let(:resources) { parsed["Resources"] }
        subject { resources }

        context "SkeletonStack" do
          let(:stack) { resources["SkeletonStack"] }
          subject { stack }

          it { should have_key "Properties" }

          context "Properties" do
            let(:properties) { stack["Properties"] }
            subject { properties }

            it { should_not have_key "Parameters" }
            it { should have_key "TemplateURL" }
          end

          context "Type" do
            let(:type) { stack["Type"] }
            subject { type }

            it { should eq "AWS::CloudFormation::Stack" }
          end
        end
      end
    end
  end
end
