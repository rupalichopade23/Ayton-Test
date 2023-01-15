with_rds_cloning = 1
if with_rds_cloning == 1
  PARAM=(aws ssm get-parameter --name "parameter_name" --region 'eu-central-1' 
    | jq -r ".Parameter.Name");
    [[ ! -z "$PARAM" ]] && aws ssm delete-parameter --name "parameter_name" --region eu-central-1 && /home/ec2-user/scripts/hello.sh

    
end