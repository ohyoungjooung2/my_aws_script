require 'aws-sdk-ec2'
ec2=Aws::EC2::Resource.new(profile: 'mfa')
ec2.instances.each do |i|
  puts "Name: #{i.tags.select {|tag| tag.key=="Name"}[0][:value] }, #{i.private_ip_address}"
end

