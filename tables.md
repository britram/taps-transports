
The tables below summarize some key features to illustrate the range of
functions provided across the IETF-specified transports. {{tabtp}} considers
transports that may be directly layered over the network, and
{{tabult}} considers transports layered over another transport service.
Features that are permitted, but not required, are marked as "Poss" indicating that
it is possible for the transport service to offer this feature.

~~~~~~~~~~

+---------------+------+------+------+------+------+------+------+
| Feature       | TCP  | MPTCP| UDP  | UDPL | SCTP | DCCP | ICMP |
+---------------+------+------+------+------+------+------+------+
| Datagram      | No   | No   | Yes  | Yes  | Yes  | Yes  | Yes  |
+---------------+------+------+------+------+------+------+------+
| Conn. Oriented| Yes  | Yes  | No   | No   | Yes  | Yes  | No   |
+---------------+------+------+------+------+------+------+------+
| Reliability   | Yes  | Yes  | No   | No   | Yes  | No   | No   |
+---------------+------+------+------+------+------+------+------+
| Partial Rel.  | No   | No   | N/A  | N/A  | Poss | Yes  | N/A  |
+---------------+------+------+------+------+------+------+------+
| Corupt. Tol   | No   | No   | No   | Yes  | No   | Yes  | No   |
+---------------+------+------+------+------+------+------+------+
| Cong.Control  | Yes  | Yes  | No   | No   | Yes  | Yes  | No   |
+---------------+------+------+------+------+------+------+------+
| Endpoint      |  1   | >=1  | >=1  | >=1  | >=1  |  1   |  1   |
+---------------+------+------+------+------+------+------+------+
| Multicast Cap.| No   | No   | Yes  | Yes  | No   | No   | No   |
+---------------+------+------+------+------+------+------+------+

~~~~~~~~~~
{: #tabtp title="Summary comparison: Transport protocols"}

~~~~~~~~~~

+---------------+------+------+------+------+------+
| Feature       |(D)TLS| RTP  | HTTP | FLUTE| NORM |
+---------------+------+------+------+------+------+
| Datagram      | Both | Yes  | No   | No   | Both |
+---------------+------+------+------+------+------+
| Conn. Oriented| Yes  | No   | Yes  | Yes  | Yes  |
+---------------+------+------+------+------+------+
| Reliability   | Poss | No   | Yes  | Yes  | Poss |
+---------------+------+------+------+------+------+
| Partial R     | No   | Poss | No   | No   | Poss |
+---------------+------+------+------+------+------+
| Corupt. Tol   | No   | Poss | No   | No   | No   |
+---------------+------+------+------+------+------+
| Cong.Control  | N/A  | Poss | N/A  | Poss | Poss |
+---------------+------+------+------+------+------+
| Endpoint      |  1   | >=1  |  1   | >=1  | >=1  |
+---------------+------+------+------+------+------+
| Multicast Cap.| No   | Yes  | No   | Yes  | Yes  |
+---------------+------+------+------+------+------+

~~~~~~~~~~
{: #tabult title="Upper layer transports and frameworks"}
