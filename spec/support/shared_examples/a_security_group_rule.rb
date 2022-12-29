shared_examples "a security group rule" do |index, proto, from, to, src|
  its(["Properties", "SecurityGroupIngress", index]) do
    should include "IpProtocol" => proto
  end

  its(["Properties", "SecurityGroupIngress", index]) do
    should include "FromPort" => from
  end

  its(["Properties", "SecurityGroupIngress", index]) do
    should include "ToPort" => to
  end

  its(["Properties", "SecurityGroupIngress", index]) do
    should include "SourceSecurityGroupId" => \
      { "Fn::GetAtt" => [src, "GroupId"] }
  end
end
