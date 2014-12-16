---
title: "Services provided by IETF transport protocols and congestion control mechanisms"
abbrev: TAPS Transports
docname: draft-ietf-taps-transports-01
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
  RFC1122:
  RFC2018:
  RFC3168:
  RFC3205:
  RFC3390:
  RFC3758:
  RFC3828:
  RFC4340:
  RFC4960:
  RFC5246:
  RFC5348:
  RFC5405:
  RFC5925:
  RFC5681:
  RFC6093:
  RFC6298:
  RFC6455:
  RFC6347:
  RFC6691:
  RFC6824:
  RFC7323:

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

# Existing Transport Protocols

This section provides a list of known IETF transport protocol and
transport protocol frameworks.

## Transport Control Protocol (TCP)

{{RFC0793}} introduces TCP as follows: "The 
Transmission Control Protocol (TCP) is intended for use as a highly reliable host-to-host protocol between hosts 
in packet-switched computer communication networks, and in interconnected 
systems of such networks." Since its introduction, TCP has become the default connection-oriented, 
stream-based transport protocol in the Internet, widely implemented by endpoints and 
widely used by common application protocols. 

### Protocol Description

TCP is a connection-oriented protocol, providing a three way handshake to allow a client and server to set up a connection, and mechanisms for orderly completion and immediate teardown of a connection. It provides multiplexing to multiple sockets on each host using port numbers. An active TCP session is identified by its four-tuple of local and remote IP addresses and local port and remote port numbers.

TCP partitions a continuous stream of bytes into segments, sized to fit in the lower-layer (IP and MAC) packets and frames. Each byte in the stream is identified by a sequence number. The sequence number is used to order segments on receipt, to identify segments in acknowledgments, and to detect unacknowledged segments for retransmission. This is the basis of TCP's reliable, ordered delivery of data in a stream. TCP Selective Acknowledgment {{RFC2018}} extends this mechanism by making it possible to identify missing segments more precisely, reducing spurious retransmission. 

Receiver flow control is provided by a sliding window: at a given time, at most a given amount of unacknowledged data can be outstanding. The window scale option {{RFC7323}} provides for receiver windows greater than 64kB. A separate window is used for congestion control: each time congestion is detected, the congestion window is reduced. Senders interpret loss as a congestion signal; though the Explicit Congestion Notification (ECN) {{RFC3168}} mechanism was defined to provide early signaling, it is not yet widely deployed.

By default, TCP segment partitioning attempts to minimize the number of segments for a given stream; Nagle's algorithm {{RFC0896}} modifies this behavior to transmit more immediately, supporting interactive sessions.

### Interface description

In API implementations derived from the BSD Sockets API, TCP sockets are created using the `SOCK_STREAM` socket type. 

(more on the API goes here)

### Transport Protocol Components

The transport protocol components provided by TCP are:

- unicast
- port multiplexing
- reliable delivery
- ordered delivery
- segmented, single-stream-oriented delivery
- congestion control

(discussion of how to map this to features and TAPS: what does the higher layer need to decide? what can the transport layer decide based on global settings? what must the transport layer decide based on network characteristics?)

<!--### Mirja's original text on Data Communication

TCP partitions all data into segements that can be identified by a sequence number (SEQ).
Each new payload byte increases the SEQ by one. 
The Maximum Segment Size (MSS) {{RFC6691}} is determined by the capacilities of the lower layer, usually IP, and the length of the TCP header as well as TCP options.
A TCP receiver sends an acknowledgment (ACK) on the reception of a data segment.
The ACK contains an acknowledgment number that announces the next in-order SEQ expected by the receiver. 
To reduce signaling overhead, a TCP receiver might not acknowledge each received segment separately but multiple at once. 
A TCP receiver should at least acknowledge every second packet and delay an acknowledgement not more that 500ms {{RFC1122}} {{RFC5681}}.--> 
<!-- Most operating systems implement a maximum delay of 100ms today. There are hardware implementation for high speed networks that accumulate even more. -->
<!--Loss is assumed by the sender if three duplicated ACKs, that acknowledge the same SEQ, are received or no ACK is received for a certain time and the Retransmission Time-Out (RTO) triggers an interupt.
If a seqment is detected to be lost, the sender will retransmit it.-->
<!-- and retransmitting (potentially) lost data when no new acknowledgment is received. -->
<!-- Duplicated ACKs are triggered at the receiver by the arrival of out-of-order data segments and thereby do not acknowledge new data but repeat the previous acknowledgment number.  
 --><!-- If this data does not carry the next expected SEQ, the receiver will send out an ACK with the same acknowledgment number again. 
