---
title: "Services provided by IETF transport protocols and congestion control mechanisms"
abbrev: TAPS Transports
docname: draft-ietf-taps-transports-09
date: 2016-1-22
category: info
ipr: trust200902
coding: us-ascii
pi:
    toc: yes

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

informative:
  RFC0768:
  RFC0792:
  RFC0793:
  RFC0896:
  RFC1122:
  RFC1191:
  RFC1716:
  RFC1981:
  RFC2018:
  RFC2045:
  RFC2460:
  RFC2461:
  RFC2617:
  RFC2710:
  RFC2736:
  RFC3168:
  RFC3205:
  RFC3260:
  RFC3436:
  RFC3450:
  RFC3452:
  RFC3550:
  RFC3738:
  RFC3758:
  RFC3828:
  RFC3926:
  RFC3971:
  RFC4324:
  RFC4336:
  RFC4340:
  RFC4341:
  RFC4342:
  RFC4433:
  RFC4654:
  RFC4820:
  RFC4821:
  RFC4828:
  RFC4895:
  RFC4960:
  RFC5061:
  RFC5097:
  RFC5246:
  RFC5238:
  RFC5348:
  RFC5461:
  RFC5595:
  RFC5596:
  RFC5622:
  RFC5651:
  RFC5672:
  RFC5740:
  RFC5775:
  RFC5681:
  RFC6056:
  RFC6083:
  RFC6093:
  RFC6525:
  RFC6546:
  RFC6347:
  RFC6356:
  RFC6363:
  RFC6458:
  RFC6584:
  RFC6726:
  RFC6773:
  RFC6824:
  RFC6897:
  RFC6935:
  RFC6936:
  RFC6951:
  RFC7053:
  RFC7202:
  RFC7230:
  RFC7231:
  RFC7232:
  RFC7233:
  RFC7234:
  RFC7235:
  RFC7301:
  RFC7323:
  RFC7414:
  RFC7457:
  RFC7496:
  RFC7525:
  RFC7540:
  I-D.ietf-aqm-ecn-benefits:
  I-D.ietf-tsvwg-rfc5405bis:
  I-D.ietf-tsvwg-sctp-dtls-encaps:
  I-D.ietf-tsvwg-sctp-ndata:
  I-D.ietf-tsvwg-sctp-failover:
  I-D.ietf-tsvwg-natsupp:
  I-D.ietf-tcpm-cubic:

  XHR:
    title: "XMLHttpRequest working draft (http://www.w3.org/TR/XMLHttpRequest/)"
    author:
      -
        ins: A. van Kesteren
      -
        ins: J. Aubourg
      -
        ins: J. Song
      -
        ins: H. R. M. Steen
    date: 2000
  REST:
    title: "Architectural Styles and the Design of Network-based Software Architectures, Ph. D. (UC Irvine), Chapter 5: Representational State Transfer"
    author:
      -
        ins: R. T. Fielding
    date: 2000
  POSIX:
    title: "IEEE Standard for Information Technology -- Portable Operating System Interface (POSIX) Base Specifications, Issue 7"
    author:
      -
        ins: IEEE Std. 1003.1-2008
  MBMS:
    title:  "3GPP TS 26.346: Multimedia Broadcast/Multicast Service (MBMS); Protocols and codecs, release 13 (http://www.3gpp.org/DynaReport/26346.htm)."
    author:
      -
        ins: 3GPP TSG WS S4
    date: 2015
  ClarkArch:
    title: Architectural Considerations for a New Generation of Protocols (Proc. ACM SIGCOMM)
    author:
      -
        ins: D. Clark
      -
        ins: D. Tennenhouse
    date: 1990
--- abstract

This document describes, surveys, classifies and compares the protocol
mechanisms provided by existing IETF protocols, as background for determining
a common set of transport services. It examines the Transmission Control
Protocol (TCP), Multipath TCP, the Stream Control Transmission Protocol
(SCTP), the User Datagram Protocol (UDP), UDP-Lite, the Datagram Congestion
Control Protocol (DCCP), the Internet Control Message Protocol (ICMP), the
Realtime Transport Protocol (RTP), File Delivery over Unidirectional
Transport/Asynchronous Layered Coding Reliable Multicast (FLUTE/ALC), and
NACK-Oriented Reliable Multicast (NORM), Transport Layer Security (TLS),
Datagram TLS (DTLS), and the Hypertext Transport Protocol (HTTP) when used as
a pseudotransport.

--- middle

# Introduction

Internet applications make use of the Services provided by a 
Transport protocol, such as 
TCP (a reliable, in-order stream protocol) or UDP (an unreliable datagram
protocol). We use the term "Transport Service" to mean the end-to-end
service provided to an application by the transport layer. That service
can only be provided correctly if information about the intended usage is
supplied from the application. The application may determine this
information at design time, compile time, or run time, and may include
guidance on whether a feature is required, a preference by the
application, or something in between. Examples of features of Transport
Services are reliable delivery, ordered delivery, content privacy to
in-path devices, and integrity protection.

The IETF has defined a wide variety of transport protocols beyond TCP and
UDP, including SCTP, DCCP, MPTCP, and UDP-Lite. Transport services
may be provided directly by these transport protocols, or layered on top
of them using protocols such as WebSockets (which runs over TCP), RTP
(over TCP or UDP) or WebRTC data channels (which run over SCTP over DTLS
over UDP or TCP). Services built on top of UDP or UDP-Lite typically also
need to specify additional mechanisms, including a congestion control
mechanism (such as NewReno, TFRC or LEDBAT).  This extends the set of available
Transport Services beyond those provided to applications by TCP and UDP.

## Overview of Transport Features

Transport protocols can be differentiated by the features of the services they provide.

Some of these provided feature are closely related to basic control function 
that a protocol needs to work over a network path, such as addressing.
<!---There are different ways that a transport protocol may use the addressing capabilities
 of the under-lying network service.--->
Further transport services must be<!-- unidirectional or bidirectional,---> either to a single
endpoint, to one of multiple endpoints, or multicast simultaneously to multiple endpoints.
<!-- Editors note: uni-/bi-directional not mentioned on section 5-->

<!---Another fundamental feature is whether a transport requires a control exchange
across the network at setup (e.g., TCP), or whether it connection-less (e.g., UDP).--->
<!--- Editor note: connection setup is not metioned in section 5.--->

For the delivery of the packets itself, reliability (incl. integrety protection), ordering, 
as well as the used frameing have been identified as basic features. However, these features are 
implement in different protocols supporting different levels of assurance.
As an example, a transport service may provide full reliability, providing detection
of loss and retransmission (e.g., TCP). SCTP offers a message-based service
that can provide full or partial reliability and allows the protocol to minimize the head of line
blocking due to the support of ordered and unordered message delivery within
multiple streams. UDP-Lite and DCCP can provide partial integrity protection to enable 
corruption tolerance of the transport service.

Usually a protocol has been designed to support one spcific type of delivery/framing where
either data needs to be devided into transmission units based on network packets (known as a
Datagram service), a data stream is segmented and re-combined across multiple
packets (e.g., the Stream service provided by TCP), or whole objects such as files are handled accordingly.
This descision influences strongly the interface that is provided to the upper layer.

In addition transport protocols offer a certain support on transmission control.
E.g., a transport service can provide flow control to allow a receiver to regulate
the transmission rate of a sender. Further a transport service can provide congestion control 
(see {{congestion-control}}). As an example TCP and SCTP provide 
congestion control for use in the Internet, whereas UDP leaves this function
to the upper layer protocol that uses UDP. <!---DCCP offers a range of congestion
control approaches and LEDBAT can support low-priority "scavenger" communication,
intending to defer use of capacity to other Internet flows sharing a congested
bottleneck.-->
<!-- Editors note: Name segmentation, message bundling and stream scheduling here...? -->


<!--- Editors note: Add one sentence/paragraph on security? Multi-homing is also not mentioned, but I think that's okay--->

The service(s) offered by transport protocols and frameworks can also be 
differentiated in many other ways. 


# Terminology

The following terms are defined throughout this document, and in
subsequent documents produced by TAPS describing the composition and
decomposition of transport services.

Transport Service Feature:
: a specific end-to-end feature that the transport layer provides to 
an application. Examples include confidentiality, reliable delivery, ordered
delivery, message-versus-stream orientation, etc.

Transport Service:
: a set of Transport Features, without an association to any given
framing protocol, which provides a complete service to an application.

Transport Protocol:
: an implementation that provides one or more different transport services
using a specific framing and header format on the wire.

Transport Service Instance:
: an arrangement of transport protocols with a selected set of features
and configuration parameters that implements a single transport service,
e.g., a protocol stack (RTP over UDP).

Application:
: an entity that uses the transport layer for end-to-end delivery data
across the network (this may also be an upper layer protocol or tunnel
encapsulation).


# Existing Transport Protocols

This section provides a list of known IETF transport protocols and transport
protocol frameworks.  It does not make an assessment about whether specific
implementations of protocols are fully compliant to current IETF
specifications.

## Transport Control Protocol (TCP)

TCP is an IETF standards track transport protocol. {{RFC0793}} introduces TCP
as follows: "The Transmission Control Protocol (TCP) is intended for use as a
highly reliable host-to-host protocol between hosts in packet-switched
computer communication networks, and in interconnected systems of such
networks." Since its introduction, TCP has become the default connection-
oriented, stream-based transport protocol in the Internet. It is widely
implemented by endpoints and widely used by common applications.

### Protocol Description

TCP is a connection-oriented protocol, providing a three way handshake to
allow a client and server to set up a connection and negotiate features, and
mechanisms for orderly completion and immediate teardown of a connection. TCP
is defined by a family of RFCs {{RFC7414}}.

TCP provides multiplexing to multiple sockets on each host using port numbers.
A similar approach is adopted by other IETF-defined transports.
An active TCP session is identified by its four-tuple of local and remote IP
addresses and local port and remote port numbers. The destination port during
connection setup is often used to indicate the requested service.

