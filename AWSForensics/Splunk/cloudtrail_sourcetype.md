# AWS Cloudtrail 
The exported cloudtrail json files from AWS contain a single json payload that contains individual cloudtrail events. However splunk out of the box does not recognising the individual events and split them to reveal individual log entries. its just one big lump as a single event
# AWS log format
```
"Records": [
    {
      "apiVersion": "2012-06-01",
      "awsRegion": "us-west-1",
      "eventID": "c-c245-2c4-32v6-vfff",
      "eventName": "DescribeLoadBalancers",
      "eventSource": "elasticloadbalancing.amazonaws.com",
      "eventTime": "2019-11-30T18:15:33Z",
      "eventType": "AwsApiCall",
      "eventVersion": "1.05",
      "recipientAccountId": "redacted",
      "requestID": "2xc454xc-2345-234cv5-2345",
      "requestParameters": null,
      "responseElements": null,
      "sourceIPAddress": "1.1.1.1",
      "userAgent": "aws-sdk-ruby3/3.75.0 jruby/2.3.3 java aws-sdk-elasticloadbalancing/1.19.0 cloudhealth",
      "userIdentity": {
        "accessKeyId": "redacted",
        "accountId": "redacted",
        "arn": "arn:aws:sts::redacted:assumed-role/team/AssumeRoleSession",
        "principalId": "redacted:AssumeRoleSession",
        "sessionContext": {
          "attributes": {
            "creationDate": "2019-11-30T17:45:06Z",
            "mfaAuthenticated": "false"
          },
          "sessionIssuer": {
            "accountId": "redacted",
            "arn": "arn:aws:iam::redacted:team/company",
            "principalId": "redacted",
            "type": "Role",
            "userName": "redacted"
          },
          "webIdFederationData": {}
        },
        "type": "AssumedRole"
      }
    },{
      "apiVersion": "2012-06-01",
      "awsRegion": "us-west-1",
      "eventID": "c-c245-2c4-32v6-vfff",
      "eventName": "DescribeLoadBalancers",
      "eventSource": "elasticloadbalancing.amazonaws.com",
      "eventTime": "2019-11-30T18:16:33Z",
      "eventType": "AwsApiCall",
      "eventVersion": "1.05",
      "recipientAccountId": "redacted",
      "requestID": "2xc454xc-2345-234cv5-2345",
      "requestParameters": null,
      "responseElements": null,
      "sourceIPAddress": "1.1.1.1",
      "userAgent": "aws-sdk-ruby3/3.75.0 jruby/2.3.3 java aws-sdk-elasticloadbalancing/1.19.0 cloudhealth",
      "userIdentity": {
        "accessKeyId": "redacted",
        "accountId": "redacted",
        "arn": "arn:aws:sts::redacted:assumed-role/team/AssumeRoleSession",
        "principalId": "redacted:AssumeRoleSession",
        "sessionContext": {
          "attributes": {
            "creationDate": "2019-11-30T17:45:06Z",
            "mfaAuthenticated": "false"
          },
          "sessionIssuer": {
            "accountId": "redacted",
            "arn": "arn:aws:iam::redacted:role/team",
            "principalId": "redacted",
            "type": "Role",
            "userName": "redacted"
          },
          "webIdFederationData": {}
        },
        "type": "AssumedRole"
      }
    }
  ]
}
```

# Custom sourcetype

Splunk Allows us to define props in the sourcetype to effectively breakup the large blob of nested json from cloudtrail output into smaller individual logs that can be further used to build visualizations.
## Custom props for cloudtrail

from the splunk sourcetype cration wizard pick the existing json props to edit with below values and save with new name to apply sourcetype for parsing cloudtrail logs
```
[cloudtrail]
KV_MODE = json
SHOULD_LINEMERGE=false
LINE_BREAKER=((?<=}),(?={)|[\r\n]+)
SEDCMD-remove_prefix=s/{"Records":\[//g
SEDCMD-remove_suffix=s/\]}//g
```

# Conclusion
The line break logic used in custom props configuration may require update in case the actual log format is updated by Amazon, review the formats in regular time intervals to make changes to the props configuration to support the newer log formats.

here is a detailed KB article on [how to create Sourcetypes](https://docs.splunk.com/Documentation/Splunk/latest/Data/Createsourcetypes)
