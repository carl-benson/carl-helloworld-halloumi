require "spec_helper"

describe "Ec2Stack" do
  let(:compiler) { Halloumi::Compilers::CloudFormation.new Ec2Stack }
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

      context "Parameters" do
        let(:parameters) { parsed["Parameters"] }
        subject { parameters }

        it { should have_key "SkeletonInternetGatewayId" }
        it { should have_key "SkeletonRouteTableId" }
        it { should have_key "SkeletonVpcId" }
      end

      context "Resources" do
        let(:resources) { parsed["Resources"] }
        subject { resources }

        it { should have_key "HelloWorldAsgAutoScalingGroup" }
        # it { should have_key "SkeletonRouteTable" }
        # it { should have_key "SkeletonVpc" }
        # it { should have_key "SkeletonVpcGatewayAttachment" }
        # it { should have_key "SkeletonVpcGatewayAttachment" }
        # it { should_not have_key "FirewallSecurityGroup" }

        context "HelloWorldAsgAutoScalingGroup" do
          let(:hello_world_asg_autoscaling_group) do
            resources["HelloWorldAsgAutoScalingGroup"]
          end
          subject { hello_world_asg_autoscaling_group }

          it { should have_key "Type" }
          it { should have_key "Properties" }
          it { should have_key "UpdatePolicy" }

          context "Type" do
            subject { hello_world_asg_autoscaling_group["Type"] }

            it { should eq "AWS::AutoScaling::AutoScalingGroup" }
          end

          context "Properties" do
            let(:properties) { hello_world_asg_autoscaling_group["Properties"] }
            subject { properties }

            it { should have_key "AvailabilityZones" }
            it { should have_key "HealthCheckGracePeriod" }
            it { should have_key "HealthCheckType" }
            it { should have_key "LaunchConfigurationName" }
            it { should have_key "LoadBalancerNames" }
            it { should have_key "MaxSize" }
            it { should have_key "MinSize" }
            it { should have_key "Tags" }
            it { should have_key "VPCZoneIdentifier" }

            context "HealthCheckGracePeriod" do
              subject { properties["HealthCheckGracePeriod"] }

              it { should eq 300 }
            end

            context "HealthCheckType" do
              subject { properties["HealthCheckType"] }

              it { should eq "ELB" }
            end

            context "LaunchConfigurationName" do
              let(:launch_configuration_name) {
                properties["LaunchConfigurationName"] }
              subject { launch_configuration_name }

              it { should have_key "Ref" }

              context "Ref" do
                subject { launch_configuration_name["Ref"] }

                it { should eq "HelloWorldAsgLaunchConfiguration" }
              end
            end

            context "LoadBalancerNames" do
              let(:load_balancer_names) { properties["LoadBalancerNames"] }
              subject { load_balancer_names }

              it { should have_key all "Ref" }
            end

              # it { should have_key "Ref" }
              #
              # context "Ref" do
              #   subject { load_balancer_names["Ref"] }
              #
              #   it { should eq "HelloWorldAsgLoadBalancerLoadBalancer" }
              # end

            context "MaxSize" do
              subject { properties["MaxSize"] }

              it { should eq 2 }
            end

            context "MinSize" do
              subject { properties["MinSize"] }

              it { should eq 2 }
            end
          end
        end
      end
    end
  end
end
