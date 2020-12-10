#!/usr/bin/python

# issues with external data source:
## https://github.com/hashicorp/terraform/issues/12249
## https://github.com/hashicorp/terraform-provider-external/issues/2

import os
import json

stream = os.popen('aws --output json ec2 describe-subnets')
subnet_info_json = stream.read()

subnet_info_obj = json.loads(subnet_info_json)

not_last_item = len(subnet_info_obj['Subnets'])
# output_json = '{"subnets": ['
output_json = '{'
for subnet in subnet_info_obj['Subnets']:
  # output_json = output_json + '{"id":"'+subnet['SubnetId']+'","cidr":"'+subnet['CidrBlock']+'","az":"'+subnet['AvailabilityZone']+'"}'
  # output_json = output_json + '"'+subnet['SubnetId']+'","'+subnet['CidrBlock']+'","'+subnet['AvailabilityZone']+'"'
  p=str(not_last_item)
  output_json = output_json + '"id'+p+'":"'+subnet['SubnetId']+'","cidr'+p+'":"'+subnet['CidrBlock']+'","az'+p+'":"'+subnet['AvailabilityZone']+'"'
  not_last_item = not_last_item -1
  if (not_last_item):
    output_json = output_json + ','

output_json = output_json + '}'
# output_json = output_json + ']}'

print(output_json)

# command "python" produced invalid JSON: json: cannot unmarshal array into Go value of type string

# print(subnet_info_obj['Subnets'][0]['SubnetId'],subnet_info_obj['Subnets'][0]['AvailabilityZone'],subnet_info_obj['Subnets'][0]['CidrBlock'])