TCP partitions a continuous stream of bytes into segments, sized to fit in IP
packets based on a negotiated maximum segment size and further constrained by 
the effective MTU from PMTUD. ICMP-based Path MTU discovery {{RFC1191}}{{RFC1981}} as well as
Packetization Layer Path MTU Discovery (PMTUD) {{RFC4821}} have been
defined by the IETF.

Each byte in the stream is identified by a sequence number. The sequence
number is used to order segments on receipt, to identify segments in
acknowledgments, and to detect unacknowledged segments for retransmission.
This is the basis of the reliable, ordered delivery of data in a TCP stream. TCP
Selective Acknowledgment (SACK) {{RFC2018}} extends this mechanism by making it
possible to provide earlier identification of which segments are missing, 
allowing faster retransmission. SACK-based methods (e.g. DSACK) can also result 
in less spurious retransmission.

Receiver flow control is provided by a sliding window: limiting the amount of
unacknowledged data that can be outstanding at a given time. The window scale
option {{RFC7323}} allows a receiver to use windows greater than 64KB.

All TCP senders provide congestion control, such as described in {{RFC5681}}.
TCP's congestion control mechanism is tied to a sliding window as well
{{RFC5681}}. Examples for different kind of congestion control schemes are
given in {{congestion-control}}. The sending window at a given point in time
is the minimum of the receiver window and the congestion window. The
congestion window is increased in the absence of congestion and, respectively,
decreased if congestion is detected. Often loss is implicitly handled as a
congestion indication which is detected in TCP (also as input for
retransmission handling) based on two mechanisms: A retransmission timer with
exponential back-up or the reception of three acknowledgment for the same
segment, so called duplicated ACKs (Fast retransmit). In addition, Explicit
Congestion Notification (ECN) {{RFC3168}} can be used in TCP, if supported by
both endpoints, that allows a network node to signal congestion without
inducing loss. Alternatively, a delay-based congestion control scheme can be
used in TCP that reacts to changes in delay as an early indication of
congestion as also further described in {{congestion-control}}.

TCP protocol instances can be extended {{RFC7414}} and tuned. Some features
are sender-side only, requiring no negotiation with the receiver; some are
receiver-side only, some are explicitly negotiated during connection setup.

TCP may buffer data, e.g., to optimise processing or
capacity usage. TCP can therefore provides mechanisms to control this, including
an optional "PUSH" function {{RFC0793}} that explicitly requests the 
transport service not to  delay data. 
By default, TCP segment partitioning uses Nagle's algorithm {{RFC0896}} to
buffer data at the sender into large segments, potentially incurring
sender-side buffering delay; this algorithm can be disabled by the sender to
transmit more immediately, e.g., to reduce latency for interactive sessions.

TCP provides an "urgent data" function for limited out-of-order delivery of
the data. This function is deprecated {{RFC6093}}.

A mandatory checksum provides a basic integrity check against misdelivery and
data corruption over the entire packet. Applications that require end to end
integrity of data are recommended to include a stronger integrity check of
their payload data. The TCP checksum does not support partial payload
protection (as in DCCP/UDP-Lite).

TCP supports only unicast connections.

### Interface description

A User/TCP Interface is defined in {{RFC0793}} providing six user commands:
Open, Send, Receive, Close, Status. This interface does not describe
configuration of TCP options or parameters beside use of the PUSH and URGENT
flags.

{{RFC1122}} describes extensions of the TCP/application layer interface for:

- reporting soft errors such as reception of ICMP error messages, extensive retransmission or urgent pointer advance,
- providing a possibility to specify the Differentiated Services Code Point (DSCP) {{RFC3260}} (formerly, the Type-of-Service, TOS) for segments,
- providing a flush call to empty the TCP send queue, and
- multihoming support.

In API implementations derived from the BSD Sockets API, TCP sockets are
created using the `SOCK_STREAM` socket type as described in the IEEE Portable
Operating System Interface (POSIX) Base Specifications {{POSIX}}.
The features used by a protocol instance may be set and tuned via this API.
There are currently no documents in the RFC Series that describe this interface.

### Transport Features

The transport features provided by TCP are:

