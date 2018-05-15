# frozen_string_literal: true

module Concerns #:nodoc:
  # AutoScaling for Hello World
  module AutoScaling
    extend ActiveSupport::Concern
    included do
      # @!group Properties

      # @!attribute [rw] ec2_image_id
      #   Property image_id for asg
      #   @return [Object] ec2_image_id for asg
      property :ec2_image_id,
               default: "ami-xxxxxxxx",
               env: :UBUNTU_IMAGE_ID,
               required: true

      # @!attribute [rw] ec2_key_name
      #   Property ec2_key_name for asg.
      #   @return [String] ec2_key_name for asg
      property :ec2_key_name,
               env: :SSH_KEY_NAME,
               required: true

      # @!attribute [rw] ec2_min_size
      #   Property ec2_min_size for asg.
      #   @return [String] ec2_min_size for asg
      property :ec2_min_size,
               default: 2

      # @!attribute [rw] user_data
      #   Property template for asg.
      #   @return [Object] template for asg
      property :ec2_user_data,
               template: File.expand_path(
                 "../../../../templates/ec2/user_data.erb",
                 __FILE__
               )

      # @!group Resources
      resource :hello_world_asgs,
               type: Halloumi::AutoScaling do |r|
        r.resource(:skeletons) { skeletons }
        r.property(:service_ip_offset) { 0 }
        r.property(:image_id) { ec2_image_id }
        r.property(:key_name) { ec2_key_name }
        r.property(:min_size) { ec2_min_size }
        r.property(:user_data) { ec2_user_data }
        r.property(:managers) { management_subnets }
        r.property(:consumers) { consumer_subnets }
      end
    end
  end
end