This is called a duplicated ACK. --> 
<!-- When the missing data is received, a cumulative acknowledgment is sent that acknowledges all (now) in-order segments received so far.
Additionally, TCP often implements Selective Acknowledgment (SACK) {{RFC2018}}, where, in case of duplicated ACKs, the received sequence number ranges are announced to the sender.
Therefore when more than one packets got lost, the sender does not have to wait until an accumulated ACK announces the next whole in the sequence number space, but can retransmit lost packets immediately.

To determine e.g. a large enough value for the RTO {{RFC6298}}, the  RTT needs to be measured by a TCP sender.
The RTTM mechanism in TCP either needs to store the sent-out time stamp and SEQ of all or a sample of packets or can use the TSOpt {{RFC7323}}. 
With TSOpt the sender adds the current time stamp to each packet and the receiver reflects this time stamp in the respective ACK. 
By subtracting the reflected time stamp from the current system time the  RTT can be measured for each received ACK holding a valid TSOpt. -->
<!-- Note, that in case of delayed or duplicated ACKs, the time stamp of the first unacknowledged packet is reflected which might inflate the  RTT measurement artificially but guarantees a large enough RTO. -->
<!--"Then a single subtract gives the sender an accurate RTT measurement for every ACK segment (which will correspond to every other data segment, with a sensible receiver)." [rfc7323]-->
<!-- 
(talk about spurious retransmissions...?)

Further when a loss is detected,  TCP congestion control {{RFC5681}} becomes active and usually reduces the sending rate.
The sending rate is most often determined by a (sliding-) window. 
Based on the packet conservation principle [Jacobson1988], new packets are only sent into the network when an old packets has exited. 
This leads to TCP implementations that are mostly self-clocked and take actions only when an ACK is received.
Initially, if enough data is available, a TCP sender usually send 2-4 {{RFC3390}} or up to 10 segements back to back.
When no ACKs are received at all for a certain time larger than at least one  RTT, the RTO is triggered and the sending rate is reduced to a minimum value.
The current sending window is the minimum of the receive window and the congestion window where 
the receive window is announced by the receiver to not overload the receiver buffer.
As long as flow control does not become active and not signal a smaller receive window to not overload the receiver, the sending window equals the congestion window.
The congestion window is estimated by the congestion control algorithm based on implicit or explicit network feedback such as loss, delay measurements, or Explicit Congestion Notofication (ECN) {{RFC3168}}. -->
<!--In general, congestion control is based on some kind of network feedback.-->
<!-- Inherently, the congestion control mechanism of a TPC sender assumes that loss occurs to due network congestion und therefore reacts each time congestion is notified.
Note, congestion control usually at most reduces once per RTT as the congestion feedback has a signaling delay of one RTT. 
Unfortunately, congestion is not the only reason for the occurrence of loss. 
Packets can be dropped for various reasons by different nodes on the network path, e.g due to bit errors.-->
<!--In the Internet the non-congestion based loss rate is usually very low, thus it is common sense to always handle loss as congestion signal.-->
<!-- 
(text on "On the Implementation of the TCP Urgent Mechanism" {{RFC6093}}, "The TCP Authentication Option" {{RFC5925}}, and "TCP Fast Open"...?)

(What's still missing? Check TCP options...)
 -->

## Multipath TCP (MP-TCP)

(a few sentences describing Multipath TCP {{RFC6824}} go here. Note that this adds transport-layer multihoming to the components TCP provides)

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

## Transport Layer Security (TLS) and Datagram TLS (DTLS) as a pseudotransport

(A few words on TLS {{RFC5246}} and DTLS {{RFC6347}} here, and how they get used by other protocols to meet security goals as an add-on interlayer above transport.)

## Hypertext Transport Protocol (HTTP) as a pseudotransport

{{RFC3205}}

### WebSockets

{{RFC6455}}

# Transport Service Features

(drawn from the candidate features provided by protocol components in the previous section)

# Complete Protocol Feature Matrix

(a comprehensive matrix table goes here; Volunteer: Dave Thaler)

# IANA Considerations

This document has no considerations for IANA.

# Security Considerations

This document surveys existing transport protocols and protocols providing transport-like services. Confidentiality, integrity, and authenticity are among the features provided by those services. This document does not specify any new components or mechanisms for providing these features. Each RFC listed in this document discusses the security considerations of the specification it contains.

# Contributors

Non-editor contributors of text will be listed here, as in the authors section.

# Acknowledgments

This work is partially supported by the European Commission under grant agreement FP7-ICT-318627 mPlane; support does not imply endorsement.