- unicast transport,
- connection setup with feature negotiation and application-to-port mapping (implemented using SYN segments and the TCP option field to negotiate features),
- port multiplexing, <!--each TCP session is uniquely identified by a combination of the ports and IP address fields,-->
- uni-or bidirectional communication,
- stream-oriented delivery in a single stream,
- fully reliable delivery (implemented using ACKs sent from the receiver to confirm delivery),
- error detection (implemented using a segment checksum to verify delivery to the correct endpoint and integrity of the data and options), <!-- editors note: stream integrity protection-->
- segmentation and aggregation,
- data bundling (optional; uses Nagle's algorithm to coalesce data sent within the same RTT into full-sized segments),
- flow control (implemented using a window-based mechanism where the receiver advertises the window that it is willing to buffer),
- congestion control (usually implemented using a window-based mechanism and four algorithm for different phases of the transmission: slow start, congestion avoidance, fast retransmit, and fast recovery {{RFC5681}}).


## Multipath TCP (MPTCP)

Multipath TCP {{RFC6824}} is an extension for TCP to support multi-homing for
resilience, mobility and load-balancing. It is
designed to be as transparent as possible to middleboxes. It does so by
establishing regular TCP flows between a pair of source/destination endpoints,
and multiplexing the application's stream over these flows. 
Sub-flows can be started over IPv4 or IPv6 for
the same session.

### Protocol Description

MPTCP uses TCP options for its control plane. They are used to signal multipath
capabilities, as well as to negotiate data sequence numbers, and advertise other
available IP addresses and establish new sessions between pairs of endpoints.

By multiplexing one byte stream over separate paths, MPTCP can achieve a
higher throughput than TCP in certain situations. Note, however, that coupled
congestion control {{RFC6356}} might limit this benefit to maintain fairness to
other flows at the bottleneck. When aggregating capacity over multiple paths,
and depending on the way packets are scheduled on each TCP subflow,
additional delay and higher jitter might be observed observed before in-order
delivery of data to the applications.

### Interface Description

By default, MPTCP exposes the same interface as TCP to the application.
{{RFC6897}} however describes a richer API for MPTCP-aware applications.

This Basic API describes how an application can:

- enable or disable MPTCP.
- bind a socket to one or more selected local endpoints.
- query local and remote endpoint addresses.
- get a unique connection identifier (similar to an address--port pair for TCP).

The document also recommends the use of extensions defined for SCTP {{RFC6458}}
(see next section) to support multihoming for resilience and mobility.

### Transport features

As an extension to TCP, MPTCP provides mostly the same features. By
establishing multiple sessions between available endpoints, it can additionally
provide soft failover solutions should one of the paths become unusable. 

The transport features provided by MPTCP in addition to TCP therefore are:

- congestion control with load balancing over multiple connections,
- endpoint multiplexing of a single byte stream (higher throughput),
- address family multiplexing (using IPv4 and IPv6 for the same session),
- resilience to network failure and/or handover.

## Stream Control Transmission Protocol (SCTP)

SCTP is a message-oriented IETF standards track transport protocol. The base
protocol is specified in {{RFC4960}}. It supports multi-homing and path
failover to provide resilience to path failures. An SCTP association has
multiple streams in each direction, providing in-sequence delivery of user
messages within each stream. This allows it to minimize head of line blocking.
SCTP supports multiple stream scheduling schemes controlling stream
multiplexing, including priority and fair weighting schemes.

SCTP was originally developed for transporting telephony signalling messages
and is deployed in telephony signalling networks, especially in mobile
telephony networks. It can also be used for other services, for example, in the
WebRTC framework for data channels. 

### Protocol Description

SCTP is a connection-oriented protocol using a four way handshake to establish
an SCTP association, and a three way message exchange to gracefully shut it
down. It uses the same port number concept as DCCP, TCP, UDP, and UDP-Lite.
SCTP only supports unicast.

SCTP uses the 32-bit CRC32c for protecting SCTP packets against bit errors and
misdelivery of packets to an unintended endpoint. This is stronger than the 16-bit
checksums used by TCP or UDP. However, partial payload checksum coverage as
provided by DCCP or UDP-Lite is not supported.

SCTP has been designed with extensibility in mind. <!--Each SCTP packet starts
with a single common header containing the port numbers, a verification tag
and the CRC32c checksum. This--> A common header is followed by a sequence of
chunks. <!--Each chunk consists of a type field, flags, a length field and a
value.--> {{RFC4960}} defines how a receiver processes chunks with an unknown
chunk type. The support of extensions can be negotiated during the SCTP
handshake. Currently defined extensions include mechanisms for
dynamic re-configuration of streams {{RFC6525}} and IP addresses
{{RFC5061}}. Furthermore, the extension specified in {{RFC3758}} introduces
the concept of partial reliability for user messages.

SCTP provides a message-oriented service. Multiple small user messages can be
bundled into a single SCTP packet to improve efficiency. For example, this
bundling may be done by delaying user messages at the sender, similar to
Nagle's algorithm used by TCP. User messages which would result in IP packets
larger than the MTU will be fragmented at the sender and reassembled at the
receiver. There is no protocol limit on the user message size. <!--ICMP-based path
MTU discovery is specified for IPv4 in {{RFC1191}} and for IPv6 in {{RFC1981}},
as well as packetization layer path MTU discovery, specified in {{RFC4821}},-->
For MTU discovery the same meachnism than for TCP can be used {{RFC1981, RFC4821}},
as well as utilising probe packets with padding chunks, as defined in {{RFC4820}}.

{{RFC4960}} specifies TCP-friendly congestion control to protect the network
against overload. SCTP also uses sliding
window flow control to protect receivers against overflow. Similar to TCP,
SCTP also supports delaying acknowledgments. {{RFC7053}} provides a way for
the sender of user messages to request the immediate sending of the
corresponding acknowledgments.

Each SCTP association has between 1 and 65536 uni-directional streams in each
direction. The number of streams can be different in each direction. Every
user message is sent on a particular stream. User messages can be sent un-ordered, 
or ordered upon request by the upper layer. Un-ordered messages can be
delivered as soon as they are completely received. Ordered messages sent on
the same stream are delivered at the receiver in the same order as sent by the
sender. For user messages not requiring fragmentation, this minimizes head of
line blocking.

The base protocol defined in {{RFC4960}} does not allow interleaving of user-
messages. Large messages on one stream can therefore block the sending of user
messages on other streams. {{I-D.ietf-tsvwg-sctp-ndata}} overcomes this
limitation. This draft also specifies multiple algorithms for the sender side
selection of which streams to send data from, supporting a variety of
scheduling algorithms including priority based methods. The stream re-
configuration extension defined in {{RFC6525}} allows streams to be reset
during the lifetime of an association and to increase the number of streams,
if the number of streams negotiated in the SCTP handshake becomes
insufficient.

Each user message sent is either delivered to
the receiver or, in case of excessive retransmissions, the association is
terminated in a non-graceful way {{RFC4960}}, similar to TCP behaviour.
In addition to this reliable transfer, the partial reliability extension
{{RFC3758}} allows a sender to abandon user messages.
The application can specify the policy for abandoning user messages.

SCTP supports multi-homing. Each SCTP endpoint uses a list of IP-addresses and
a single port number. These addresses can be any mixture of IPv4 and IPv6
addresses. These addresses are negotiated during the handshake and the address
re-configuration extension specified in {{RFC5061}} in combination with
{{RFC4895}} can be used to change these addresses in an authenticated way
during the livetime of an SCTP association. This allows for transport layer
mobility. Multiple addresses are used for improved resilience. If a remote
address becomes unreachable, the traffic is switched over to a reachable one,
if one exists. <!--{{I-D.ietf-tsvwg-sctp-failover}} specifies a quicker failover
operation reducing the latency of the failover.-->

For securing user messages, the use of TLS over SCTP has been specified in
{{RFC3436}}. However, this solution does not support all services provided
by SCTP, such as un-ordered delivery or partial reliability. Therefore,
the use of DTLS over SCTP has been specified in {{RFC6083}} to overcome these
limitations. When using DTLS over SCTP, the application can use almost all
services provided by SCTP.

{{I-D.ietf-tsvwg-natsupp}} defines methods for endpoints and
middleboxes to provide NAT traversal for SCTP over IPv4.
For legacy NAT traversal, {{RFC6951}} defines the UDP encapsulation of
SCTP-packets. Alternatively, SCTP packets can be encapsulated in DTLS packets
as specified in {{I-D.ietf-tsvwg-sctp-dtls-encaps}}. The latter encapsulation
is used within the WebRTC context.

SCTP has a well-defined API, described in the next subsection.

### Interface Description

{{RFC4960}} defines an abstract API for the base protocol.
This API describes the following functions callable by the upper layer of SCTP:
Initialize, Associate, Send, Receive, Receive Unsent Message,
Receive Unacknowledged Message, Shutdown, Abort, SetPrimary, Status,
Change Heartbeat, Request Heartbeat, Get SRTT Report, Set Failure Threshold,
Set Protocol Parameters, and Destroy.
The following notifications are provided by the SCTP stack to the upper layer:
COMMUNICATION UP, DATA ARRIVE, SHUTDOWN COMPLETE, COMMUNICATION LOST,
COMMUNICATION ERROR, RESTART, SEND FAILURE, NETWORK STATUS CHANGE.

An extension to the BSD Sockets API is defined in {{RFC6458}} and covers:

- the base protocol defined in {{RFC4960}}. The API allows control over
  local addresses and port numbers and the primary path. Furthermore
  the application has fine control about parameters like retransmission
  thresholds, the path supervision parameters, the delayed acknowledgment
  timeout, and the fragmentation point. The API provides a mechanism
  to allow the SCTP stack to notify the application about events if the
  application has requested them. These notifications provide information
  about status changes of the association and each of the peer addresses.
  In case of send failures, including drop of messages sent unreliably, 
  the application can also be notified and user
  messages can be returned to the application. When sending user messages,
  the stream id, a payload protocol identifier, an indication whether ordered
  delivery is requested or not. These parameters can also be provided on
  message reception. Additionally a context can be provided when sending,
  which can be use in case of send failures. The sending of arbitrary large
  user messages is supported.

- the SCTP Partial Reliability extension defined in {{RFC3758}} to specify
  for a user message the PR-SCTP policy and the policy specific parameter.
  Examples of these policies defined in {{RFC3758}} and {{RFC7496}} are:
  - Limiting the time a user message is dealt with by the sender.
  - Limiting the number of retransmissions for each fragment of a user message.
    If the number of retransmissions is limited to 0, one gets a service similar
    to UDP.
  - Abandoning messages of lower priority in case of a send buffer shortage.

- the SCTP Authentication extension defined in {{RFC4895}} allowing to manage
  the shared keys, the HMAC to use, set the chunk types which are only accepted
  in an authenticated way, and get the list of chunks which are accepted by the
  local and remote end point in an authenticated way.

- the SCTP Dynamic Address Reconfiguration extension defined in {{RFC5061}}.
  It allows to manually add and delete local addresses for SCTP associations
  and the enabling of automatic address addition and deletion. Furthermore
  the peer can be given a hint for choosing its primary path.


For the following SCTP protocol extensions the BSD Sockets API extension is
defined in the document specifying the protocol extensions:

- the SCTP Stream Reconfiguration extension defined in {{RFC6525}}.
  The API allows to trigger the reset operation for incoming and
  outgoing streams and the whole association. It provides also a way
  to notify the association about the corresponding events. Furthermore
  the application can increase the number of streams.
- the UDP Encapsulation of SCTP packets extension defined in {{RFC6951}}.
  The API allows the management of the remote UDP encapsulation port.
- the SCTP SACK-IMMEDIATELY extension defined in {{RFC7053}}.
  The API allows the sender of a user message to request the receiver to
  send the corresponding acknowledgment immediately.
- the additional PR-SCTP policies defined in {{RFC7496}}.
  The API allows to enable/disable the PR-SCTP extension,
  choose the PR-SCTP policies defined in the document and provide statistical
  information about abandoned messages.

Future documents describing SCTP protocol extensions are expected to describe
the corresponding BSD Sockets API extension in a `Socket API Considerations`
section.

The SCTP socket API supports two kinds of sockets:

- one-to-one style sockets (by using the socket type `SOCK_STREAM`).
- one-to-many style socket (by using the socket type `SOCK_SEQPACKET`).

One-to-one style sockets are similar to TCP sockets, there is a 1:1 relationship
between the sockets and the SCTP associations (except for listening sockets).
One-to-many style SCTP sockets are similar to unconnected UDP sockets, where there
is a 1:n relationship between the sockets and the SCTP associations.

The SCTP stack can provide information to the applications about state
changes of the individual paths and the association whenever they occur.
These events are delivered similar to user messages but are specifically
marked as notifications.

New functions have been introduced to support the use of
multiple local and remote addresses.
Additional SCTP-specific send and receive calls have been defined to permit
SCTP-specific information to be sent without using ancillary data
in the form of additional cmsgs.
These functions provide support for detecting partial delivery of
user messages and notifications.

The SCTP socket API allows a fine-grained control of the protocol behaviour
through an extensive set of socket options.

The SCTP kernel implementations of FreeBSD, Linux and Solaris follow mostly
the specified extension to the BSD Sockets API for the base protocol and the
corresponding supported protocol extensions.

### Transport Features

The transport features provided by SCTP are:

- unicast transport,
- connection setup with feature negotiation and application-to-port mapping,
- port multiplexing,
- uni-or bidirectional communication,
- message-oriented delivery supporting multiple concurrent streams,
- fully reliable, partially reliable, or unreliable delivery (based on user specified policy to handle abandoned user messages) with drop notification, <!-- Editors note: is this a separate feature?-->
- ordered and unordered delivery within a stream,
- user message fragmentation and reassembly, <!-- Editors note: Do we call this segementation and aggregation?-->
- support for stream scheduling prioritization,
- user message bundling,
- flow control using a window-based mechanism,
- congestion control using methods similar to TCP,
- strong error/misdelivery detection (CRC32c),
- transport layer multihoming for resilience and mobility, <!-- Editors note: is this a separate feature?-->
- transport layer mobility,
- resilience to network failure and/or handover.


## User Datagram Protocol (UDP)

The User Datagram Protocol (UDP) {{RFC0768}} {{RFC2460}} is an IETF standards
track transport protocol. It provides a unidirectional datagram protocol that
preserves message boundaries. It provides  no error correction, congestion
control, or flow control. It can be used to send  broadcast datagrams (IPv4)
or multicast datagrams (IPv4 and IPv6), in addition to unicast and anycast
datagrams. IETF guidance on the use of UDP is provided in 
{{I-D.ietf-tsvwg-rfc5405bis}}. UDP is widely implemented and widely used by 
common applications, including DNS.

### Protocol Description

UDP is a connection-less protocol that maintains message boundaries, with no
connection setup or feature negotiation. The protocol uses independent
messages, ordinarily called datagrams. <!--Each stream of messages is
independently managed, therefore a retransmission does not hold back data sent
using other logical streams.--> It provides detection of payload errors and
misdelivery of packets to an unintended endpoint, either of which result in
discard of received datagrams, with no indication to the user of the service.

It is possible to create IPv4 UDP datagrams with no checksum, and while this
is generally discouraged {{RFC1122}} {{I-D.ietf-tsvwg-rfc5405bis}}, certain
special cases permit this use. These datagrams rely on the IPv4 header checksum
to protect from misdelivery to an unintended endpoint. IPv6 does not permit UDP
datagrams with no checksum, although in certain cases this rule may be relaxed
{{RFC6935}}. <!-- The checksum support considerations for omitting the checksum are
defined in {{RFC6936}}. -->

UDP does not provide reliability and does not provide retransmission. This
implies messages may be re-ordered, lost, or duplicated in transit.
Note that due to the relatively weak form of checksum
used by UDP, applications that require end to end integrity of data are
recommended to include a stronger integrity check of their payload data.

Because UDP provides no flow control, a receiving application that is unable
to run sufficiently fast, or frequently, may miss messages. The lack of
congestion handling implies UDP traffic may experience loss when using an
overloaded path, and may cause the loss of messages from other protocols
(e.g., TCP) when sharing the same network path.

On transmission, UDP encapsulates each datagram into 
a single IP packet or several IP packet fragments. This
allows a datagram to be larger than the effective path MTU.
Fragments are reassembled before delivery to the UDP receiver,
making this transparent to the user of the transport service.
When the jumbograms are supported, larger messages may be sent without 
performing fragmentation.

Applications that need to provide
fragmentation or that have other requirements such as receiver flow
control, congestion control, PathMTU discovery/PLPMTUD, support for
ECN, etc. need these to be provided by protocols operating over UDP 
{{I-D.ietf-tsvwg-rfc5405bis}}.

### Interface Description

{{RFC0768}} describes basic requirements for an API for UDP.
Guidance on use of common APIs is provided in {{I-D.ietf-tsvwg-rfc5405bis}}.

A UDP endpoint consists of a tuple of (IP address, port number).
Demultiplexing using multiple abstract endpoints (sockets) on the
same IP address is supported. The same socket may be used by a
single server to interact with multiple clients (note: this behavior
differs from TCP, which uses a pair of tuples to identify a
connection). Multiple server instances (processes) that bind to the same
socket can cooperate to service multiple clients. The socket
implementation arranges to not duplicate the same received unicast
message to multiple server processes.

Many operating systems also allow a UDP socket to be "connected",
i.e., to bind a UDP socket to a specific (remote) UDP endpoint.
Unlike TCP's connect primitive, for UDP, this is only a local
operation that serves to simplify the local send/receive functions
and to filter the traffic for the specified addresses and ports
{{I-D.ietf-tsvwg-rfc5405bis}}.

### Transport Features

The transport features provided by UDP are:

- unicast, multicast, anycast, or IPv4 broadcast,
- port multiplexing (where a receiving port can be configured to receive datagrams from multiple senders),
- message-oriented delivery,
- uni- or bidirectional communication where the transmissions in each direction are independent,
- non-reliable delivery,
- unordered delivery,
- error detection (implemented using a segment checksum to verify delivery to the correct endpoint and integrity of the data; optional for IPv4 and optional under specific conditions for IPv6 where all or none of the payload data is protected),


## Lightweight User Datagram Protocol (UDP-Lite)

The Lightweight User Datagram Protocol (UDP-Lite) {{RFC3828}} is an IETF
standards track transport protocol. It provides a unidirectional, datagram
protocol that preserves message boundaries. IETF guidance on the use of UDP-
Lite is provided in {{I-D.ietf-tsvwg-rfc5405bis}}. A UDP-Lite service may support 
IPv4 broadcast, multicast, anycast and
unicast, and IPv6 multicast, anycast and unicast.

Examples of use include a class of applications that can derive benefit from
having partially-damaged payloads delivered, rather than discarded. One use is
to support error tolerate payload corruption when used over paths that include
error-prone links, another application is when header integrity checks are
required, but payload integrity is provided by some other mechanism (e.g.,
{{RFC6936}}).

### Protocol Description

Like UDP, UDP-Lite is a connection-less datagram protocol, with no connection
setup or feature negotiation. It changes the semantics of the UDP "payload
length" field to that of a "checksum coverage length" field, and is identified
by a different IP protocol/next-header value. The "checksum coverage length" field
specifies the intended checksum coverage, with the remaining
unprotected part of the payload called the "error-insensitive part". 
Applications using UDP-Lite therefore cannot
make assumptions regarding the correctness of the data received in the
insensitive part of the UDP-Lite payload.

Otherwise, UDP-Lite is semantically identical to UDP. 
In the same way as for UDP, mechanisms for receiver flow control, congestion control, PMTU or
PLPMTU discovery, support for ECN, etc. needs to be provided by upper layer
protocols {{I-D.ietf-tsvwg-rfc5405bis}}.


### Interface Description

There is no API currently specified in the RFC Series, but guidance on
use of common APIs is provided in {{I-D.ietf-tsvwg-rfc5405bis}}.

The interface of UDP-Lite differs
from that of UDP by the addition of a single (socket) option that
communicates a checksum coverage length value.
The checksum coverage may also be made visible to the application
via the UDP-Lite MIB module {{RFC5097}}.

### Transport Features

The transport features provided by UDP-Lite are:

- unicast, multicast, anycast, or IPv4 broadcast (as for UDP),
- port multiplexing (as for UDP),
- message-oriented delivery (as for UDP),
- Uui-or bidirectional communication where the transmissions in each direction are independent (as for UDP),
- non-reliable delivery (as for UDP),
- non-ordered delivery (as for UDP),
<!-- - mis-delivery detection (the checksum always provides protection from mis-delivery),  editors note: is this an own feature? If yes, change everywhere incl. section 5 -->
- partial or full payload protection (where the checksum coverage field indicates the size of the payload data covered by the checksum).

## Datagram Congestion Control Protocol (DCCP)

Datagram Congestion Control Protocol (DCCP) {{RFC4340}} is an
IETF standards track
bidirectional transport protocol that provides unicast connections of
congestion-controlled messages without providing reliability.

The DCCP Problem Statement describes the goals that
DCCP sought to address {{RFC4336}}: It is suitable for
applications that transfer fairly large amounts of data and that can
benefit from control over the trade off between timeliness and
reliability {{RFC4336}}.

DCCP offers low overhead, and many characteristics
common to UDP, but can avoid "re-inventing the wheel"
each time a new multimedia application emerges.
Specifically it includes core transport functions (feature
negotiation, path state management, RTT calculation,
PMTUD, etc.): DCCP applications select how they send packets
and, where suitable, choose common algorithms to
manage their functions.
Examples of applications that can benefit from such transport services
include interactive applications,
streaming media, or on-line games {{RFC4336}}.


### Protocol Description

DCCP is a connection-oriented datagram protocol, providing a three-way
handshake to allow a client and server to set up a connection,
and mechanisms for orderly completion and immediate teardown of
a connection.

A DCCP protocol instance can be extended {{RFC4340}} and tuned using
additional features. Some features are sender-side only, requiring no
negotiation with the receiver; some are receiver-side only; and some are
explicitly negotiated during connection setup.

DCCP uses a Connect packet to initiate a session, and permits each endpoint 
to choose the features it wishes to support.
Simultaneous open {{RFC5596}}, as in TCP, can enable interoperability in the
presence of middleboxes. The Connect packet includes a Service Code
{{RFC5595}} that identifies the application or
protocol using DCCP, providing middleboxes with information about the
intended use of a connection.

DCCP service is unicast-only.

It provides multiplexing to multiple sockets at each endpoint using
port numbers. An active DCCP session is identified by its four-tuple
of local and remote IP addresses and local port and remote port numbers.

The protocol segments data into messages, typically sized to
fit in IP packets, but which may be fragmented providing they
are smaller than the maximum packet size.
A DCCP interface allows applications to
request fragmentation for packets larger than PMTU, but not
larger than the maximum packet size allowed by the current
congestion control mechanism (CCMPS) {{RFC4340}}.

Each message is identified by a sequence number. The sequence number is used
to identify segments in acknowledgments, to detect unacknowledged segments, to
measure RTT, etc. The protocol may support unordered delivery of
data, and does not itself provide retransmission. DCCP supports reduced
checksum coverage, a partial payload protection mechanism similar to UDP-Lite. There
is also a Data Checksum option, which when enabled, contains a strong CRC, to
enable endpoints to detect application data corruption.

Receiver flow control is supported, which limits the amount of unacknowledged
data that can be outstanding at a given time.

DCCP supports negotiation of the congestion control profile between endpoints, 
<!-- editors note: with other endpoint?-->
to provide plug-and-play congestion control mechanisms. 
Examples of specified profiles include
"TCP-like" {{RFC4341}}, "TCP-friendly" {{RFC4342}}, and "TCP-friendly for
small packets" {{RFC5622}}. Additional mechanisms are recorded in an IANA
registry.

A lightweight UDP-based encapsulation (DCCP-UDP) has been defined {{RFC6773}}
that permits DCCP to be used over paths where DCCP is not natively supported.
Support for DCCP in NAPT/NATs is defined in {{RFC4340}} and {{RFC5595}}.
Upper layer protocols specified on top of DCCP include DTLS {{RFC5595}}, RTP
{{RFC5672}}, ICE/SDP {{RFC6773}}.

<!--A common packet format has allowed tools to evolve that can
read and interpret DCCP packets (e.g., Wireshark).-->

### Interface Description

API characteristics include:

- datagram transmission,
- notification of the current maximum packet size,
- send and reception of zero-length payloads,
- slow receiver flow control at a receiver,
- ability to detect a slow receiver at the sender.

<!-- editors note: what about the cc nego and the service code?-->

There is no API currently specified in the RFC Series.

### Transport Features

The transport features provided by DCCP are:

- unicast transport,
- connection setup with feature negotiation and application-to-port mapping,
- siganling of application class for middlebox support (implemented using Service Codes), <!-- editor note: is this a feature?-->
- port multiplexing,
- uni-or bidirectional communication,
- message-oriented delivery,
- unreliable delivery with drop notification, <!--Allows a receiver to notify which datagrams were not delivered to the peer upper layer protocol.-->
   <!-- editors note: drop notification is not an own feature, is it?-->
<!-- - timestamps. --><!-- editors note: is this a feature?-->
- unordered delivery,
- flow control (implemented using the slow receiver function)
- partial and full payload protection (with optional strong integrity check).

## Internet Control Message Protocol (ICMP)

The Internet Control Message Protocol (ICMP) [RFC0792] for IPv4 and
ICMP for IPv6 [RFC4433] are IETF standardss track protocols.
It is a connection-less unidirectional protocol that delivers individual
messages, without error correction, congestion control, or flow control. 
Messages may be sent as unicast, IPv4 broadcast or multicast datagrams
(IPv4 and IPv6), in addition to anycast datagrams.

Transport Protocols and upper layer protocols can use received ICMP messages to help
them take appropriate decisions when network or endpoint errors are reported.
For example, to implement, ICMP-based Path MTU discovery {{RFC1191}}{{RFC1981}}
or assist in Packetization Layer Path MTU Discovery (PMTUD) {{RFC4821}}. Such
reactions to received messages need to protect from off-path data injection
{{I-D.ietf-tsvwg-rfc5405bis}}, to avoid an application receiving packets created 
by an unauthorized third party. An application therefore needs to
ensure that all messages are appropriately validated, by checking the payload
of the messages to ensure these are received in response to actually
transmitted traffic (e.g., a reported error condition that corresponds to a
UDP datagram or TCP segment was actually sent by the application). This
requires context {{RFC6056}}, such as local state about communication
instances to each destination (e.g., in the TCP, DCCP, or SCTP protocols).
This state is not always maintained by UDP-based applications {{I-D.ietf-tsvwg-rfc5405bis}}.

### Protocol Description

ICMP is a connection-less unidirectional protocol, It delivers independent messages, 
called datagrams.
Each message is required to carry a checksum as an integrity check and to
protect from mis-delivery to an unintended endpoint.

ICMP messages typically relay diagnostic information from an endpoint
{{RFC1122}} or network device {{RFC1716}} addressed to the sender of a flow.
This usually contains the network protocol header of a packet that encountered
a reported issue. Some formats of messages can also carry other payload
data. Each message carries an integrity check calculated in the same way as
for UDP, this checksum is not optional.

The RFC series defines additional IPv6 message formats to support a range of uses.
In the case of IPv6 the protocol incorporates neighbor discovery {{RFC2461}} {{RFC3971}}}
(provided by ARP for IPv4) and the Multicast Listener
Discovery (MLD) {{RFC2710}} group management functions (provided by IGMP for IPv4).

