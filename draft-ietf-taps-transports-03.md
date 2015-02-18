---
title: "Services provided by IETF transport protocols and congestion control mechanisms"
abbrev: TAPS Transports
docname: draft-ietf-taps-transports-03
date: 2015-02-06
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
informative:
  RFC0768:
  RFC0793:
  RFC0896:
  RFC1122:
  RFC1191:
  RFC1981:
  RFC2018:
  RFC2460:
  RFC3168:
  RFC3205:
  RFC3390:
  RFC3758:
  RFC3828:
  RFC4336:
  RFC4340:
  RFC4341:
  RFC4342:
  RFC4614:
  RFC4821:
  RFC4895:
  RFC4960:
  RFC5061:
  RFC5097:
  RFC5246:
  RFC5348:
  RFC5405:
  RFC5595:
  RFC5596:
  RFC5662:
  RFC5672:
  RFC6773:
  RFC5925:
  RFC5681:
  RFC6093:
  RFC6525:
  RFC6298:
  RFC6935:
  RFC6936:
  RFC6455:
  RFC6347:
  RFC6458:
  RFC6691:
  RFC6824:
  RFC6951:
  RFC7053:
  RFC7323:
  I-D.ietf-aqm-ecn-benefits:
  I-D.ietf-tsvwg-sctp-prpolicies:

--- abstract

This document describes services provided by existing IETF protocols and
congestion control mechanisms.  It is designed to help application and
network stack programmers and to inform the work of the IETF TAPS Working
Group.

--- middle

# Introduction

Most Internet applications make use of the Transport Services provided by
TCP (a reliable, in-order stream protocol) or UDP (an unreliable datagram
protocol). We use the term "Transport Service" to mean the end-to-end
service provided to an application by the transport layer. That service
can only be provided correctly if information about the intended usage is
supplied from the application. The application may determine this
information at design time, compile time, or run time, and may include
guidance on whether a feature is required, a preference by the
application, or something in between. Examples of features of Transport
Services are reliable delivery, ordered delivery, content privacy to
in-path devices, integrity protection, and minimal latency.

The IETF has defined a wide variety of transport protocols beyond TCP and
UDP, including TCP, SCTP, DCCP, MP-TCP, and UDP-Lite. Transport services
may be provided directly by these transport protocols, or layered on top
of them using protocols such as WebSockets (which runs over TCP) or RTP
(over TCP or UDP). Services built on top of UDP or UDP-Lite typically also
need to specify additional mechanisms, including a congestion control
mechanism (such as a windowed congestion control, TFRC or LEDBAT
congestion control mechanism).  This extends the set of available
Transport Services beyond those provided to applications by TCP and UDP.

Transport protocols can also be differentiated by the features of the
services they provide: for instance, SCTP offers a message-based service
that does not suffer head-of-line blocking when used with multiple stream,
because it can accept blocks of data out of order, UDP-Lite provides
partial integrity protection, and LEDBAT can provide low-priority
"scavenger" communication.

# Terminology

The following terms are defined throughout this document, and in
subsequent documents produced by TAPS describing the composition and
decomposition of transport services.

[NOTE: The terminology below was presented at the TAPS WG meeting
in Honolulu. While the factoring of the terminology seems uncontroversial,
there may be some entities which still require names (e.g. information
about the interface between the transport and lower layers which could
lead to the availablity or unavailibility of certain transport protocol
features). Comments are welcome via the TAPS mailing list.]

Transport Service Feature:
: a specific end-to-end feature that a transport service provides to its
clients. Examples include confidentiality, reliable delivery, ordered
delivery, message-versus-stream orientation, etc.

Transport Service:
: a set of transport service features, without an association to any given
framing protocol, which provides a complete service to an application.

Transport Protocol:
: an implementation that provides one or more different transport services
using a specific framing and header format on the wire.

Transport Protocol Component:
: an implementation of a transport service feature within a protocol.

Transport Service Instance:
: an arrangement of transport protocols with a selected set of features
and configuration parameters that implements a single transport service,
e.g. a protocol stack (RTP over UDP).

Application:
: an entity that uses the transport layer for end-to-end delivery data
across the network (this may also be an upper layer protocol or tunnel
encpasulation).

# Existing Transport Protocols

This section provides a list of known IETF transport protocol and
transport protocol frameworks.