# {
#     "Subnets": [
#         {
#             "AvailabilityZone": "us-east-2a",
#             "AvailabilityZoneId": "use2-az1",
#             "AvailableIpAddressCount": 251,
#             "CidrBlock": "172.17.0.0/24",
#             "DefaultForAz": false,
#             "MapPublicIpOnLaunch": false,
#             "MapCustomerOwnedIpOnLaunch": false,
#             "State": "available",
#             "SubnetId": "subnet-05abb3711936c460f",
#             "VpcId": "vpc-254a934e",
#             "OwnerId": "997154480092",
#             "AssignIpv6AddressOnCreation": false,
#             "Ipv6CidrBlockAssociationSet": [],
#             "Tags": [
#                 {
#                     "Key": "TypeZone",
#                     "Value": "public-us-east-2a"
#                 },
#                 {
#                     "Key": "Name",
#                     "Value": "17-1-a"
#                 }
#             ],
#             "SubnetArn": "arn:aws:ec2:us-east-2:997154480092:subnet/subnet-05abb3711936c460f"
#         },
#         {
#             "AvailabilityZone": "us-east-2c",
#             "AvailabilityZoneId": "use2-az3",
#             "AvailableIpAddressCount": 4090,
#             "CidrBlock": "172.31.32.0/20",
#             "DefaultForAz": true,
#             "MapPublicIpOnLaunch": true,
#             "MapCustomerOwnedIpOnLaunch": false,
#             "State": "available",
#             "SubnetId": "subnet-b187e1fd",
#             "VpcId": "vpc-254a934e",
#             "OwnerId": "997154480092",
#             "AssignIpv6AddressOnCreation": false,
#             "Ipv6CidrBlockAssociationSet": [],
#             "Tags": [
#                 {
#                     "Key": "TypeZone",
#                     "Value": "private-us-east-2c"
#                 },
#                 {
#                     "Key": "Name",
#                     "Value": "31-c"
#                 }
#             ],
#             "SubnetArn": "arn:aws:ec2:us-east-2:997154480092:subnet/subnet-b187e1fd"
#         },
#         {
#             "AvailabilityZone": "us-east-2c",
#             "AvailabilityZoneId": "use2-az3",
#             "AvailableIpAddressCount": 251,
#             "CidrBlock": "172.17.2.0/24",
#             "DefaultForAz": false,
#             "MapPublicIpOnLaunch": false,
#             "MapCustomerOwnedIpOnLaunch": false,
#             "State": "available",
#             "SubnetId": "subnet-0d33a7e00c82e165f",
#             "VpcId": "vpc-254a934e",
#             "OwnerId": "997154480092",
#             "AssignIpv6AddressOnCreation": false,
#             "Ipv6CidrBlockAssociationSet": [],
#             "Tags": [
#                 {
#                     "Key": "TypeZone",
#                     "Value": "public-us-east-2c"
#                 },
#                 {
#                     "Key": "Name",
#                     "Value": "17-1-c"
#                 }
#             ],
#             "SubnetArn": "arn:aws:ec2:us-east-2:997154480092:subnet/subnet-0d33a7e00c82e165f"
#         },
#         {
#             "AvailabilityZone": "us-east-2b",
#             "AvailabilityZoneId": "use2-az2",
#             "AvailableIpAddressCount": 251,
#             "CidrBlock": "172.17.1.0/24",
#             "DefaultForAz": false,
#             "MapPublicIpOnLaunch": false,
#             "MapCustomerOwnedIpOnLaunch": false,
#             "State": "available",
#             "SubnetId": "subnet-0b2ce026687cf913c",
#             "VpcId": "vpc-254a934e",
#             "OwnerId": "997154480092",
#             "AssignIpv6AddressOnCreation": false,
#             "Ipv6CidrBlockAssociationSet": [],
#             "Tags": [
#                 {
#                     "Key": "TypeZone",
#                     "Value": "public-us-east-2b"
#                 },
#                 {
#                     "Key": "Name",
#                     "Value": "17-1-b"
#                 }
#             ],
#             "SubnetArn": "arn:aws:ec2:us-east-2:997154480092:subnet/subnet-0b2ce026687cf913c"
#         },
#         {
#             "AvailabilityZone": "us-east-2a",
#             "AvailabilityZoneId": "use2-az1",
#             "AvailableIpAddressCount": 4090,
#             "CidrBlock": "172.31.0.0/20",
#             "DefaultForAz": true,
#             "MapPublicIpOnLaunch": true,
#             "MapCustomerOwnedIpOnLaunch": false,
#             "State": "available",
#             "SubnetId": "subnet-998d4df2",
#             "VpcId": "vpc-254a934e",
#             "OwnerId": "997154480092",
#             "AssignIpv6AddressOnCreation": false,
#             "Ipv6CidrBlockAssociationSet": [],
#             "Tags": [
#                 {
#                     "Key": "Name",
#                     "Value": "31-a"
#                 },
#                 {
#                     "Key": "TypeZone",
#                     "Value": "private-us-east-2a"
#                 }
#             ],
#             "SubnetArn": "arn:aws:ec2:us-east-2:997154480092:subnet/subnet-998d4df2"
#         },
#         {
#             "AvailabilityZone": "us-east-2b",
#             "AvailabilityZoneId": "use2-az2",
#             "AvailableIpAddressCount": 4091,
#             "CidrBlock": "172.31.16.0/20",
#             "DefaultForAz": true,
#             "MapPublicIpOnLaunch": true,
#             "MapCustomerOwnedIpOnLaunch": false,
#             "State": "available",
#             "SubnetId": "subnet-9d447ae7",
#             "VpcId": "vpc-254a934e",
#             "OwnerId": "997154480092",
#             "AssignIpv6AddressOnCreation": false,
#             "Ipv6CidrBlockAssociationSet": [],
#             "Tags": [
#                 {
#                     "Key": "TypeZone",
#                     "Value": "private-us-east-2b"
#                 },
#                 {
#                     "Key": "Name",
#                     "Value": "31-b"
#                 }
#             ],
#             "SubnetArn": "arn:aws:ec2:us-east-2:997154480092:subnet/subnet-9d447ae7"
#         }
#     ]
# }