Reliable transmission can not be assumed. A receiving application that is
unable to run sufficiently fast, or frequently, may miss messages since there
is no flow or congestion control. In addition some network devices rate-limit
ICMP messages.

### Interface Description

ICMP processing is integrated in many connection-oriented transports,
but like other functions needs to be provided by an upper-layer protocol
when using UDP and UDP-Lite.

On some stacks, a bound socket also allows a UDP application to be notified
when ICMP error messages are received for its transmissions
{{I-D.ietf-tsvwg-rfc5405bis}}.

Any response to ICMP error messages ought to be robust to temporary
routing failures (sometimes called "soft errors"), e.g., transient ICMP
"unreachable" messages ought to not normally cause a communication abort
{{RFC5461}} {{I-D.ietf-tsvwg-rfc5405bis}}.

### Transport Features

<!-- editors note: Isn't this just one feature ('handling  of control and measurement data')? 
 Does the ICMP section need to follow the same structure than other protocol sections?-->

The transport features provided by ICMP are:

- unidirectional transmission of control and measurement data,
- multicast, anycast and IP4 broadcast  of control and measurement data,
- message-oriented delivery of control and measurement data,
- non-reliable delivery of control and measurement data,
- non-ordered delivery of control and measurement data,
- error and mis-delivery detection of control and measurement data (checksum, as in UDP).


