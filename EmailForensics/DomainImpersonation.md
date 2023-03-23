# The Evolution of Domain Impersonation attacks: Strategies for Detection and Prevention

Domain impersonation is a common technique used by cybercriminals to trick users into disclosing sensitive information or performing actions that can compromise their security. There are several detection techniques that can help organizations identify and prevent domain impersonation attacks. Here are some of them:

![](https://miro.medium.com/v2/resize:fit:1204/1*laGO2iGG2vzFZCpSfj8oAg.png)

image credits: to the original creator

1.  Email authentication: Email authentication protocols such as SPF, DKIM, and DMARC can help detect and prevent domain impersonation attacks. These protocols verify the authenticity of the sender’s domain by checking the email headers for the presence of specific DNS records. Organizations can configure their email servers to enforce these protocols and reject any emails that fail authentication.
2.  URL filtering: URL filtering tools can scan incoming emails and block any links that lead to suspicious or malicious domains. These tools can also detect and block phishing emails that contain links to fake login pages or websites designed to steal user credentials.
3.  Machine learning algorithms: Machine learning algorithms can analyze large volumes of email data to identify patterns and anomalies that indicate domain impersonation attacks. These algorithms can learn to recognize the characteristics of legitimate emails and flag any messages that deviate from these patterns.
4.  Domain reputation services: Domain reputation services can help organizations identify and block emails from domains that have a history of sending spam or phishing emails. These services maintain a database of known malicious domains and can alert
5.  Analysis of sender behavior: Organizations can analyze the behavior of senders to identify any anomalies that may indicate a domain impersonation attack. For example, they can track the number of emails sent by a particular sender, the time of day they are sent, and the content of the messages. If the sender’s behavior deviates from their usual pattern, it could indicate a compromised account or a spoofed email address.
6.  Sender policy framework (SPF) record analysis: SPF is a protocol used to prevent email spoofing. SPF records are published in DNS and define which IP addresses are authorized to send emails on behalf of a particular domain. Organizations can analyze the SPF records of incoming emails to determine whether they are legitimate. If an email comes from an IP address that is not listed in the SPF record, it is likely to be a domain impersonation attack.
7.  Domain-based message authentication, reporting, and conformance (DMARC) analysis: DMARC is a protocol that builds on SPF and domain keys identified mail (DKIM) to provide a more robust email authentication mechanism. DMARC allows domain owners to specify what actions should be taken if an email fails authentication, such as blocking or quarantining the email. Organizations can analyze DMARC reports to identify any unauthorized email senders and take appropriate action.
8.  Threat intelligence feeds: Organizations can subscribe to threat intelligence feeds that provide real-time information on known phishing campaigns and malicious domains. These feeds can help organizations stay up-to-date on the latest threats and take proactive measures to prevent attacks.

Here are a few examples of how domain impersonation attacks can be detected:

1.  **How DMARC can help detect domain impersonation:**

Let’s say your organization’s domain is example.com, and your company has published a DMARC record with a policy of “quarantine”. This means that any incoming email that fails DMARC authentication will be marked as spam and quarantined before it reaches the recipient’s inbox.

Now, an attacker wants to impersonate your domain and sends an email to one of your customers from a fake email address like  [info@example.com](mailto:info@example.com). The attacker has also spoofed the “From” header in the email to make it look like it came from your organization’s domain.

However, because your organization has a published DMARC record, the recipient’s email server will first check the email’s SPF and DKIM records to see if it passes DMARC authentication. If the email fails DMARC authentication, the recipient’s email server will follow the DMARC policy set by your organization’s DMARC record and quarantine the email.

In this case, because the attacker is using a fake email address and their email fails DMARC authentication, the recipient’s email server will quarantine the email and prevent it from reaching the recipient’s inbox. This helps protect your organization’s reputation and prevents the attacker from successfully impersonating your domain.

By monitoring DMARC reports, your organization can also gain insights into the types of domain impersonation attacks being attempted against your domain and take appropriate action to further improve your email security posture.

_Here is an example of detection model written in Splunk to detect impersonation using DMARC_

> index=mail sourcetype=”maillog”  
> | rex “(?<ip_address>\d+\.\d+\.\d+\.\d+).*?from=<(?<from_email>[^>]+)>”  
> | rex field=from_email “(?<from_domain>\w+\.\w+)$”  
> | rex field=from_domain “(?<from_tld>\w+)$”  
> | rex field=message_body “(?<dmarc_domain>^dmarc=.+?;\s*domain=)(?<dmarc_domain_val>\S+)”  
> | lookup dmarc_lookup domain as dmarc_domain_val output result  
> | eval dmarc_match=if(result=”Pass”,”Matched”,”Unmatched”)  
> | table _time, ip_address, from_domain, from_tld, dmarc_domain_val, dmarc_match

This SPL code searches for emails in the “mail” index with a “maillog” sourcetype. It uses regular expressions to extract the IP address, sender email address, sender domain, and sender top-level domain (TLD) from the email header, as well as the domain name in the DMARC header from the message body.

The code then uses the “lookup” command to query a DMARC lookup table that contains information about authorized senders for each domain. It uses the “eval” command to create a field that indicates whether the DMARC check passed or failed.

Finally, the “table” command is used to display the results in a tabular format, including the timestamp, IP address, sender domain and TLD, DMARC domain, and the results of the DMARC check.

**2. How Sender Policy Framework (SPF) record analysis can help detect domain impersonation**

Let’s say your organization’s domain is example.com, and you have published an SPF record that lists all the IP addresses authorized to send emails on behalf of your domain.

Now, an attacker wants to impersonate your domain and sends an email to one of your customers from a fake email address like  [info@example.com](mailto:info@example.com). The attacker has also spoofed the “From” header in the email to make it look like it came from your organization’s domain.

However, when the email reaches the recipient’s email server, the server will check the SPF record of the domain in the “From” address (in this case, example.com). If the email comes from an IP address that is not authorized in the SPF record, it will be marked as a failed SPF check.

In this case, because the attacker is using an IP address that is not authorized in your organization’s SPF record, the recipient’s email server will mark the email as a failed SPF check. Depending on the email server’s configuration, it may be marked as spam or quarantined, preventing it from reaching the recipient’s inbox.

By monitoring SPF failures, your organization can gain insights into the types of domain impersonation attacks being attempted against your domain and take appropriate action to further improve your email security posture. For example, you could investigate why an unauthorized IP address is attempting to send emails on behalf of your domain and take steps to block or blacklist the IP address.

_Here is an example of detection model written in Splunk to detect impersonation using SPF data_

> index=mail sourcetype=”maillog”  
> | rex “(?<ip_address>\d+\.\d+\.\d+\.\d+).*?from=<(?<from_email>[^>]+)>”  
> | rex field=from_email “(?<from_domain>\w+\.\w+)$”  
> | rex field=from_domain “(?<from_tld>\w+)$”  
> | rex field=message_body “\s((envelope-from\s\<(?<envelope_from>[^\>]+)\>)|(Return-Path:\s\<(?<return_path>[^\>]+)\>))”  
> | rex field=envelope_from “(?<envelope_domain>\w+\.\w+)$”  
> | rex field=envelope_domain “(?<envelope_tld>\w+)$”  
> | eval domain_match=if(from_domain=envelope_domain,”Matched”,”Unmatched”)  
> | lookup spf_lookup from_domain as domain output result  
> | eval spf_match=if(result=”Pass”,”Matched”,”Unmatched”)  
> | table _time, ip_address, from_domain, from_tld, envelope_domain, envelope_tld, domain_match, spf_match

This Splunk SPL code searches for emails in the “mail” index with a “maillog” sourcetype. It uses regular expressions to extract the IP address, sender email address, sender domain, and sender top-level domain (TLD) from the email header, as well as the envelope-from domain and envelope-from TLD from the message body.

The code then uses the “lookup” command to query an SPF lookup table that contains information about authorized IP addresses for each domain. It uses the “eval” command to create a field that indicates whether the sender domain and envelope-from domain match, and another field that indicates whether the SPF check passed or failed.

Finally, the “table” command is used to display the results in a tabular format, including the timestamp, IP address, sender domain and TLD, envelope-from domain and TLD, and the results of the domain matching and SPF check.

By analyzing this data, security analysts can quickly identify potential domain impersonation attacks and take appropriate action to prevent them.

**3. how DomainKeys Identified Mail (DKIM) can help detect domain impersonation:**

Let’s say your organization’s domain is example.com, and you have published a DKIM record that includes a private key used to sign outgoing emails. When an email is sent from your domain, the email server signs the message with the private key, and the recipient’s email server can verify the signature using the public key published in your DKIM record.

Now, an attacker wants to impersonate your domain and sends an email to one of your customers from a fake email address like  [info@example.com](mailto:info@example.com). The attacker has also spoofed the “From” header in the email to make it look like it came from your organization’s domain.

However, when the email reaches the recipient’s email server, the server will retrieve the DKIM signature from the email header and check it against the public key published in your organization’s DKIM record. If the signature is invalid or missing, the email server will mark the email as a failed DKIM check.

In this case, because the attacker is using a fake email address and their email is not signed with your organization’s private key, the recipient’s email server will mark the email as a failed DKIM check. Depending on the email server’s configuration, it may be marked as spam or quarantined, preventing it from reaching the recipient’s inbox.

By monitoring DKIM failures, your organization can gain insights into the types of domain impersonation attacks being attempted against your domain and take appropriate action to further improve your email security posture. For example, you could investigate why an email is not being signed with your organization’s private key and take steps to remediate the issue.

_Here is an example of detection model written in Splunk to detect impersonation using DKIM_

> index=mail sourcetype=”maillog”  
> | rex “(?<ip_address>\d+\.\d+\.\d+\.\d+).*?from=<(?<from_email>[^>]+)>”  
> | rex field=from_email “(?<from_domain>\w+\.\w+)$”  
> | rex field=from_domain “(?<from_tld>\w+)$”  
> | rex field=message_body “(?<dkim_domain>^DKIM-Signature.+?\bdomain=)(?<dkim_domain_val>\S+)”  
> | eval domain_match=if(from_domain=dkim_domain_val,”Matched”,”Unmatched”)  
> | eval dkim_match=if(isnotnull(dkim_domain_val),”Matched”,”Unmatched”)  
> | table _time, ip_address, from_domain, from_tld, dkim_domain_val, domain_match, dkim_match

This SPL code searches for emails in the “mail” index with a “maillog” sourcetype. It uses regular expressions to extract the IP address, sender email address, sender domain, and sender top-level domain (TLD) from the email header, as well as the domain name in the DKIM-Signature header from the message body.

The code then uses the “eval” command to create a field that indicates whether the sender domain and DKIM domain match, and another field that indicates whether the email has a DKIM signature.

Finally, the “table” command is used to display the results in a tabular format, including the timestamp, IP address, sender domain and TLD, DKIM domain, and the results of the domain matching and DKIM signature check.

By analyzing this data, security analysts can quickly identify potential domain impersonation attacks and take appropriate action to prevent them.

# How to recover from a domain impersonation attack

1.  Identify the source of the attack: The first step in recovering from a domain impersonation attack is to identify the source of the attack. This involves analyzing logs and other evidence to determine how the attacker gained access to your domain and what actions they took.
2.  Contain the damage: Once the source of the attack has been identified, it is important to contain the damage to prevent further spread. This may involve blocking the sender’s IP address or domain, quarantining affected email messages, and informing relevant stakeholders.
3.  Restore affected systems: Once the damage has been contained, you can begin restoring any affected systems. This may involve restoring backup data or reinstalling software on compromised systems.
4.  Change access credentials: In some cases, an attacker may have gained access to your systems by stealing login credentials. It is important to change all affected access credentials, including passwords and security tokens.
5.  Update security protocols: Once the affected systems have been restored and access credentials changed, it is important to update your security protocols to prevent future attacks. This may involve implementing additional security controls, such as multi-factor authentication, or updating your email security protocols.
6.  Review incident response plan: After the incident has been resolved, it is important to review your incident response plan and make necessary updates to improve your organization’s security posture. This may include updating procedures for responding to future domain impersonation attacks, conducting additional vulnerability assessments, or implementing new security controls.

# Conclusion

In summary, there are many advanced techniques available for detecting domain impersonation attacks. By combining multiple techniques and leveraging advanced technologies, organizations can improve their ability to detect and prevent domain impersonation attacks and reduce the risk of cyber threats.
