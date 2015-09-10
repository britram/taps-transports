---
title: "Services provided by IETF transport protocols and congestion control mechanisms"
abbrev: TAPS Transports
docname: draft-ietf-taps-transports-00
date: 2014-12-15
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


normative:
  RFC0791:
  RFC2460:
informative:
  RFC0768:
  RFC0793:
  RFC0896:
  RFC1122:
  RFC2018:
  RFC3168:
  RFC3205:
  RFC3390:
  RFC3758:
  RFC3828:
  RFC4340:
  RFC4960:
  RFC5348:
  RFC5405:
  RFC5925:
  RFC5681:
  RFC6093:
  RFC6298:
  RFC6455:
  RFC6691:
  RFC7323:

--- abstract

This document describes services provided by existing IETF protocols and congestion control mechanisms.  It is designed to help application and network stack programmers and to inform the work of the IETF TAPS Working Group.

--- middle

# Introduction

   Most Internet applications make use of the Transport Services
   provided by TCP (a reliable, in-order stream protocol) or UDP (an
   unreliable datagram protocol).  We use the term "Transport Service"
   to mean an end-to-end facility provided by the transport layer.  That
   service can only be provided correctly if information is supplied
   from the application.  The application may determine the information
   to be supplied at design time, compile time, or run time and may
   include guidance on whether an aspect of the service is required, a
   preference by the application, or something in between.  Examples of
   Transport service facilities are reliable delivery, ordered delivery,
   content privacy to in-path devices, integrity protection, and minimal
   latency.

   Transport protocols such as SCTP, DCCP, MPTCP, UDP and UDP-Lite have
   been defined at the transport layer.

   In addition, a transport service may be built on top of these
   transport protocols, using a fraemwork such as WebSockets, or RTP.
   Service built on top of UDP or UDP-Lite typically also need to
   specify a congestion control mechanism, such as TFRC or the LEDBAT
   congestion control mechanism.  This extends the set of available
   Transport Services beyond those provided to applications by TCP and
   UDP.

   Transport services can aslo be differentiated by the services they
   provide: for instance, SCTP offers a message-based service that does
   not suffer head-of-line blocking when used with multiple stream,
   because it can accept blocks of data out of order, UDP-Lite provides
   partial integrity protection when used over link-layer services that
   can support this, and LEDBAT can provide low-priority "scavenger"
   communication.

# Terminology

The following terms are defined throughout this document, and in subsequent documents produced by TAPS describing the composition and decomposition of transport services.

The terminology below is that as was presented at the TAPS WG meeting in Honolulu. While the factoring of the terminology seems uncontroversial, thre may be some entities which still require names (e.g. information about the interface between the transport and lower layers which could lead to the availablity or unavailibility of certain transport protocol features)

Transport Service Feature: 
: a specific feature a transport service provides to its clients end-to-end. Examples include confidentiality, reliable delivery, ordered delivery, message-versus-stream orientation, etc.

Transport Service: 
: a set of transport service features, without an association to any given framing protocol, which provides a complete service to an application.

Transport Protocol: 
: an implementation that provides one or more different transport services using a specific framing and header format on the wire.

Transport Protocol Component: 
: an implementation of a transport service feature within a protocol

Transport Service Instance: 
: an arrangement of transport protocols with a selected set of features and configuration parameters that implements a single transport service, 
e.g. a protocol stack (RTP over UDP)

Application: 
: an entity that uses the transport layer for end-to-end delivery data across the network.

# Transport Protocols

This section provides a list of known IETF transport protocol and
transport protocol frameworks.

## Transport Control Protocol (TCP)

  TCP {{RFC0793}} provides a bidirectional byte-oriented stream over a connection-
  oriented protocol.  The protocol and API use the byte-stream model.

  [EDITOR'S NOTE: Mirja Kuehlewind signed up as contributor for this section.]

### Multipath TCP (MPTCP)

## Stream Control Transmission Protocol (SCTP)

   SCTP {{RFC4960}} provides a bidirectional set of logical unicast streams over one
   a connection-oriented protocol.  The protocol and API use messages,
   rather than a byte-stream.  Each stream of messages is independently
   managed, therefore retransmission does not hold back data sent using
   other logical streams.

   [EDITOR'S NOTE: Michael Tuexen and Karen Nielsen signed up as contributors for these sections.]

### Partial Reliability for SCTP (PR-SCTP)

   PR-SCTP {{RFC3758}} is a variant of SCTP that provides partial
   reliability.

## User Datagram Protocol (UDP)

   The User Datagram Protocol (UDP) {{RFC0768}} provides a unidirectional minimal
   message-passing transport that has no inherent congestion control
   mechanisms.  The service may be multicast and/or unicast.

   [EDITOR'S NOTE: Kevin Fall signed up as contributor for this section.]

### UDP-Lite

   A special class of applications can derive benefit from having
   partially-damaged payloads delivered, rather than discarded, when
   using paths that include error-prone links.  Such applications can
   tolerate payload corruption and may choose to use the Lightweight
   User Datagram Protocol {{RFC3828}}. The service may be multicast and/or
   unicast.

## Datagram Congestion Control Protocol (DCCP)

   The Datagram Congestion Control Protocol (DCCP) {{RFC4340}} is a
   bidirectional transport protocol that provides unicast connections of
   congestion-controlled unreliable messages.  DCCP is suitable for
   applications that transfer fairly large amounts of data and that can
   benefit from control over the tradeoff between timeliness and
   reliability.

## Realtime Transport Protocol (RTP)

   RTP provides an end-to-end network transport service, suitable for
   applications transmitting real-time data, such as audio, video or
   data, over multicast or unicast network services, including TCP, UDP,
   UDP-Lite, DCCP.

   [EDITOR'S NOTE: Varun Singh signed up as contributor for this section.]

## Hypertext Transport Protocol (HTTP) as a pseudotransport

{{RFC3205}}

### WebSockets

{{RFC6455}}

# Transport Service Features

Features as derived from the subsections above.

This section is blank for now.

# IANA Considerations

This document has no considerations for IANA.

# Security Considerations

This document surveys existing transport protocols and protocols providing transport-like services. Confidentiality, integrity, and authenticity are among the features provided by those services. This document does not specify any new components or mechanisms for providing these features. Each RFC listed in this document discusses the security considerations of the specification it contains.

# Contributors

Non-editor contributors of text will be listed here, as in the authors section.

# Acknowledgments

This work is partially supported by the European Commission under grant agreement FP7-ICT-318627 mPlane; support does not imply endorsement. Special thanks to Mirja Kuehlewind for the terminology section and for leading the terminology discussion in Honolulu.