## Realtime Transport Protocol (RTP)

RTP provides an end-to-end network transport service, suitable for
applications transmitting real-time data, such as audio, video or
data, over multicast or unicast transport services, including TCP, UDP,
UDP-Lite, DCCP, TLS and DTLS.

### Protocol Description

The RTP standard {{RFC3550}} defines a pair of protocols, RTP and 
the RTP control protocol, RTCP. The transport does not provide connection setup,
instead relying on out-of-band techniques or associated control protocols to
setup, negotiate parameters or tear down a session.

An RTP sender encapsulates audio/video data into RTP packets to transport
media streams. The RFC-series specifies RTP payload formats that allow packets to
carry a wide range of media, and specifies a wide range of multiplexing, error
control and other support mechanisms.

If a frame of media data is large, it will be fragmented into several RTP
packets. Likewise, several small frames may be bundled into a single RTP packet.

An RTP receiver collects RTP packets from the network, validates them for
correctness, and sends them to the media decoder input-queue. Missing packet
detection is performed by the channel decoder. The play-out buffer is ordered
by time stamp and is used to reorder packets. Damaged frames may be repaired
before the media payloads are decompressed to display or store the data.
Some uses of RTP are able to exploit the partial payload protection features
offered by DCCP and UDP-Lite.

RTCP is a control protocol that works alongside an RTP flow. Both the RTP
sender and receiver will send RTCP report packets. This is used to periodically
send control information and report performance. Based on received RTCP
feedback, an RTP sender can adjust the transmission, e.g., perform rate
adaptation at the application layer in the case of congestion.

An RTCP receiver report (RTCP RR) is returned to the sender
periodically to report key parameters (e.g, the fraction of packets
lost in the last reporting interval, the cumulative number of
packets lost, the highest sequence number received, and the
inter-arrival jitter). The RTCP RR packets also contain timing
information that allows the sender to estimate the network
round trip time (RTT) to the receivers.

The interval between reports sent from each receiver tends
to be on the order of a few seconds on average, although
this varies with the session rate, and sub-second reporting
intervals are possible for high rate sessions.
The interval is randomized to avoid synchronization of
reports from multiple receivers.

### Interface Description

There is no standard application programming interface defined for RTP or
RTCP. Implementations are typically tightly integrated with a particular
application, and closely follow the principles of application level framing
and integrated layer processing {{ClarkArch}} in media processing {{RFC2736}},
error recovery and concealment, rate adaptation, and security {{RFC7202}}.
Accordingly, RTP implementations tend to be targeted at particular application
domains (e.g., voice-over-IP, IPTV, or video conferencing), with a feature set
optimised for that domain, rather than being general purpose implementations
of the protocol.

### Transport Features

The transport features provided by RTP are:

- unicast, multicast or IPv4 broadcast (provided by lower layer protocol),
- port multiplexing (provided by lower layer protocol),
- uni- or bidirectional communication (provided by lower layer protocol),
- message-oriented delivery with support for media types and other extensions,
- reliable delivery when using erasure coding or unreliable delivery with drop notification (if supported by lower layer protocol),
- connection setup with feature negotiation (using associated protocols) and application-to-port mapping (provided by lower layer protocol),
- segmentation and aggregation,
- performance reporting (using associated protocols).<!-- editors note: is this an own feature or is this part of something else? If it is an own feature, is this the right name?-->
<!-- - timestamps. --><!-- editors note: is this a feature?-->


## File Delivery over Unidirectional Transport/Asynchronous Layered Coding Reliable Multicast (FLUTE/ALC)

FLUTE/ALC is an IETF standards track protocol specified in {{RFC6726}}
and {{RFC5775}}. It provides object-oriented delivery of discrete data 
or files.
Asynchronous Layer Coding (ALC) provides an underlying
reliable transport service and FLUTE a file-oriented specialization
of the ALC service (e.g., to carry associated metadata). The
{{RFC6726}} and {{RFC5775}} protocols are non-backward-compatible updates
of the {{RFC3926}} and {{RFC3450}} experimental protocols; these
experimental protocols are currently largely deployed in the 3GPP
Multimedia Broadcast and Multicast Services (MBMS) (see {{MBMS}},
section 7) and similar contexts (e.g., the Japanese ISDB-Tmm standard).

The FLUTE/ALC protocol has been designed to support massively scalable
reliable bulk data dissemination to receiver groups of arbitrary size using IP
Multicast over any type of delivery network, including unidirectional networks
(e.g., broadcast wireless channels). However, the FLUTE/ALC protocol also
supports point-to-point unicast transmissions.

FLUTE/ALC bulk data
dissemination has been designed for discrete file or memory-based "objects".
<!-- Transmissions happen either in push mode, where content is sent once, or in
on-demand mode, where content is continuously sent during periods of time that
can largely exceed the average time required to download the session objects
(see {{RFC5651}}, section 4.2).-->

Although FLUTE/ALC is not well adapted to byte- and message-streaming, there is
an exception: FLUTE/ALC is used to carry 3GPP Dynamic Adaptive Streaming over
HTTP (DASH) when scalability is a requirement (see {{MBMS}}, section 5.6).
<!-- In that case, each Audio/Video segment is transmitted as a distinct FLUTE/ALC
object in push mode.-->

<!-- FLUTE/ALC uses packet erasure coding (also
known as Application-Level Forward Erasure Correction, or AL-FEC) in a
proactive way. The goal of using AL-FEC is both to increase the robustness in
front of packet erasures and to improve the efficiency of the on-demand
service. FLUTE/ALC transmissions can be governed by a congestion control
mechanism such as the "Wave and Equation Based Rate Control" (WEBRC) {{RFC3738}}
when FLUTE/ALC is used in a layered transmission manner, with several session
channels over which ALC packets are sent. However, many FLUTE/ALC deployments
target pre-provisioned networks and
involve only Constant Bit Rate (CBR) channels with no competing flows, for
which a sender-based rate control mechanism is sufficient. In any case,-->
FLUTE/ALC's reliability, delivery mode, congestion control, and flow/rate
control mechanisms can be separately controlled
to meet different application needs. Section 4.1 of {{I-D.ietf-tsvwg-rfc5405bis}}
describes multicast congestion control requirements for UDP.

### Protocol Description

The FLUTE/ALC protocol works on top of UDP (though it could work on top of any
datagram delivery transport protocol), without requiring any connectivity from
receivers to the sender. Purely unidirectional networks are therefore
supported by FLUTE/ALC. This guarantees scalability to an
unlimited number of receivers in a session, since
the sender behaves exactly the same regardless of the number of receivers.

FLUTE/ALC supports the transfer of bulk objects such as file or in-memory
content, using either a push or an on-demand mode. in push mode, content is
sent once to the receivers, while in on-demand mode, content is sent
continuously during periods of time that can greatly exceed the average time
required to download the session objects (see {{RFC5651}}, section 4.2).

This enables receivers to join a session asynchronously, at their own
discretion, receive the content and leave the session.  In this case, data
content is typically sent continuously, in loops (also known as "carousels").
FLUTE/ALC also supports the
transfer of an object stream, with loose real-time constraints. This is
particularly useful to carry 3GPP DASH when scalability is a requirement and
unicast transmissions over HTTP cannot be used ({{MBMS}}, section 5.6).  In
this case, packets are sent in sequence using push mode. FLUTE/ALC is
not well adapted to byte- and message-streaming and other solutions could be
preferred (e.g., FECFRAME {{RFC6363}} with real-time flows).

