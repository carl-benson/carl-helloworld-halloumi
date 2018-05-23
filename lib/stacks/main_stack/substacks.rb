module Concerns
  # Stacks for {HelloWorld}
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
        resource :ec2_stacks,
                 type: Halloumi::AWS::CloudFormation::Stack do |r|
          r.property(:template_url) do
            "#{ENV["STACK_NAME"]}-ec2-stack.json"
          end
          r.property(:parameters) do
            {
              SkeletonInternetGatewayId:
                skeleton_stack.ref_output_SkeletonInternetGatewayId,
              SkeletonRouteTableId:
                skeleton_stack.ref_output_SkeletonRouteTableId,
              SkeletonVpcId: skeleton_stack.ref_output_SkeletonVpcId
            }
          end
        end
      end
    end
  end
end
