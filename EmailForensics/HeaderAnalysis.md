# Email Header Analysis
Email header analysis can be a useful tool in forensic investigations, as it can reveal valuable information about the origin, path, and content of an email message. Here are some detailed checkpoints to consider when analyzing email headers for forensics purposes:
## Analyze the Received headers: 
The Received header section provides information on the servers that handled the message as it was being delivered. It includes the IP address, hostname, and timestamp of each server that processed the message. This information can help identify the sender, the path of the message, and any potential intermediaries that may have intercepted or modified the message.

**Example:**

> Received: from example.com (192.0.2.1) by mailserver1.example.org
> (192.0.2.2) with SMTP; 10 Nov 2022 12:01:00 -0500

In this example, the email was received by mailserver1.example.org, which indicates that the email was likely sent to someone within the example.org domain. The IP address of the sending server (192.0.2.1) is also listed, which can help identify the location of the sender.

## 2. Check the Return-Path header:
The Return-Path header specifies the email address to which undeliverable messages are returned. This header can help you identify the sender or the originating server of the email.

**Example:**

> Return-Path: [sender@example.com](mailto:sender@example.com)

 
In this example, the Return-Path header specifies that undeliverable messages should be returned to the email address [sender@example.com](mailto:sender@example.com). This can help identify the sender or the originating server of the email.

## Look for the Message-ID header:
The Message-ID header contains a unique identifier for each email message. This identifier can help link related messages together and identify any duplicates or variations of the same message.

**Example:**

> Message-ID: [1234567890@example.com](mailto:1234567890@example.com)

In this example, the Message-ID header specifies a unique identifier for the email message. This identifier can be used to track related messages and identify any duplicates or variations of the same message.

## Check the Received-SPF header:

The Received-SPF header indicates whether the email passed an SPF (Sender Policy Framework) check. SPF is an email authentication protocol that helps prevent email spoofing by verifying that the email was sent from an authorized IP address. Examining this header can help you determine whether the email was sent from a legitimate sender or if it is a spoofed email.

**Example:**

> Received-SPF: pass (example.com: domain of
> [sender@example.com](mailto:sender@example.com) designates 192.0.2.1
> as permitted sender)

In this example, the Received-SPF header indicates that the email passed an SPF check, and the email was sent from the IP address 192.0.2.1, which was authorized to send emails from the [sender@example.com](mailto:sender@example.com) domain. This suggests that the email is likely legitimate and not spoofed.

## Check the DKIM-Signature header:

The DKIM-Signature header contains a digital signature that verifies the authenticity of the email message. DKIM (DomainKeys Identified Mail) is another email authentication protocol that allows the recipient to verify that the email message was sent from an authorized domain and that the message has not been altered during transit. Examining this header can help you determine whether the email is legitimate or if it has been tampered with.

**Example:**

> DKIM-Signature: v=1; a=rsa-sha256; d=example.com; s=20190101;
> c=relaxed/relaxed; q=dns/txt; h=From:To:Subject:Date:Message-ID;
> bh=XXXXXXXXXXXXX; b=YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY;

In this example, the DKIM-Signature header contains a digital signature that verifies the authenticity of the email message. The signature includes the domain name (d=example.com) and a hash value (bh=XXXXXXXXXXXXX) that represents the body of the message. The b= field contains the encrypted signature value (YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY). If the signature is valid, the recipient can be assured that the email was sent from the domain specified in the DKIM-Signature header and that the message has not been altered during transit.

## Check the Authentication-Results header:

The Authentication-Results header provides a summary of the authentication checks that the email message passed or failed, including SPF, DKIM, and DMARC (Domain-based Message Authentication, Reporting and Conformance). Examining this header can help you determine whether the email is legitimate or if it has been spoofed or tampered with.

**Example:**

> Authentication-Results: mx.google.com; dkim=pass
> header.i=@example.com; spf=pass (google.com: domain of
> [sender@example.com](mailto:sender@example.com) designates 192.0.2.1
> as permitted sender)
> smtp.mailfrom=[sender@example.com](mailto:sender@example.com);
> dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE)
> header.from=example.com

In this example, the Authentication-Results header indicates that the email passed DKIM and SPF authentication checks, and the DMARC policy is set to QUARANTINE. This suggests that the email is likely legitimate and not spoofed or tampered with. However, the DMARC policy instructs the recipient's email client to quarantine or flag the email message since it is not fully aligned with the DMARC policy. Examining this header can help you identify potential phishing or spam emails.

## Examine the From and To headers:
The From header indicates the sender's email address, while the To header shows the recipient's email address. These headers can be spoofed, but they can still provide useful information about the email's origin and destination.

**Example:**

> From: [sender@example.com](mailto:sender@example.com) To:
> [recipient@example.org](mailto:recipient@example.org)

In this example, the From header specifies the email address of the sender, while the To header shows the email address of the recipient.

**Review the Subject header:** 
The Subject header contains the subject line of the email. It can provide clues about the content of the email and its purpose.

**Example:**

    Subject: Your Order Confirmation

In this example, the Subject header indicates that the email is an order confirmation. This can help you identify the purpose of the email and determine whether it is legitimate or suspicious.

## Check for X-headers:

X-headers are custom headers added by mail servers or email clients. These headers can provide additional information about the email, such as the software used to create or send the email.

**Example:**

    X-Mailer: Microsoft Outlook Express 6.00.2800.1081

In this example, the X-Mailer header indicates that the email was created using Microsoft Outlook Express version 6.00.2800.1081.

## Check the Reply-To header:

The Reply-To header specifies the email address that the recipient should use when replying to the message. Examining this header can help you determine if the email is a phishing attempt or if the sender is attempting to impersonate someone else.

**Example:**

    Reply-To: [john.doe@example.com](mailto:john.doe@example.com)

In this example, the Reply-To header specifies that the recipient should use the email address [john.doe@example.com](mailto:john.doe@example.com) when replying to the message. If the sender's email address is different from the Reply-To address, it could indicate an attempt to deceive the recipient or engage in phishing.

## Check the X-Mailer header:

The X-Mailer header specifies the email client or software that was used to compose the message. Examining this header can help you identify the type of email client or software that was used to send the message, which can provide useful information for forensic analysis.

**Example:**

    X-Mailer: Microsoft Outlook, Build 17.0.4456.1003

In this example, the X-Mailer header specifies that the message was composed using Microsoft Outlook version 17.0.4456.1003. Examining this header can provide useful information for forensic analysis, such as the type of email client or software that was used to send the message. However, this header can also be easily spoofed, so it should be used in conjunction with other header items to determine the legitimacy of the message.

## Look for any unusual or suspicious headers:

Some headers may indicate that the email has been modified or tampered with, such as the X-Spam-Status header, which can indicate whether the email was flagged as spam.

**Example:**

     X-Spam-Status: Yes, score=5.0

In this example, the X-Spam-Status header indicates that the email was flagged as spam, with a score of 5.0.

## Conclusion
Overall, email header analysis can provide valuable information about the sender, recipient, and path of a message. By carefully examining each header and looking for any inconsistencies or suspicious activity, forensic investigators can gain insight into the message's purpose and potential risks.