The FLUTE file delivery instantiation of ALC provides a metadata delivery
service. Each object of the FLUTE/ALC session is described in a dedicated
entry of a File Delivery Table (FDT), using an XML format (see {{RFC6726}},
section 3.2).  This metadata can include, but is not restricted to, a URI
attribute (to identify and locate the object), a media type attribute, a size
attribute, an encoding attribute, or a message digest attribute. Since the
set of objects sent within a session can be dynamic, with new objects being
added and old ones removed, several instances of the FDT can be sent and a
mechanism is provided to identify a new FDT Instance.

Error detection and verification of the protocol
control information relies on the on the underlying transport (e.g., UDP checksum).

To provide robustness against packet loss and improve the
efficiency of the on-demand mode, FLUTE/ALC relies on packet erasure
coding (AL-FEC). AL-FEC encoding is proactive (since
there is no feedback and therefore no (N)ACK-based retransmission) and ALC
packets containing repair data are sent along with ALC packets containing
source data. Several FEC Schemes have been standardized; FLUTE/ALC does
not mandate the use of any particular one.  Several strategies concerning the
transmission order of ALC source and repair packets are possible, in
particular in on-demand mode where it can deeply impact the service provided
(e.g., to favor the recovery of objects in sequence, or at the other extreme,
to favor the recovery of all objects in parallel), and FLUTE/ALC does not
mandate nor recommend the use of any particular one.

A FLUTE/ALC session is composed of one or more channels, associated to
different destination unicast and/or multicast IP addresses.  ALC packets are
sent in those channels at a certain transmission rate, with a rate that often
differs depending on the channel.  FLUTE/ALC does not mandate nor recommend
any strategy to select which ALC packet to send on which channel.  FLUTE/ALC
can use a multiple rate congestion control building block (e.g., WEBRC) to
provide congestion control that is feedback free, where receivers adjust their
reception rates individually by joining and leaving channels associated with
the session.  To that purpose, the ALC header provides a specific field to
carry congestion control specific information.  However FLUTE/ALC does not
mandate the use of a particular congestion control mechanism although WEBRC is
mandatory to support for the Internet ({{RFC6726}}, section 1.1.4).
FLUTE/ALC is often used over a network path with pre-provisioned capacity
{{I-D.ietf-tsvwg-rfc5405bis}} where there are no flows competing for
capacity. In this
case, a sender-based rate control mechanism and a single channel is
sufficient.

{{RFC6584}} provides per-packet authentication, integrity, and anti-replay
protection in the context of the ALC and NORM protocols.  Several mechanisms are
proposed that seamlessly integrate into these protocols using the ALC and
NORM header extension mechanisms.

### Interface Description

The FLUTE/ALC specification does not describe a specific application
programming interface (API) to control protocol operation.

Open source reference implementations of FLUTE/ALC are available at
http://planete-bcast.inrialpes.fr/ (no longer maintained) and
http://mad.cs.tut.fi/ (no longer maintained), and these implementations
specify and document their own APIs.  Commercial versions are also available,
some derived from the above implementations, with their own API.

### Transport Features

The transport features provided by FLUTE/ALC are:

- unicast, multicast, anycast or IPv4 broadcast,
- object-oriented delivery of discrete data or files,
- per-object dynamic meta-data delivery, <!-- editors note: is this similar to performance reporting in RTP...?-->
- push delivery or on-demand delivery service,
- fully reliable or partially reliable delivery (of file or in-memory objects),
- ordered or unordered delivery (of file or in-memory objects),
- per-packet authentication, integrity, and anti-replay services, <!-- editors note: are these 3 features?-->
- proactive packet erasure coding (AL-FEC) to recover from packet erasures and improve the on-demand delivery service, <!--editors note: how is this related to reliability as listed above?-->
- error detection (relies on UDP checksum), <!-- editors note: What the difference to 'integrity' listed above?-->
- congestion control for layered flows (e.g., with WEBRC).

## NACK-Oriented Reliable Multicast (NORM)

NORM is an IETF standards track protocol specified in {{RFC5740}}. 
It provides object-oriented delivery of discrete data or files.

The protocol was designed to support reliable bulk data dissemination to receiver
groups using IP Multicast but also provides for point-to-point unicast
operation.  Support for bulk data dissemination includes discrete file or
computer memory-based "objects" as well as byte- and message-streaming. 

NORM can incorporate packet erasure coding as a part of its
selective ARQ in response to negative acknowledgments from the receiver. The packet
erasure coding can also be proactively applied for forward protection from
packet loss. NORM transmissions are governed by the TCP-friendly congestion
control. The reliability, congestion control and flow control mechanisms
can be separately controlled to meet different application needs.

### Protocol Description

The NORM protocol is encapsulated in UDP datagrams and thus provides
multiplexing for multiple sockets on hosts using port numbers. For loosely
coordinated IP Multicast, NORM is not strictly connection-oriented although
per-sender state is maintained by receivers for protocol operation.
{{RFC5740}} does not specify a handshake protocol for connection establishment.
Separate session initiation can be used to coordinate port numbers.
However, in-band "client-server" style connection establishment can be
accomplished with the NORM congestion control signaling messages using port
binding techniques like those for TCP client-server connections.

NORM supports bulk "objects" such as file or in-memory content but also can
treat a stream of data as a logical bulk object for purposes of packet erasure
coding. In the case of stream transport, NORM can support either byte streams
or message streams where application-defined message boundary information is
carried in the NORM protocol messages. This allows the receiver(s) to 
join/re-join and recover message boundaries mid-stream as needed. Application 
content is carried and identified by the NORM protocol with encoding symbol
identifiers depending upon the Forward Error Correction (FEC) Scheme
{{RFC3452}} configured. NORM uses NACK-based selective ARQ to reliably deliver
the application content to the receiver(s). NORM proactively measures round-trip 
timing information to scale ARQ timers appropriately and to support
congestion control. For multicast operation, timer-based feedback suppression
is uses to achieve group size scaling with low feedback traffic levels. The
feedback suppression is not applied for unicast operation.

NORM uses rate-based congestion control based upon the TCP-Friendly Rate
Control (TFRC) {{RFC4324}} principles that are also used in DCCP {{RFC4340}}.
NORM uses control messages to measure RTT and collect congestion event 
information (e.g., reflecting a
loss event or ECN event) from the receiver(s) to support
dynamic adjustment or the rate. The TCP-Friendly Multicast Congestion Control
(TFMCC) {{RFC4654}} provides extra features to support multicast, but
is functionally equivalent to TFRC for unicast.

Error detection and verification of the protocol
control information relies on the on the underlying transport(e.g., UDP checksum).

The reliability mechanism is decoupled from congestion control. This allows
invocation of alternative arrangements of transport services. For example,
to support,
fixed-rate reliable delivery or unreliable delivery (that may optionally
be "better than best effort" via packet erasure coding) using TFRC. 
Alternative congestion control
techniques may be applied. For example, TFRC rate control with congestion
event detection based on ECN.

While NORM provides NACK-based reliability, it also supports a positive
acknowledgment (ACK) mechanism that can be used for receiver flow control.
This mechanism is decoupled from the reliability and congestion
control, supporting applications with different needs. One example is 
use of NORM for quasi-reliable
delivery, where timely delivery of newer content may be favored over completely
reliable delivery of older content within buffering and RTT constraints.

### Interface Description

The NORM specification does not describe a specific application programming
interface (API) to control protocol operation. A freely-available, open source
reference implementation of NORM is available at
https://www.nrl.navy.mil/itd/ncs/products/norm, and a documented API is
provided for this implementation. While a sockets-like API is not currently
documented, the existing API supports the necessary functions for that to be
implemented.

### Transport Features

The transport features provided by NORM are:

- unicast or multicast transport,
- unidirectional communication,
- stream-oriented delivery in a single stream or object-oriented delivery of in-memory data or file bulk content objects, <!-- editors note: combine to bullet in the list here, because only one of them can be used at the same time...?-->
- fully reliable (NACK-based) or partially reliable (using erasure coding both proactively and as part of ARQ) delivery, <!-- editors note: combined these point to one feature. Is this correct?-->
- unordered delivery,
- error detection (relies on UDP checksum), <!-- editors note: call this integrity detection?-->
- segmentation and aggregation,
- data bundling (using Nagle's algorithm),
- flow control (timer-based and/or ack-based),
- congestion control (also supporting fixed rate reliable or unreliable delivery).

## Transport Layer Security (TLS) and Datagram TLS (DTLS) as a pseudotransport

Transport Layer Security (TLS) {{RFC5246}}}
and Datagram TLS (DTLS) {{RFC6347}}} are IETF protocols that
provide several security-related features to applications. TLS is designed to
run on top of a reliable streaming transport protocol (usually TCP), while
DTLS is designed to run on top of a best-effort datagram protocol (UDP or DCCP
{{RFC5238}}). At the time of writing, the current version of TLS is 1.2; which is
defined in {{RFC5246}}. DTLS provides nearly identical functionality to
applications; it is defined in {{RFC6347}} and its current version is also
1.2.  The TLS protocol evolved from the Secure Sockets Layer (SSL) protocols
developed in the mid 90s to support protection of HTTP traffic.

While older versions of TLS and DTLS are still in use, they provide weaker
security guarantees. {{RFC7457}} outlines important attacks on TLS and DTLS.
{{RFC7525}} is a Best Current Practices (BCP) document that describes secure
configurations for TLS and DTLS to counter these attacks. The recommendations
are applicable for the vast majority of use cases.

### Protocol Description

Both TLS and DTLS provide the same security features and can thus be discussed
together. The features they provide are:

* Confidentiality
* Data integrity
* Peer authentication (optional)
* Perfect forward secrecy (optional)

The authentication of the peer entity can be omitted; a common web use case is
where the server is authenticated and the client is not. TLS also provides a
completely anonymous operation mode in which neither peer's identity is
authenticated. It is important to note that TLS itself does not specify how a
peering entity's identity should be interpreted.  For example, in the common
use case of authentication by means of an X.509 certificate, it is the
application's decision whether the certificate of the peering entity is
acceptable for authorization decisions. 