[EDITOR'S NOTE: Contributions to the subsections below are welcome]

## Transport Control Protocol (TCP)

TCP is an IETF standards track transport protocol.
{{RFC0793}} introduces TCP as follows: "The
Transmission Control Protocol (TCP) is intended for use as a highly
reliable host-to-host protocol between hosts
in packet-switched computer communication networks, and in interconnected
systems of such networks." Since its introduction, TCP has become the
default connection-oriented,
stream-based transport protocol in the Internet. It is widely implemented
by endpoints and
widely used by common applications.

### Protocol Description

TCP is a connection-oriented protocol, providing a three way handshake to allow a client and server to set up a connection, and mechanisms for orderly completion and immediate teardown of a connection. TCP is defined by a family of RFCs {{RFC4614}}.

TCP provides multiplexing to multiple sockets on each host using port numbers. An active TCP session is identified by its four-tuple of local and remote IP addresses and local port and remote port numbers. The destination port during connection setup has a different role as it is often used to indicate the requested service.

TCP partitions a continuous stream of bytes into segments, sized to fit in IP packets. ICMP-based PathMTU discovery {{RFC1191}}{{RFC1981}} as well as Packetization Layer Path MTU Discovery (PMTUD) {{RFC4821}} are supported.

Each byte in the stream is identified by a sequence number. The sequence number is used to order segments on receipt, to identify segments in acknowledgments, and to detect unacknowledged segments for retransmission. This is the basis of TCP's reliable, ordered delivery of data in a stream. TCP Selective Acknowledgment {{RFC2018}} extends this mechanism by making it possible to identify missing segments more precisely, reducing spurious retransmission.

Receiver flow control is provided by a sliding window: limiting the amount of unacknowledged data that can be outstanding at a given time. The window scale option {{RFC7323}} allows a receiver to use windows greater than
64KB.

All TCP senders provide Congestion Control: This uses a separate window, where each time congestion is detected, this congestion window is reduced. A receiver detects congestion using one of three mechanisms: A retransmission timer, detection of loss (interpreted as a congestion signal), or Explicit Congestion Notification (ECN) {{RFC3168}} to provide early signaling (see {{I-D.ietf-aqm-ecn-benefits}})

A TCP protocol instance can be extended {{RFC4614}} and tuned. Some features are sender-side only, requiring no negotiation with the receiver; some are receiver-side only, some are explicitly negotiated during connection setup.

By default, TCP segment partitioning uses Nagle's algorithm {{RFC0896}} to buffer data at the sender into large segments, potentially incurring sender-side buffering delay; this algorithm can be disabled by the sender to transmit more immediately, e.g. to enable smoother interactive sessions.

[EDITOR'S NOTE: add URGENT and PUSH flag (note {{RFC6093}} says SHOULD NOT use due to the range of TCP implementations that process TCP urgent indications differently.) ]

A checksum provides an Integrity Check and is mandatory across the entire packet. The TCP checksum does not 
support partial corruption protection as in DCCP/UDP-Lite). This check protects from misdelivery of data corrupted data, but is relatively weak, and applications that require end to end integrity of data are recommended to include a stronger integrity check of their payload data.


A TCP service is unicast.

### Interface description

A User/TCP Interface is defined in {{RFC0793}} providing six user commands: Open, Send, Receive, Close, Status. This interface does not describe configuration of TCP options or parameters beside use of the PUSH and URGENT flags.

In API implementations derived from the BSD Sockets API, TCP sockets are created using the `SOCK_STREAM` socket type.

The features used by a protocol instance may be set and tuned via this API.

(more on the API goes here)

### Transport Protocol Components

The transport protocol components provided by TCP are:

- unicast
- connection setup with feature negotiation and application-to-port mapping
- port multiplexing
- reliable delivery
- ordered delivery for each byte stream
- error detection (checksum)
- segmentation
- stream-oriented delivery in a single stream
- data bundling (Nagle's algorithm)
- flow control
- congestion control

[EDITOR'S NOTE: discussion of how to map this to features and TAPS: what does the higher
layer need to decide? what can the transport layer decide based on global
settings? what must the transport layer decide based on network
characteristics?]

## Multipath TCP (MP-TCP)

[EDITOR'S NOTE: a few sentences describing Multipath TCP {{RFC6824}} go
here. Note that this adds transport-layer multihoming to the components
TCP provides]

## Stream Control Transmission Protocol (SCTP)

SCTP {{RFC4960}} is an IETF standards track transport protocol that
provides a bidirectional
set of logical unicast meessage streams over
a connection-oriented protocol.  
Compared to TCP, this protocol and API use messages,
rather than a byte-stream.  Each stream of messages is independently
managed, therefore retransmission does not hold back data sent using
other logical streams.

An SCTP Integrity Check is mandatory across the entire packet (it does not 
support partial
corruption protection as in DCCP/UD-Lite).

The SCTP Partial Reliability Extension (SCTP-PR) is defined in
{{RFC3758}}.

SCTP supports PLPMTU discovery using padding chunks to construct path probes.

[EDITOR'S NOTE: Michael Tuexen and Karen Nielsen signed up as contributors for these sections.]

### Protocol Description

An SCTP service is unicast.

PLPMTUD is required for SCTP.

### Interface Description

{{RFC4960}} defines an abstract API for the base protocol.
An extension to the BSD Sockets API is defined in {{RFC6458}} and covers:

- the base protocol defined in {{RFC4960}}.
- the SCTP Partial Reliability extension defined in {{RFC3758}}.
- the SCTP Authentication extension defined in {{RFC4895}}.
- the SCTP Dynamic Address Reconfiguration extension defined in {{RFC5061}}.

For the following SCTP protocol extensions the BSD Sockets API extension is
defined in the document specifying the protocol extensions:

- the SCTP SACK-IMMEDIATELY extension defined in {{RFC7053}}.
- the SCTP Stream Reconfiguration extension defined in {{RFC6525}}.
- the UDP Encapsulation of SCTP packets extension defined in {{RFC6951}}.
- the additional PR-SCTP policies defined in {{I-D.ietf-tsvwg-sctp-prpolicies}}.

Future documents describing SCTP protocol extensions are expected to describe
the corresponding BSD Sockets API extension in a `Socket API Considerations` section.

The SCTP socket API supports two kinds of sockets:

- one-to-one style sockets (by using the socket type `SOCK_STREAM`).
- one-to-many style socket (by using the socket type `SOCK_SEQPACKET`).

One-to-one style sockets are similar to TCP sockets, there is a 1:1 relationship
between the sockets and the SCTP associations (except for listening sockets).
One-to-many style SCTP sockets are similar to unconnected UDP sockets as there
is a 1:n relationship between the sockets and the SCTP associations.

The SCTP stack can provide information to the applications about state
changes of the individual paths and the association whenever they occur.
These events are delivered similar to user messages but are specifically
marked as notifications.

A couple of new functions have been introduced to support the use of
multiple local and remote addresses.
Additional SCTP-specific send and receive calls have been defined to allow
dealing with the SCTP specific information without using ancillary data
in the form of additional cmsgs, which are also defined.
These functions provide support for detecting partial delivery of
user messages and notifications.

The SCTP socket API allows a fine-grained control of the protocol behaviour
through an extensive set of socket options.

The SCTP kernel implementations of FreeBSD, Linux and Solaris follow mostly
the specified extension to the BSD Sockets API for the base protocol and the
corresponding supported protocol extensions.

### Transport Protocol Components

The transport protocol components provided by SCTP are:

- unicast
- connection setup with feature negotiation and application-to-port mapping
- port multiplexing
- reliable or partially reliable delivery
- ordered and unordered delivery within a stream
- support for multiple prioritised streams
- flow control (slow receiver function)
- message-oriented delivery
- congestion control
- application PDU bundling
- application PDU fragmentation and reassembly
- integrity check

[EDITOR'S NOTE: update this list.]

## User Datagram Protocol (UDP)

The User Datagram Protocol (UDP) {{RFC0768}} {{RFC2460}} is an
IETF standards track transport
protocol. It provides a uni-directional minimal
message-passing transport that has no inherent congestion control
mechanisms or other transport functions.  IETF guidance on the use of
UDP is provided in
{{RFC5405}}. UDP is widely implemented by endpoints and
widely used by common applications.

[EDITOR'S NOTE: Kevin Fall signed up as a contributor for this section.]

### Protocol Description

UDP is a connection-less datagram protocol, with no connection setup 
or feature negotiation. The protocol and API use messages,
rather than a byte-stream.  Each stream of messages is independently
managed, therefore retransmission does not hold back data sent using
other logical streams.

It provides multiplexing to multiple sockets on each host using port numbers.
An active UDP session is identified by its four-tuple of local and remote IP
addresses and local port and remote port numbers.

UDP maps each data segement into an IP packet, or a sequence of IP fragemnts. 

UDP is connectionless. However, applications send a sequence of messages 
that constitute a UDP flow.
Therefore mechanisms for receiver flow control, congestion control, PathMTU
discovery/PLPMTUD, support for ECN, etc need to be provided by
upper layer protocols {{RFC5405}}.

PMTU discovery and PLPMTU discovery may be used by upper layer protocols built on top of UDP {{RFC5405}}. 

For IPv4 the UDP checksum is optional, but recommended for use in
the general Internet {{RFC5405}}. {{RFC2460}} requires the use of this
checksum for IPv6, but {{RFC6935}} permits this to be relaxed for
specific types of application. The checksum support considerations
for omitting the checksum are defined in
{{RFC6936}}. 

This check protects from misdelivery of data corrupted data, but is relatively weak, and applications that require end to end integrity of data are recommended to include a stronger integrity check of their payload data.

A UDP service may support IPv4 broadcast, multicast, anycast and unicast, determined by the IP destination address.

### Interface Description

{{RFC0768}} describes basic requirements for an API for UDP.
Guidance on use of common APIs is provided in {{RFC5405}}.

Many operating systems also allow a UDP socket to be connected,
i.e., to bind a UDP socket to a specific pair of addresses and ports.
This is similar to the corresponding TCP sockets API functionality.
However, for UDP, this is only a local operation that serves to
simplify the local send/receive functions and to filter the traffic
for the specified addresses and ports {{RFC5405}}.

### Transport Protocol Components

The transport protocol components provided by UDP are:

- unicast
- port multiplexing
- IPv4 broadcast, multicast and anycast
- non-reliable delivery
- flow control (slow receiver function)
- non-ordered delivery
- message-oriented delivery
- optional checksum protection.

## Lightweight User Datagram Protocol (UDP-Lite)

The Lightweight User Datagram Protocol (UDP-Lite) {{RFC3828}} is an IETF
standards track transport protocol.
UDP-Lite provides a bidirectional set of logical unicast or
multicast message streams over
a datagram protocol. IETF guidance on the use of UDP-Lite is provided in
{{RFC5405}}.

[EDITOR'S NOTE: Gorry Fairhurst signed up as a contributor for this
section.]

### Protocol Description

UDP-Lite is a connection-less datagram protocol,
with no connection setup or feature negotiation.
The protocol use messages,
rather than a byte-stream.  Each stream of messages is independently
managed, therefore retransmission does not hold back data sent using
other logical streams.

It provides multiplexing to multiple sockets on each host using port
numbers.
An active UDP-Lite session is identified by its four-tuple of local and
remote IP
addresses and local port and remote port numbers.

UDP-Lite fragments packets into IP packets, constrained by the maximum
size of IP packet.

UDP-Lite changes the semantics of the UDP "payload length" field to
that of a "checksum coverage length" field.  Otherwise, UDP-Lite is
semantically identical to UDP.  Applications using UDP-Lite therefore
can not make
assumptions regarding the correctness of the data received in the
insensitive part of the UDP-Lite payload.

As for UDP, mechanisms for receiver flow control, congestion control,
PMTU or PLPMTU
discovery, support for ECN, etc need to be provided by
upper layer protocols {{RFC5405}}.

Examples of use include a class of applications that
can derive benefit from having
partially-damaged payloads delivered, rather than discarded. One
use is to support error
tolerate payload corruption when used over paths that include error-prone links,
another
application is when header integrity checks are required, but
payload integrity is provided by some other mechanism (e.g. {{RFC6936}}.

A UDP-Lite service may support IPv4 broadcast, multicast, anycast and
unicast.

### Interface Description

There is no current API specified in the RFC Series, but guidance on
use of common APIs is provided in {{RFC5405}}.

The interface of UDP-Lite differs
from that of UDP by the addition of a single (socket) option that
communicates a checksum coverage length value: at the sender, this
specifies the intended checksum coverage, with the remaining
unprotected part of the payload called the "error-insensitive part".
The checksum coverage may also be made visible to the application
via the UDP-Lite MIB module {{RFC5097}}.

### Transport Protocol Components

The transport protocol components provided by UDP-Lite are:

- unicast
- IPv4 broadcast, multicast and anycast
- port multiplexing
- non-reliable, non-ordered delivery
- message-oriented delivery
- partial integrity protection


## Datagram Congestion Control Protocol (DCCP)

Datagram Congestion Control Protocol (DCCP) {{RFC4340}} is an
IETF standards track
bidirectional transport protocol that provides unicast connections of
congestion-controlled unreliable messages.  

[EDITOR'S NOTE: Gorry Fairhurst signed up as a contributor for this
section.]

The DCCP Problem Statement describes the goals that
DCCP sought to address {{RFC4336}}. It is suitable for
applications that transfer fairly large amounts of data and that can
benefit from control over the trade off between timeliness and
reliability {{RFC4336}}.

It offers  low overhead, and many characteristics 
common to UDP, but can avoid "Re-inventing the wheel"
each time a new multimedia application emerges. 
Specifically it includes core functions (feature 
negotiation, path state management, RTT calculation, 
PMTUD, etc): This allows applications to use a 
compatible method defining how they send packets 
and where suitable to choose common algorithms to
manage their functions. 
Examples of suitable applications include interactive applications,
streaming media or on-line games {{RFC4336}}.


### Protocol Description

DCCP is a connection-oriented datagram protocol, providing a three way
handshake to allow a client and server to set up a connection,
and mechanisms for orderly completion and immediate teardown of
a connection. The protocol is defined by a family of RFCs.

It provides multiplexing to multiple sockets on each host using
port numbers. An active DCCP session is identified by its four-tuple
of local and remote IP addresses and local port and remote port numbers.
At connection setup, DCCP also exchanges the the service code {{RFC5595}}
mechanism to allow transport instantiations to indicate
the service treatment that is expected from the network.

The protocol segments data into messages, typically sized to
fit in IP packets, but which may be fragemented providing they
are less than the  A DCCP interface MAY allow applications to
request fragmentation for packets larger than PMTU, but not
larger than the maximum packet size allowed by the current 
congestion control mechanism (CCMPS) {{RFC4340}}.

Each message
is identified by a sequence number. The sequence number is used to
identify segments
in acknowledgments, to detect unacknowledged segments, to measure RTT,
etc.
The protocol may support ordered or unordered delivery of data, and does
not
itself provide retransmission. There is a Data Checksum option, 
which contains a strong CRC, lets endpoints
detect application data corruption. It also supports
reduced checksum coverage, a partial integrity mechanisms similar to UDP-lIte. 

Receiver flow control is supported: limiting the amount of
unacknowledged data
that can be outstanding at a given time.

A DCCP protocol instance can be extended {{RFC4340}} and tuned.
Some features are sender-side only, requiring no negotiation with the
receiver;
some are receiver-side only, some are explicitly negotiated during
connection setup.

DCCP supports negotiation of the congestion control profile,
to provide Plug and Play congestion control mechanisms.
examples of specified profiles include
{{RFC4341}} {{RFC4342}} {{RFC5662}}.
All IETF-defined methods provide Congestion Control.

DCCP use a Connect packet to start a session, and permits 
half-connections that allow each client to choose 
features it wishes to support. Simultaneous open 
{{RFC5596}}, as in TCP, can enable interoperability in 
the presence of middleboxes. The Connect packet includes 
a Service Code field {{RFC5595}} designed to allow middle 
boxes and endpoints to identify the characteristics 
required by a session. A lightweight UDP-based encapsulation (DCCP-UDP) 
has been defined {{RFC6773}} that permits DCCP to be 
used over paths where it is not natively supported. 
Support in NAPT/NATs is defined in {{RFC4340}} and {{RFC5595}}.

Upper layer protocols specified on top of DCCP 
include: DTLS {{RFC5595}}, RTP {{RFC5672}}, 
ICE/SDP {{RFC6773}}.

A DCCP service is unicast.

A common packet format has allowed tools to evolve that can 
read and interpret DCCP packets (e.g. Wireshark).


### Interface Description

API charactersitics include:
- Datagram transmission.
- Notification of the current maximum packet size.
- Send and reception of zero-length payloads.
- Set the Slow Receiver flow control at areceiver.
- Detct a Slow receiver at the sender.

There is no current API specified in the RFC Series.

### Transport Protocol Components

The transport protocol components provided by DCCP are:

- unicast
- connection setup with feature negotiation and application-to-port mapping
- Service Codes
- port multiplexing
- non-reliable, ordered delivery
- flow control (slow receiver function)
- drop notification
- timestamps
- message-oriented delivery
- partial integrity protection

## Realtime Transport Protocol (RTP)

RTP provides an end-to-end network transport service, suitable for
applications transmitting real-time data, such as audio, video or
data, over multicast or unicast network services, including TCP, UDP,
UDP-Lite, DCCP.

[EDITOR'S NOTE: Varun Singh signed up as contributor for this section.]

## Transport Layer Security (TLS) and Datagram TLS (DTLS) as a
pseudo transport

[NOTE: A few words on TLS {{RFC5246}} and DTLS {{RFC6347}} here, 
and how they get used by other protocols to meet security 
goals as an add-on interlayer above transport.]

### Protocol Description

### Interface Description

### Transport Protocol Components

## Hypertext Transport Protocol (HTTP) as a pseudotransport

{{RFC3205}}

[EDITOR'S NOTE: No identified contributor for this section yet.]

### Protocol Description

### Interface Description

### Transport Protocol Components

## WebSockets

{{RFC6455}}

[EDITOR'S NOTE: No identified contributor for this section yet.]

### Protocol Description

### Interface Description

### Transport Protocol Components

# Transport Service Features

[EDITOR'S NOTE: this section will drawn from the candidate features provided by protocol components in the
previous section -- please discuss on taps@ietf.org list]

## Complete Protocol Feature Matrix

[EDITOR'S NOTE: Dave Thaler has signed up as a contributor for this section. Michael Welzl also has a beginning of a matrix which could be useful here.]

[EDITOR'S NOTE: The below is a strawman proposal below by Gorry Fairhurst for initial discussion]

The table below summarises protocol mechanisms that have been standardised. It does not make an assessment on whether specific implementations are fully compliant to these specifications.

| Mechanism       | UDP     | UDP-L   | DCCP    | SCTP    | TCP     |
|-----------------|---------|---------|---------|---------|---------|
| Unicast         | Yes     | Yes     | Yes     | Yes     | Yes     |
| Mcast/IPv4Bcast | Yes(2)  | Yes     | No      | No      | No      |
| Port Mux        | Yes     | Yes     | Yes     | Yes     | Yes     |
|-----------------|---------|---------|---------|---------|---------|
| Mode            | Dgram   | Dgram   | Dgram   | Dgram   | Stream  |
| Connected       | No      | No      | Yes     | Yes     | Yes     |
| Data bundling   | No      | No      | No      | Yes     | Yes     |
|-----------------|---------|---------|---------|---------|---------|
| Feature Nego    | No      | No      | Yes     | Yes     | Yes     |
| Options         | No      | No      | Support | Support | Support |
| Data priority   | *       | *       | *       | Yes     | No      |
| Data bundling   | No      | No      | No      | Yes     | Yes     |
|-----------------|---------|---------|---------|---------|---------|
| Reliability     | None    | None    | None    | Select  | Full    |
| Ordered deliv   | No      | No      | No      | Stream  | Yes     |
| Corruption Tol. | No      | Support | Support | No      | No      |
| Flow Control    | No      | No      | Support | Yes     | Yes     |
| PMTU/PLPMTU     | (1)     | (1)     | Yes     | Yes     | Yes     |
|-----------------|---------|---------|---------|---------|---------|
| Cong Control    | (1)     | (1)     | Yes     | Yes     | Yes     |
| ECN Support     | (1)     | (1)     | Yes     | TBD     | Yes     |
|-----------------|---------|---------|---------|---------|---------|
| NAT support     | Limited | Limited | Support | TBD     | Support |
| Security        | DTLS    | DTLS    | DTLS    | DTLS    | TLS, AO |
| UDP encaps      | N/A     | None    | Yes     | Yes     | None    |
| RTP support     | Support | Support | Support | ?       | Support |

Note (1): this feature requires support in an upper layer protocol. 

Note (2): this feature requires support in an upper layer protocol when used with IPv6.

# IANA Considerations

This document has no considerations for IANA.

# Security Considerations

This document surveys existing transport protocols and protocols providing transport-like services. Confidentiality, integrity, and authenticity are among the features provided by those services. This document does not specify any new components or mechanisms for providing these features. Each RFC listed in this document discusses the security considerations of the specification it contains.

# Contributors

[EDITOR'S NOTE: Non-editor contributors of text will be listed here, as noted in the authors
section.]

# Acknowledgments

This work is partially supported by the European Commission under grant
agreement FP7-ICT-318627 mPlane; support does not imply endorsement.
