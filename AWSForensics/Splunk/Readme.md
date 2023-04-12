# AWS Cloudtrail investigator
This Splunk App/Dashboard is built to accelerte the cloud trail compromize investigation and assist in identifying obvious anomalies from a large dataset. This dashboard sweeps through log samples to compare the known bad behovior on AWS infrastructure covering activities like Authentication, IAM, Disruption, Common anomalies etc. Complete list of checkpoints covered can be referred [here](https://github.com/zf-dfir/IR_General/blob/main/AWS/Athena/awsinvestigator.md)
# Supported AWS Cloudtrail logformat
This version of investigator supports json formated output exported from the AWS console, Splunk also allows to import multi dated zip files. backend parsing logic is built to support the below log format of cloudtrail.
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
# Pre-Requisites
1. At the time of writing the App the Splunk version was 9.0.4, similar version or the most recent version is recommended for hosting this investigator dash
2. Admin or similar role on Splunk to import and create splunk resources
3. Create a custom sourcetype as mentioned [here](https://github.com/zf-dfir/IR_General/blob/main/AWS/Splunk/cloudtrail_sourcetype.md)
4. Create a new index on splunk with the name cloudtrail
5. Dashboard xml file to add and kickstart the dashboard in splunk
