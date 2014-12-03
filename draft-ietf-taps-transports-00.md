---
title: "Services provided by IETF transport protocols and congestion control mechanisms"
abbrev: TAPS Transports
docname: draft-ietf-taps-transports-00
date: 2014-12-19
category: info
ipr: trust200902

author:
 -
    ins: G. Fairhurst
    name: Godred Fairhurst
    role: editor
    org: University of Aberdeen
    street: School of Engineering, Fraser Noble Building
    city: Aberdeen AB24 3UE
    email: gorry@erg.abdn.ac.uk
 - 
    ins: B. Trammell
    name: Brian Trammell
    role: editor
    org: ETH Zurich
    email: ietf@trammell.ch
    street: Gloriastrasse 35
    city: 8092 Zurich
    country: Switzerland
 - 
    ins: M. Kuehlewind
    name: Mirja Kuehlewind
    role: editor
    org: ETH Zurich
    email: mirja.kuehlewind@tik.ee.ethz.ch
    street: Gloriastrasse 35
    city: 8092 Zurich
    country: Switzerland

normative:
  RFC0791:
  RFC2460:
informative:
  RFC0768:
  RFC0793:
  RFC0896:
  RFC4340:
  RFC4960:
  RFC5348:
  RFC5405:

--- abstract

This document describes services provided by existing IETF protocols and congestion control mechanisms.  It is designed to help application and network stack programmers and to inform the work of the IETF TAPS Working Group.

--- middle

# Introduction

Most Internet applications make use of the Transport Services provided by TCP (a reliable, in-order stream protocol) or UDP (an unreliable datagram protocol). We use the term "Transport Service" to mean the end-to-end service provided to an application by the transport layer. That service can only be provided correctly if information is supplied from the application. The application may determine the information to be supplied at design time, compile time, or run time, and may include guidance on whether some feature is required, a preference by the application, or something in between. Examples of features of Transport Services are reliable delivery, ordered delivery, content privacy to in-path devices, integrity protection, and minimal latency.

The IETF has defined a wide variety of transport protocols beyond TCP and UDP, such as TCP, SCTP, DCCP, MP-TCP, and UDP-Lite. Transport services may be provided directly by these transport protocols, or layered on top of them using protocols such as WebSockets (which runs over TCP) or RTP (over TCP or UDP). Services built on top of UDP or UDP-Lite typically also need to specify a congestion control mechanism, such as TFRC or the LEDBAT congestion control mechanism.  This extends the set of available Transport Services beyond those provided to applications by TCP and UDP.

Transport protocols can aslo be differentiated by the features of the services they provide: for instance, SCTP offers a message-based service that does not suffer head-of-line blocking when used with multiple stream, because it can accept blocks of data out of order, UDP-Lite provides partial integrity protection when used over link-layer services that can support this, and LEDBAT can provide low-priority "scavenger" communication.

# Terminology

The following terms are defined throughout this document, and in subsequent documents produced by TAPS describing the composition and decomposition of transport services.

The terminology below is that as was presented at the TAPS WG meeting in Honolulu. While the factoring of the terminology seems uncontroversial, thre may be some entities which still require names (e.g. information about the interface between the transport and lower layers which could lead to the availablity or unavailibility of certain transport protocol features)

Transport Service Feature: 
:a specific feature a transport service provides to its clients end-to-end. Examples include confidentiality, reliable delivery, ordered delivery, message-versus-stream orientation, etc.

Transport Service: 
:a set of transport service features, without an association to any given framing protocol, which provides a complete service to an application.

Transport Protocol: 
:an implementation that provides one or more different transport services using a specific framing and header format on the wire.

Transport Protocol Component: 
:an implementation of a transport service feature within a protocol

Transport Service Instance: 
:an arrangement of transport protocols with a selected set of features and configuration parameters that implements a single transport service, 
e.g. a protocol stack (RTP over UDP)

Application: 
:an entity that uses the transport layer for end-to-end delivery data across the network.

# Existing Transport Protocols

This section enumerates existing transport protocols 

## Template: Imaginary Transport Protocol (ITP)