Perfect forward secrecy, if enabled
and supported by the selected algorithms, ensures that traffic encrypted and
captured during a session at time t0 cannot be later decrypted at time t1 (t1 
> t0), even if the long-term secrets of the communicating peers are later
compromised.

As DTLS is generally used over an unreliable datagram transport such as UDP,
applications will need to tolerate lost, re-ordered, or duplicated datagrams.
Like TLS, DTLS conveys application data in a sequence of independent records.
However, because records are mapped to unreliable datagrams, there are several
features unique to DTLS that are not applicable to TLS:

* Record replay detection (optional).
* Record size negotiation (estimates of PMTU and record size expansion factor).
* Coveyance of IP don't fragment (DF) bit settings by application.
* An anti-DoS stateless cookie mechanism (optional).

Generally, DTLS follows the TLS design as closely as possible.
To operate over datagrams, DTLS includes a sequence number and limited forms
of retransmission and fragmentation for its internal operations.
The sequence number may be used for detecting replayed information, according
to the windowing procedure described in Section 4.1.2.6 of {{RFC6347}}.
DTLS forbids the use of stream ciphers, which are essentially incompatible
when operating on independent encrypted records.

### Interface Description

TLS is commonly invoked using an API provided by packages such as OpenSSL,
wolfSSL, or GnuTLS. Using such APIs entails the manipulation of several
important abstractions, which fall into the following categories: long-term
keys and algorithms, session state, and communications/connections. There may
also be special APIs required to deal with time and/or random numbers, both of
which are needed by a variety of encryption algorithms and protocols.

Considerable care is required in the use of TLS APIs to ensure creation of a secure
application.  The programmer should have at least a basic understanding of encryption
and digital signature algorithms and their strengths, public key infrastructure (including
X.509 certificates and certificate revocation), and the sockets API.
See {{RFC7525}} and {{RFC7457}}, as mentioned above.

As an example, in the case of OpenSSL, the primary abstractions are the
library itself and method (protocol), session, context, cipher and connection.
After initializing the library and setting the method, a cipher suite is
chosen and used to configure a context object. Session objects may then be
minted according to the parameters present in a context object and associated
with individual connections. Depending on how precisely the programmer wishes
to select different algorithmic or protocol options, various levels of details
may be required.

### Transport Features

Both TLS and DTLS employ a layered architecture. The lower layer is commonly
called the record protocol. It is responsible for:

- message fragmentation.
- authentication and integrity via message authentication codes (MAC).
- data encryption.
- scheduling transmission using the underlying transport protocol.

DTLS augments the TLS record protocol with:

- ordering and replay protection, implemented using sequence numbers.

Several protocols are layered on top of the record protocol.  These include
the handshake, alert, and change cipher spec protocols.  There is also the
data protocol, used to carry application traffic. The handshake protocol is
used to establish cryptographic  and compression parameters when a connection
is first set up.  In DTLS, this protocol also has a basic fragmentation and
retransmission capability and a cookie-like mechanism to resist DoS attacks.
(TLS compression is not recommended at present). The alert protocol is used to
inform the peer of various conditions, most of which are terminal for the
connection. The change cipher spec protocol is used to synchronize changes in
cryptographic parameters for each peer.

The data protocol, when used with an appropriate cipher, provides:

- authentication of one end or both ends of a connection.
- confidentiality.
- cryptographic integrity protection.

## Hypertext Transport Protocol (HTTP) over TCP as a pseudotransport

The Hypertext Transfer Protocol (HTTP) is an application-level protocol widely
used on the Internet. It provides object-oriented delivery of discrete data or files.
Version 1.1 of the protocol is specified in {{RFC7230}}
{{RFC7231}} {{RFC7232}} {{RFC7233}} {{RFC7234}} {{RFC7235}}, and version 2 in
{{RFC7540}}.  HTTP is usually transported over TCP using port 80 and 443,
although it can be used with other transports. When used over TCP it inherits
its properties.

<!--HTTP is used as a substrate for other application-layer protocols.-->
Application layer protocols may use HTTP as a substrate with an existing method
and data formats, or specify new methods and data formats. There are
various reasons for this practice listed in {{RFC3205}}; these include being a
well-known and well-understood protocol, reusability of existing servers and
client libraries, easy use of existing security mechanisms such as HTTP digest
authentication {{RFC2617}} and TLS {{RFC5246}}, the ability of HTTP to
traverse firewalls makes it work over many types of infrastructure, and in
cases where an application server often needs to support HTTP anyway.
<!--Some protocols may not fit a request/response paradigm and instead rely on HTTP to
send messages (e.g., {{RFC6546}}). Because HTTP works in many restricted
infrastructures, it can also be used to tunnel other application-layer protocols.-->

Depending on application need, the use of HTTP as a substrate protocol may add
complexity and overhead in comparison to a special-purpose protocol (e.g.,
HTTP headers, suitability of the HTTP security model, etc.). {{RFC3205}}
addresses this issue and provides some guidelines and identifies
concerns about the use
of HTTP standard port 80 and 443, the use of HTTP URL scheme and interaction
with existing firewalls, proxies and NATs.

Representational State Transfer (REST) {{REST}} is another example of how
applications can use HTTP as transport protocol. REST is an architecture style
that may be used to build applications using HTTP as a communication
protocol.

### Protocol Description

Hypertext Transfer Protocol (HTTP) is a request/response protocol. A client
sends a request containing a request method, URI and protocol version followed
by a MIME-like message (see {{RFC7231}} for the differences between an HTTP
object and a MIME message), containing information about the client and
request modifiers. The message can also contain a message body carrying application
data. 
The server responds with a status or error code followed by a
MIME-like message containing information about the server and information
about the data. This may include a message body. It is possible to
specify a data format for the message body using MIME media types {{RFC2045}}.
The protocol has additional features, some relevant
to pseudo-transport are described below.

Content negotiation, specified in {{RFC7231}}, is a mechanism provided by HTTP
to allow selection of a representation for a requested resource. The client and server
negotiate acceptable data formats, charsets, data encoding (e.g., data can be
transferred compressed using gzip). HTTP can accommodate exchange of
messages as well as data streaming (using chunked transfer encoding
{{RFC7230}}). It is also possible to request a part of a resource using an
object range request {{RFC7233}}. The protocol provides powerful cache
control signalling defined in {{RFC7234}}.

The persistent connections of HTTP 1.1 and HTTP 2.0 allow
multiple request-response transactions (streams) during the life-time of a single HTTP
connection. HTTP 2.0 connections can multiplex many request/response
pairs in parallel on a single transport connection. This reduces overhead
during connection
establishment and mitigates transport layer slow-start that would have otherwise 
been incurred for
each transaction. Both are important to reduce latency for HTTP's primary use case.

HTTP can be combined with security mechanisms, such as TLS (denoted by
HTTPS). This adds protocol properties provided by such a mechanism (e.g.,
authentication, encryption). The TLS Application-Layer Protocol Negotiation
(ALPN) extension {{RFC7301}} can be used to negotiate the HTTP version within
the TLS handshake, eliminating the latency incurred by additional round-trip
exchanges.
Arbitrary cookie strings, included as part of the MIME headers, are often used
as bearer tokens in HTTP.

### Interface Description

There are many HTTP libraries available exposing different APIs. The APIs
provide a way to specify a request by providing a URI, a method, request
modifiers and optionally a request body. For the response, callbacks can be
registered that will be invoked when the response is received. If TLS is used,
the API exposes a registration of callbacks for a server that requests client
authentication and when certificate verification is needed.

The World Wide Web Consortium (W3C) has standardized the XMLHttpRequest API {{XHR}}.
This API can be used for sending HTTP/HTTPS requests and receiving server
responses. Besides the XML data format, the request and response data format can also
be JSON, HTML, and plain text. JavaScript and XMLHttpRequest are
ubiquitous programming models for websites, and more general applications,
where native code is less attractive.

### Transport features

The transport features provided by HTTP, when used as a pseudo-transport, are:

- unicast transport (provided by the lower layer protocol, usually TCP),
- bi- or unidirectional communication,
- stream-oriented transfer or message transfer with message content type negotiation, <!--editors note: added the nego bit here instead of having a separate feature...? Was this correct?-->
- object range request, <!-- editor note: Is this a feature? Is this the right name?-->
- ordered delivery (provided by the lower layer protocol, usually TCP),
- fully reliable delivery (provided by the lower layer protocol, usually TCP),
- flow control (provided by the lower layer protocol, usually TCP).

HTTPS (HTTP over TLS) additionally provides the following features (as provided by TLS):

- authentication (of one or both ends of a connection),
- confidentiality,
- integrity protection.

# Congestion Control

Congestion control is critical to the stable operation of the Internet. A
variety of mechanisms are used to provide the congestion control needed
by many Internet transport protocols. Congestion is detected based on sensing of
network conditions, whether through explicit or implicit feedback. The
congestion control mechanisms that can be applied by different transport
protocols are largely orthogonal to the choice of transport protocol. This
section provides an overview of the congestion control mechanisms available to
the protocols described in {{existing-transport-protocols}}.

Many protocols use a separate window to determine the maximum sending rate
that is allowed by the congestion control. The used congestion control
mechanism will increase the congestion window if feedback is received that
indicates that the currently used network path is not congested, and will
reduce the window otherwise. Window-based mechanisms often increase their
window slowing over multiple RTTs, while decreasing strongly when the first
indication of congestion is received. One example are Additive Increase
Multiplicative Decrease (AIMD) schemes, where the window is increased by a
certain number of packets/bytes for each data segment that has been
successfully transmitted, while the window is multiplicatively decrease on the
occurrence of a congestion event. This can lead to a rather unstable,
oscillating sending rate, but will resolve a congestion situation quickly. TCP
New Reno {{RFC5681}} which is one of the initial proposed schemes for TCP as
well as TCP Cubic {{I-D.ietf-tcpm-cubic}} which is the default mechanism for
TCP in Linux are two examples for window-based AIMD schemes. This approach is
also used by DCCP CCID-2 for datagram congestion control.

