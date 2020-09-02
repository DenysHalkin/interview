# -------------------------------------------------
# ------------------INTERVIEW----------------------
#
# -------------------------------------------------

import boto3
import argparse
from tabulate import tabulate

parser = argparse.ArgumentParser()
parser.add_argument("-profile", required=True, help="AWS profile", action="store", dest="profile")
parser.add_argument("-region", required=True, help="AWS region", action="store", dest="region")
parser.add_argument("-ec2name", help="EC2 Instance Name", action="store", dest="instance_name", default='*')
args = parser.parse_args()

if args.instance_name == '*':
    print("Instance name is not defined, getting all instances in region...")


def get_instance(profile, region, instance_name):
    session = boto3.Session(profile_name=profile, region_name=region)
    ec2 = session.client('ec2')

    founded_instances = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': [instance_name + '*']
            },
        ],
    )

    instances_properties = []
    for instance in founded_instances['Reservations']:
        data = [
            instance['Instances'][0]['InstanceId'],
            instance['Instances'][0]['InstanceType'],
            instance['Instances'][0]['PrivateIpAddress'],
            instance['Instances'][0]['State']['Name']
        ]

        try:
            public_ip = instance['Instances'][0]['PublicIpAddress']
        except KeyError:
            public_ip = 'N/A'

        data.insert(2, public_ip)

        instances_properties.append(data)

    headers = ['InstanceId', 'InstanceType', 'PublicIpAddress', 'PrivateIpAddress', 'State']
    print("\n-----------------------------------------------------------------------------------")
    print(tabulate(instances_properties, headers))


get_instance(args.profile, args.region, args.instance_name)
