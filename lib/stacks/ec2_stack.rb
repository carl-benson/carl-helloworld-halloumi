# frozen_string_literal: true

# Main Halloumi::CompoundResource for project "HelloWorld".
class Ec2Stack < Halloumi::CompoundResource
  # Shared concerns
  include Concerns::Shared::Methods
  include Concerns::Shared::Properties
  include Concerns::Shared::Resources

  # Stack concerns
  include Concerns::AutoScaling
end