Some classes of applications prefer to use a transport service that allows
sending at a more stable rate, that is slowly varied in response to
congestion. Rate-based methods offer this type of congestion control and have
been  defined based on the loss ratio and observed round trip time, such as
TFRC {{RFC5348}} and TFRC-SP {{RFC4828}}. These methods utilise a throughput
equation to determine the maximum acceptable rate. Such methods are used with
DCCP CCID-3 {{RFC4342}} and CCID-4 {{RFC5622}}, WEBRC {{RFC3738}}, and other
applications.

Another class of applications prefer a transport service that
yields to other (higher-priority) traffic, such as interactive transmissions.
While most traffic in the Internet uses loss-based congestion control and 
therefore need to fill the network buffers (to a certain level if 
Active Queue Management (AQM) is used), low-priority congestion control 
methods often react to changes in delay as an earlier indication of congestion. 
This approach tends to  induce less loss than a
loss-based method but does generally not compete well with loss-based traffic
across shared bottleneck links. Therefore, methods such as LEDBAT {{RFC6824}},
are deployed in the Internet for scavenger traffic that aim to only utilize 
otherwise unused capacity.

# Transport Features

The tables below summarize some key features to illustrate the range of
functions provided across the IETF-specified transports. {{tabtp}} considers
transports that may be directly layered over the network, and
{{tabult}} considers transports layered over another transport service.
Features that are permitted, but not required, are marked as "Poss" indicating that
it is possible for the transport service to offer this feature.

~~~~~~~~~~

+---------------+------+------+------+------+------+------+------+
| Feature       | TCP  | MPTCP| SCTP | UDP  | UDP-L|DCCP  |ICMP  |
+---------------+------+------+------+------+------+------+------+
| Datagram      | No   | No   | Yes  | Yes  | Yes  | Yes  | Yes  |
+---------------+------+------+------+------+------+------+------+
| Conn. Oriented| Yes  | Yes  | Yes  | No   | No   | Yes  | No   |
+---------------+------+------+------+------+------+------+------+
| Reliability   | Yes  | Yes  | Yes  | No   | No   | No   | No   |
+---------------+------+------+------+------+------+------+------+
| Partial Rel.  | No   | No   | Poss | N/A  | N/A  | Yes  | N/A  |
+---------------+------+------+------+------+------+------+------+
| Corupt. Tol   | No   | No   | No   | No   | Yes  | Yes  | No   |
+---------------+------+------+------+------+------+------+------+
| Cong.Control  | Yes  | Yes  | Yes  | No   | No   | Yes  | No   |
+---------------+------+------+------+------+------+------+------+
| Endpoint      |  1   | >=1  | >=1  |  1   |  1   |  1   |  1   |
+---------------+------+------+------+------+------+------+------+
| Multicast Cap.| No   | No   | No   | Yes  | Yes  | No   | No   |
+---------------+------+------+------+------+------+------+------+

~~~~~~~~~~
{: #tabtp title="Summary comparison: Transport protocols"}

~~~~~~~~~~

+---------------+------+------+------+------+------+
| Feature       | RTP  | FLUTE| NORM |(D)TLS| HTTP |
+---------------+------+------+------+------+------+
| Datagram      | Yes  | No   | Both | Both | No   |
+---------------+------+------+------+------+------+
| Conn. Oriented| No   | Yes  | Yes  | Yes  | Yes  |
+---------------+------+------+------+------+------+
| Reliability   | No   | Yes  | Poss | Poss | Yes  |
+---------------+------+------+------+------+------+
| Partial R     | Poss | No   | Poss | No   | No   |
+---------------+------+------+------+------+------+
| Corupt. Tol   | Poss | No   | No   | No   | No   |
+---------------+------+------+------+------+------+
| Cong.Control  | Poss | Poss | Poss | N/A  | N/A  |
+---------------+------+------+------+------+------+
| Endpoint      | >=1  | >=1  | >=1  |  1   |  1   |
+---------------+------+------+------+------+------+
| Multicast Cap.| Yes  | Yes  | Yes  | No   | No   |
+---------------+------+------+------+------+------+

~~~~~~~~~~
{: #tabult title="Upper layer transports and frameworks"}

The transport protocol features described in this document could be used as a basis for defining common transport features:

- Control Functions
  - Addressing
    - unicast (TCP, MPTCP, SCTP, UDP, UDP-Lite, DCCP, ICMP, RTP, TLS, HTTP)
    - multicast (UDP, UDP-Lite, DCCP, ICMP, RTP, FLUTE/ALC, NORM)
    - IPv4 broadcast (UDP, UDP-Lite, ICMP)
    - anycast (UDP, UDP-Lite). Connection-oriented protocols such as TCP, and DCCP can be used with anycast, with the risk that routing changes may cause connection failure.
  - Multihoming support
    - multihoming for resilience (MPTCP, SCTP)
    - multihoming for mobility (MPTCP, SCTP)
    - multihoming for load-balancing (MPTCP)

- Delivery
  - reliability
    - fully reliable delivery (TCP, MPTCP, SCTP, FLUTE/ALC, NORM, TLS, HTTP)
    - partially reliable delivery (SCTP, NORM)
      - using packet erasure coding (FLUTE, NORM, RTP)
    - unreliable delivery (SCTP, UDP, UDP-Lite, DCCP, RTP)
      - with drop notification to sender (RTP, SCTP, DCCP)
    - Integrity protection 
      - checksum for error detection (TCP, MPTCP, SCTP, UDP, UDP-Lite, DCCP, ICMP, FLUTE/ALC, NORM, TLS, DTLS)
      - partial payload checksum protection (UDP-Lite, DCCP). Some uses of RTP can exploit partial payload checksum protection feature to provide a corruption tolerant transport service.
      - checksum optional (UDP). Possible with IPv4 and in certain cases with IPv6.
  - ordering
    - ordered delivery (TCP, MPTCP, SCTP, RTP, FLUTE, TLS, HTTP)
    - unordered delivery permitted (SCTP, UDP, UDP-Lite, DCCP, RTP (includes timing information), NORM)
  - type/framing
    - stream-oriented delivery (TCP, MPTCP, SCTP, TLS)
      - with multiple streams per association (SCTP, HTTP 2.0)
    - message-oriented delivery (SCTP, UDP, UDP-Lite, DCCP, RTP, DTLS)
    - object-oriented delivery of discrete data or files (FLUTE/ALC, NORM, HTTP)

- Transmission control
  - flow control (TCP, MPTCP, SCTP, DCCP, RTP, TLS, HTTP)
  - congestion control (TCP, MPTCP, SCTP, DCCP, RTP, FLUTE/ALC, NORM). Congestion control can also provided by the transport supporting an upper later transport (e.g., RTP,HTTP, TLS).
  - segmentation (TCP, MPTCP, SCTP, RTP, FLUTE/ALC, NORM, TLS, HTTP)
  - data/message bundling (TCP, MPTCP, SCTP, TLS, HTTP)
  - stream scheduling prioritization (SCTP, HTTP 2.0)

- Security (may be used in combination with other transports)
  - authentication of one end of a connection (TLS, DTLS)
  - authentication of both ends of a connection (TLS, DTLS)
  - confidentiality (TLS, DTLS)
  - cryptographic integrity protection (TLS, DTLS)

- Uni- and bidirectional communication <!-- editors note: Where does this belong? Or remove here and in feature lists above!-->


# IANA Considerations

This document has no considerations for IANA.

# Security Considerations

This document surveys existing transport protocols and protocols providing transport-like services. Confidentiality, integrity, and authenticity are among the features provided by those services. This document does not specify any new features or mechanisms for providing these features. Each RFC listed in this document discusses the security considerations of the specification it contains.

# Contributors

<!--
 -
    ins: K. Fall
    name: Kevin Fall
    email: kfall@kfall.com
 -
    ins: M. Tuexen
    name: Michael Tuexen
    org: Muenster University of Applied Sciences
    street: Stegerwaldstrasse 39
    city: 48565 Steinfurt
    country: Germany
    email: tuexen@fh-muenster.de
-->

In addition to the editors, this document is the work of Brian Adamson,
Dragana Damjanovic, Kevin Fall, Simone Ferlin-Oliviera, Ralph Holz, Olivier
Mehani, Karen Nielsen, Colin Perkins, Vincent Roca, and Michael Tuexen.

- {{multipath-tcp-mptcp}} on MPTCP was contributed by Simone Ferlin-Oliviera (ferlin@simula.no) and Olivier Mehani (olivier.mehani@nicta.com.au)
- {{user-datagram-protocol-udp}} on UDP was contributed by Kevin Fall (kfall@kfall.com)
- {{stream-control-transmission-protocol-sctp}} on SCTP was contributed by Michael Tuexen (tuexen@fh-muenster.de) and Karen Nielsen (karen.nielsen@tieto.com)
- {{realtime-transport-protocol-rtp}} on RTP contains contributions from Colin Perkins (csp@csperkins.org)
- {{file-delivery-over-unidirectional-transportasynchronous-layered-coding-reliable-multicast-flutealc}} on FLUTE/ALC was contributed by Vincent Roca (vincent.roca@inria.fr)
- {{nack-oriented-reliable-multicast-norm}} on NORM was contributed by Brian Adamson (brian.adamson@nrl.navy.mil)
- {{transport-layer-security-tls-and-datagram-tls-dtls-as-a-pseudotransport}} on TLS and DTLS was contributed by Ralph Holz (ralph.holz@nicta.com.au) and Olivier Mehani (olivier.mehani@nicta.com.au)
- {{hypertext-transport-protocol-http-over-tcp-as-a-pseudotransport}} on HTTP was contributed by Dragana Damjanovic (ddamjanovic@mozilla.com)

# Acknowledgments

Thanks to Joe Touch, Michael Welzl, and the TAPS Working Group for the
comments, feedback, and discussion. This work is partially supported by the
European Commission under grant agreements FP7-ICT-318627 mPlane and from the
Horizon 2020 research and innovation program under grant agreement No. 644334
(NEAT); support does not imply endorsement.
