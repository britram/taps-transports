
## Template: Imaginary Transport Protocol (ITP)

(This subsection is a initial rough template to provide guidance to subsection authors on how a subsection should be structured and what information should be provided. Please don't use it yet, but do think about whether it applies to the protocol section you're writing, and if not, why not. It will be removed once a real transport protocol has been fully described in the draft; that protocol's description can then be used as template for the others. In general, guidance for writing a transport protocol session is that the description should be short, with enough detail to compare and contrast protocols and extract relevant transport service features, but not necessarily enough detail to implement the protocol or understand corner-cases its design. Implementation details and corner cases, if mentioned, should be further explained by reference.)

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