(This subsection is a rough template provide initial guidance to subsection authors on how a subsection should be structured and what information should be provided. It will be removed once a real transport protocol has been fully described in the draft; that protocol's description can then be used as template for the others. In general, guidance for writing a transport protocol session is that the description should be short, with enough detail to compare and contrast protocols and extract relevant transport service features, but not necessarily enough detail to implement the protocol or understand corner-cases its design. Implementation details and corner cases, if mentioned, should be further explained by reference.)

### Introduction and Applicability

(This subsection should be at most three paragraphs: what's the protocol called, where can one read about it, what does it do, where is it deployed, and what applications is it used for.)

The Imaginary Transport Protocol (ITP) [reference] provides a unidirectional, connectionless, message-oriented, partially-reliable transport for fixed-sized messages over IP, using protocol number 257. It is intended primarily for use in bidirectional constant-bit-rate (CBR) unicast media transmission. It is not widely implemented within the Internet, as I just made it up, and it has several fatal design flaws, including requiring an illegal protocol number for its operation.

### Core Features

(This subsection should describe each base feature of the base protocol which may be interesting for decomposing the service(s) it provides. Base features are those which require no (1) optional API interactions in normal usage or (2) additional headers on the wire. Dividing descriptions of features into subsections is desirable but optional, snce these features may depend on each other. Each feature should be covered by about two paragraphs.)

ITP's features include time- and retransmission-limited partial reliability and constant-sized message-oriented framing. All ITP messages are 392 octets long, with 8 octets of header and 384 octets of payload. Each message has a message sequence number; ITP acknowledgment messages are 16 octets long. Each message will be retransmitted up to two times (for three total transmissions) if not acknowledged, or if not acknowledged within an application-defined time. Further details of ITP's acknowledgment and message sequence number management scheme are found in [reference].

ITP provides no additional congestion control features. 

### Optional Features

(This subsection should describe each optional feature of the protocol which may be interesting for decomposing the service(s) it provides, as above.)

ITP's retransmission can be optionally completely disabled at the sender-side, though the receiver will continue to send acknowledgments. This optional operation mode has no other effect on the protocol on the wire.

### Application Interface Considerations

(This subsection should describe features the protocol requires of the API. How is the protocol, along with its optional features, normally used by the application? Does it use the sockets API; if so, are there socket options?)

ITP can be used via the sockets interface on systems which support it, by using the SOCK_IMAGINARY socket type. Regardless of the size of the buffer passed to sendmsg(2), the message will be truncated or zero-padded to 384 octets in the ITP message, and recvmsg(2) always returns 384 bytes.

No information about the ack stream is available; retransmission can be optionally disabled via setsockopt(2).

### Interactions with other protocols

(If the protocol uses other protocols to provide additional service components -- commonly, this would include (D)TLS encapsulation -- that should be noted here)

ITP can be encapsulated within DTLS to provide confidentiality, integrity, and authentication, as described in [reference].

### Candidate Components

(This subsection should list candidate components derived from the features above.)

- Time- and retransmission-limited reliability
- Unidirectional transmission
- Fixed-length message-oriented transmission

## Transmission Control Protocol (TCP)

(Volunteer: Mirja Kuehlewind)

## User Datagram Protocol

(Volunteer: Kevin Fall)

## Realtime Transport Protocol

(Volunteer: Varun Singh)

## Stream Control Transmission Protocol

(Volunteers: Michael Tuexen, Karen Nielsen)

# Transport Service Features

(drawn from the candidate features provided by protocol components in the previous section)

# Complete Protocol Feature Matrix

(a comprehensive matrix table goes here; Volunteer: Dave Thaler)

# IANA Considerations

This document has no considerations for IANA.

# Security Considerations

This document surveys existing transport protocols and protocols providing transport-like services. Confidentiality, integrity, and authenticity are among the features provided by those services. This document does not specify any new components or mechanisms for providing these features.

# Contributors

Non-editor contributors of text will be listed here, as in the authors section.

# Acknowledgments

This work is partially supported by the European Commission under grant agreement FP7-ICT-318627 mPlane; support does not imply endorsement.



