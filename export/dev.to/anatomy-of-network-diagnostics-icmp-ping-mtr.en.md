---
title: "Deep Dive into the Internet: The Anatomy of Network Diagnostics with ICMP, Ping, and MTR"
date: 2025-11-25T16:57:21Z
draft: false
description: "Master network diagnostics and troubleshooting. A comprehensive guide to understanding the anatomy of the internet using ICMP, Ping, and MTR tools for SysAdmins and DevOps."
tags: ["networking","internet","icmp","ping","mtr","network-diagnostics","linux","sysadmin","devops","troubleshooting"]
categories: ["Networking"]
slug: "anatomy-of-network-diagnostics-icmp-ping-mtr"
series: ["Internet"]
seriesPart: 1
cover:
  image: "images/network-diagnostics-cover.jpg"
  alt: "Network diagnostics illustration showing ICMP, Ping, and MTR tools"
  caption: "Deep dive into network diagnostics with ICMP, Ping, and MTR"
  relative: false
images:
  - "images/network-diagnostics-cover.jpg"
---


## Introduction

When we talk about the Internet, it's so important that saying "it's used like this, it's a must-have" would sound too simple. We'll take a look at how the magic behind the internet actually works. What's happening in the background when you visit a webpage, send a message, or watch a video?

In this guide, we'll take a journey from the basics of the internet towards the most important building blocks of network diagnostic tools. We'll examine the ICMP protocol, ping command, and advanced network diagnostics tool MTR in depth. We're looking under the hood.

---

## History and Evolution of the Internet

### ARPANET: Where It All Started (1969)

The story of the internet begins in the late 1960s during the Cold War era. The Advanced Research Projects Agency (ARPA) unit of the US Department of Defense wanted to develop a communication network that could withstand a nuclear attack.

**Core Design Philosophy:**
- **Decentralized Structure:** There was no single point of control
- **Packet Switching:** The revolutionary idea of Paul Baran and Donald Davies
- **Redundancy:** If one connection broke, there should be alternative paths

On October 29, 1969, the first message was sent from UCLA to Stanford Research Institute. The first word to be transmitted was supposed to be "LOGIN", but the system crashed after the letters "LO" - one of history's most meaningful system crashes :D

### Birth of TCP/IP (1970s)

**1974:** Vint Cerf and Bob Kahn started working on "Transmission Control Protocol" (TCP).

**Main Problem:** How will different networks talk to each other?
- Different hardware
- Different protocols
- Different error management strategies

**Solution:** A universal protocol layer - TCP/IP

**1983:** ARPANET switched from NCP protocol to TCP/IP. This date is called "Flag Day" and is considered the birth date of the modern internet.

---

## How Does the Internet Work? Down the Rabbit Hole

### Packet Switching: The Foundation of Internet

Traditional telephone systems had "circuit switching" - a dedicated line was established between caller and called. The Internet works differently though.

**How Does Packet Switching Work?**

```
Original Data: "Hello World!"
↓
Split into Packets:
[Packet 1: "Hell"] [Packet 2: "o Wo"] [Packet 3: "rld!"]
↓
Each packet is routed independently
↓
Reassembled at destination
```

**Advantages:**
- Flexibility: If one path is blocked, it goes through another
- Efficiency: Bandwidth is shared
- Reliability: A single failure doesn't crash the entire system



### TCP/IP Model: 4-Layer Architecture

The Internet is built on a layered architecture. Each layer serves the layer above it and uses the services of the layer below.

```
┌─────────────────────────────────────┐
│   4. Application Layer              │
│   (HTTP, FTP, SMTP, DNS)            │
├─────────────────────────────────────┤
│   3. Transport Layer                │
│   (TCP, UDP)                        │
├─────────────────────────────────────┤
│   2. Internet Layer                 │
│   (IP, ICMP, IGMP)                  │
├─────────────────────────────────────┤
│   1. Network Interface Layer        │
│   (Ethernet, Wi-Fi)                 │
└─────────────────────────────────────┘
```

#### 1. Network Interface Layer (Link Layer)
- **Task:** Data transmission over physical network
- **Technologies:** Ethernet, Wi-Fi, Fiber optic
- **MAC Address:** Physical hardware address (e.g., `00:1B:44:11:3A:B7`)

#### 2. Internet Layer
- **Task:** Routing of packets
- **Main Protocol:** IP (Internet Protocol)
- **ICMP:** Works at this layer! (Control and error messages)

**IP Address Structure:**
```
IPv4: 192.168.1.100 (32-bit, ~4.3 billion addresses)
      [Network Part].[Host Part]

IPv6: 2001:0db8:85a3:0000:0000:8a2e:0370:7334 (128-bit, ~340 undecillion addresses)
```

#### 3. Transport Layer
- **TCP:** Reliable, ordered, error-free transmission (e.g., web pages, email)
- **UDP:** Fast but unreliable transmission (e.g., video streaming, DNS)

**TCP vs UDP:**
```
TCP: If packet is lost, resend it, ordering guaranteed
     [SYN] → [SYN-ACK] → [ACK] (Three-way handshake)
     Slow but reliable

UDP: Send packet and forget. If it's lost, it's lost
     Fast but unreliable
```

##### Note

- **SYN _(Synchronize)_**: The "Shall we establish a connection?" request sent by the side initiating communication.
- **ACK _(Acknowledgment)_**: The "OK, I received it" confirmation that verifies the previous message was received without problems.
- **SYN-ACK**: The server's way of saying "I received your request (ACK) and I'm ready too (SYN)".

#### 4. Application Layer
- **HTTP/HTTPS:** Web
- **SMTP/POP3/IMAP:** Email
- **FTP:** File transfer
- **DNS:** Domain name resolution
- **SSH:** Secure remote connection

### Routing: How Do Packets Find Their Way?

Each router keeps a "routing table":

```bash
$ ip route show
default via 192.168.1.1 dev eth0
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.100
```

| OS | Status / Required Package | Equivalent |
| :--- | :--- | :--- |
| **Linux** | `iproute2` (Usually comes pre-installed) | `ip route show` |
| **Windows** | Native command (CMD / PowerShell) | `route print` |
| **macOS** | Native command (or `brew install iproute2mac`) | `netstat -rn` |

**Routing Process:**
1. Packet arrives at router
2. Router looks at destination IP address
3. Selects most suitable path from routing table
4. Sends packet to next hop (next router)
5. This process repeats until destination is reached

**Example Journey:**
```
Istanbul → Frankfurt → London → New York

Your computer in Istanbul:
  ↓ (Send packet: destination 93.184.216.34)
Internet Service Provider (ISP) Router
  ↓ (Best route: Frankfurt)
Frankfurt Backbone Router
  ↓ (Through Atlantic cable)
New York Router
  ↓
Destination Server (93.184.216.34)
```

Each router only knows the next step - not the entire path. This "distributed intelligence" approach is the key to internet scalability.

---

## ICMP Protocol: The Nervous System of the Internet

### What is ICMP?

**Internet Control Message Protocol (ICMP)** is part of the IP protocol but serves a different purpose:
- Doesn't carry data
- Transmits error notifications
- Sends network diagnostic messages

**History:** Defined by RFC 792 (1981) - by Jon Postel

### Why is ICMP Needed?

IP protocol works with "best-effort" principle:
- Doesn't guarantee packet delivery
- Doesn't report errors
- Doesn't provide flow control

ICMP fills this gap!

### ICMP Message Structure

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     Type      |     Code      |          Checksum             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                         Rest of Header                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                         Data Section                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```


### Important ICMP Message Types

#### Type 0/8: Echo Reply / Echo Request (PING)
```
Type 8: Echo Request (Sending ping)
Type 0: Echo Reply (Pong response)

Usage: Checking if host is alive
```

#### Type 3: Destination Unreachable
```
Code 0: Network Unreachable (Can't reach network)
Code 1: Host Unreachable (Can't reach host)
Code 2: Protocol Unreachable (Protocol not supported)
Code 3: Port Unreachable (Port closed)
Code 4: Fragmentation Needed (Packet too large, fragmentation needed)
```

**Example Scenario:**
```bash
$ curl http://192.168.1.250:8080
# Router responds:
ICMP Type 3, Code 1: Host Unreachable
# Result: Host doesn't exist on network or is down
```

#### Type 11: Time Exceeded
```
Code 0: TTL Exceeded in Transit (Foundation of Traceroute!)
Code 1: Fragment Reassembly Time Exceeded
```

**TTL (Time To Live) Mechanism:**
```
Packet sent: TTL=64
Each time passing through router: TTL-1
When TTL=0: Returns ICMP Time Exceeded

This way packets don't loop forever!
```

#### Type 5: Redirect
```
"There's a better route!" message
Router suggesting routing optimization to host
```

#### Type 30: Traceroute
Used for modern traceroute implementations.

### Security Aspect of ICMP

**Potential Threats:**

1. **ICMP Flood (Smurf Attack)**
```
Attacker → Ping to broadcast IP (fake source IP: victim)
All hosts on network → Ping reply to victim
Result: DDoS
```

2. **ICMP Redirect Attacks**
Redirecting traffic with fake redirect messages

3. **Ping of Death**
Buffer overflow by sending excessively large ICMP packets

**Protection Methods:**
- ICMP rate limiting
- Blocking unnecessary ICMP types in firewall
- Disabling ICMP redirect messages

```bash
# Disabling ICMP redirect on Linux
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.all.send_redirects=0
```

---

## Ping Command: The Heart of Network Diagnostics

### What is Ping?

**Ping** is a network diagnostic tool that uses the ICMP Echo Request/Reply mechanism. Its name comes from the "ping" sound of submarine sonar - it sends a signal and listens for the echo.

**Developer:** Mike Muuss (1983) - BBN Technologies

### How Does Ping Work?

```
┌─────────────┐                           ┌─────────────┐
│   Source    │                           │   Target    │
│   (Your     │                           │  (example.  │
│  Computer)  │                           │    com)     │
└──────┬──────┘                           └──────┬──────┘
       │                                         │
       │ ICMP Echo Request (Type 8)              │
       │ Seq=1, ID=12345, Payload=56 bytes       │
       │                                         │
       │────────────────────────────────────────>│
       │                                         │
       │         ICMP Echo Reply (Type 0)        │
       │         Seq=1, ID=12345                 │
       │                                         │
       │<────────────────────────────────────────│
       │                                         │
       │ ICMP Echo Request (Type 8)              │
       │ Seq=2, ID=12345                         │
       │                                         │
       │────────────────────────────────────────>│
       │                                         │
```

**Step by Step:**
1. Ping converts target hostname to IP via DNS
2. Creates ICMP Echo Request packet (Type 8)
3. Adds sequence number and timestamp to packet
4. Sends packet to target
5. Target responds with Echo Reply (Type 0)
6. Ping calculates round-trip time (RTT)
7. Shows statistics

### Basic Ping Usage

#### Simplest Usage
```bash
$ ping google.com

PING google.com (172.217.169.46) 56(84) bytes of data.
64 bytes from sof02s42-in-f14.1e100.net (172.217.169.46): icmp_seq=1 ttl=117 time=15.2 ms
64 bytes from sof02s42-in-f14.1e100.net (172.217.169.46): icmp_seq=2 ttl=117 time=14.8 ms
64 bytes from sof02s42-in-f14.1e100.net (172.217.169.46): icmp_seq=3 ttl=117 time=15.1 ms
^C
--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 14.800/15.033/15.200/0.172 ms
```


**Output Analysis:**

| Field | Description |
|------|----------|
| `64 bytes` | ICMP packet size (excluding IP header) |
| `icmp_seq=1` | Sequence number (for packet loss detection) |
| `ttl=117` | Time To Live - how many more routers can it pass through |
| `time=15.2 ms` | Round-Trip Time |


### Real World Ping Examples and Analysis

#### Example 1: Healthy Connection
```bash
$ ping -c 5 google.com

PING google.com (142.250.185.46) 56(84) bytes of data.
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=1 ttl=117 time=14.2 ms
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=2 ttl=117 time=13.9 ms
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=3 ttl=117 time=14.1 ms
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=4 ttl=117 time=14.3 ms
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=5 ttl=117 time=14.0 ms

--- google.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 13.937/14.100/14.318/0.143 ms
```

**Analysis:**
> ✅ 0% packet loss - Perfect \
    ✅ Consistent RTT (~14ms) - Stable connection \
    ✅ Low mdev (0.143ms) - Very little jitter \
    ✅ TTL=117 - Normal (probably started at 128, passed 11 hops)

**Result:** Healthy internet connection

#### Example 2: Packet Loss Present
```bash
$ ping -c 10 instable-server.com

PING instable-server.com (203.0.113.45) 56(84) bytes of data.
64 bytes from 203.0.113.45: icmp_seq=1 ttl=54 time=45.2 ms
64 bytes from 203.0.113.45: icmp_seq=3 ttl=54 time=89.7 ms
64 bytes from 203.0.113.45: icmp_seq=5 ttl=54 time=52.3 ms
64 bytes from 203.0.113.45: icmp_seq=7 ttl=54 time=145.2 ms
64 bytes from 203.0.113.45: icmp_seq=10 ttl=54 time=67.8 ms

--- instable-server.com ping statistics ---
10 packets transmitted, 5 received, 50% packet loss, time 9145ms
rtt min/avg/max/mdev = 45.234/80.040/145.234/35.123 ms
```

**Analysis:**
> ❌ 50% packet loss - Serious problem! \
    ❌ High RTT variability (mdev=35.123ms) - Unstable connection \
    ❌ Missing sequence numbers (2,4,6,8,9 lost) - Random packet loss

**Possible Causes:**
- Network congestion
- Low quality ISP connection
- Wireless signal problems
- Router/firewall under load

**Solution Suggestions:**
1. Ping other servers (is problem isolated?)
2. Use MTR to find which hop has the loss
3. Contact ISP


### Troubleshooting Strategy with Ping

**Systematic Approach:**

```
1. Loopback test:
   $ ping 127.0.0.1
   ✓ Is TCP/IP stack working?

2. Local machine:
   $ ping $(hostname -I)
   ✓ Is network interface active?

3. Gateway:
   $ ping 192.168.1.1
   ✓ Can I reach local network?

4. DNS server:
   $ ping 8.8.8.8
   ✓ Do I have internet connection?

5. Domain name:
   $ ping google.com
   ✓ Is DNS resolution working?

6. Target server:
   $ ping target-server.com
   ✓ Is target reachable?
```

---

## MTR: My Traceroute - Advanced Network Diagnostics Tool

### What is MTR?

**MTR (My TraceRoute)** is a powerful combination of ping and traceroute. Developed by Matt Kimball, it monitors the network path and performance at each hop in real-time.

> MTR is also known as "Matt's TraceRoute".

### MTR vs Ping vs Traceroute

| Feature | Ping | Traceroute | MTR |
|---------|------|------------|-----|
| Target testing | ✅ | ❌ | ✅ |
| Path display | ❌ | ✅ | ✅ |
| Per-hop statistics | ❌ | ❌ | ✅ |
| Real-time | ✅ | ❌ | ✅ |
| Packet loss analysis | ✅ | ❌ | ✅ |
| Interactive | ❌ | ❌ | ✅ |

### How Does MTR Work?

MTR combines traceroute's TTL trick with ping's continuous monitoring capability:

```
1. Send ICMP/UDP packet with TTL=1
   → First router returns "Time Exceeded"
   → First hop determined

2. Send packet with TTL=2
   → Second router returns "Time Exceeded"
   → Second hop determined

3. ... Continues this way

4. Continuously pings each hop
   → Calculates packet loss, latency, jitter
   → Updates real-time statistics
```

### MTR Installation

```bash
# Debian/Ubuntu
sudo apt-get install mtr

# RHEL/CentOS/Fedora
sudo yum install mtr

# macOS
brew install mtr

# Windows
WinMTR download: https://sourceforge.net/projects/winmtr/
```

### Basic MTR Usage

#### Simple Usage
```bash
$ mtr google.com

# Or report mode
$ mtr --report --report-cycles 10 google.com
```

**Interactive Interface:**
```
                             My traceroute  [v0.95]
localhost (192.168.1.100)                          2024-11-25T10:30:45+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                       Packets               Pings
 Host                                Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. _gateway (192.168.1.1)            0.0%    10    1.2   1.3   1.1   1.8   0.2
 2. 10.20.30.1                        0.0%    10    8.4   9.1   7.9  12.3   1.4
 3. 81.213.147.1                      0.0%    10   12.3  13.2  11.8  16.7   1.6
 4. 195.175.193.141                   0.0%    10   14.5  15.1  13.9  18.2   1.3
 5. 72.14.223.66                      0.0%    10   15.2  16.0  14.8  19.1   1.5
 6. 108.170.252.193                   0.0%    10   15.8  16.5  15.1  19.8   1.6
 7. 142.251.226.67                    0.0%    10   16.1  16.8  15.4  20.2   1.7
 8. lhr25s35-in-f14.1e100.net         0.0%    10   15.9  16.4  15.2  19.5   1.4
```

**Column Descriptions:**

| Column | Description |
|-------|----------|
| **Host** | Router/host at each hop (IP + hostname) |
| **Loss%** | Packet loss percentage at that hop |
| **Snt** | Total number of packets sent |
| **Last** | Round-trip time of last packet |
| **Avg** | Average RTT |
| **Best** | Best (minimum) RTT |
| **Wrst** | Worst (maximum) RTT |
| **StDev** | Standard deviation (jitter indicator) |

### MTR Parameters

#### 1. Report Mode (-r / --report)
```bash
# Send 100 packets and generate report
$ mtr --report --report-cycles 100 google.com

Start: 2024-11-25T10:30:45+0000
HOST: localhost                   Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                   0.0%   100    1.2   1.3   1.0   3.2   0.3
  2.|-- 10.20.30.1                 0.0%   100    8.5   9.2   7.8  15.6   1.5
  3.|-- 81.213.147.1               0.0%   100   12.4  13.3  11.7  22.1   2.1
  4.|-- 195.175.193.141            0.0%   100   14.6  15.2  13.8  24.5   2.3
  5.|-- 72.14.223.66               1.0%   100   15.3  16.1  14.7  28.9   2.8
  6.|-- 108.170.252.193            0.0%   100   15.9  16.6  15.0  26.7   2.4
  7.|-- 142.251.226.67             0.0%   100   16.2  16.9  15.3  29.3   2.9
  8.|-- lhr25s35-in-f14.1e100.net  0.0%   100   16.0  16.5  15.1  27.8   2.6
```

**Usage:** Use in scripts, log analysis

#### 2. Interval Setting (-i / --interval)
```bash
# Send packet every 5 seconds (default 1 second)
$ mtr -i 5 google.com

# Fast mode: 0.1 second (requires root)
$ sudo mtr -i 0.1 google.com
```

#### 3. Packet Size (-s / --psize)
```bash
# Send 1000 byte packets
$ mtr -s 1000 google.com
```

#### 4. IP Version Selection (-4 / -6)
```bash
# Force IPv4
$ mtr -4 google.com

# Force IPv6
$ mtr -6 google.com
```

#### 5. Using TCP or UDP (-T / -u)
```bash
# Use TCP (default is ICMP)
$ mtr -T -P 80 google.com
# -P: Port number

# Use UDP
$ mtr -u google.com
```

**Why TCP/UDP?**
- Some firewalls block ICMP
- TCP/UDP packets better simulate real application traffic

#### 6. Maximum Hop Count (-m / --max-ttl)
```bash
# Check maximum 20 hops (default 30)
$ mtr -m 20 google.com
```

#### 7. Disable Hostname Resolution (-n / --no-dns)
```bash
# Don't do DNS lookup, show only IP (faster)
$ mtr -n google.com

HOST: localhost                   Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- 192.168.1.1                0.0%    10    1.2   1.3   1.1   1.8   0.2
  2.|-- 10.20.30.1                 0.0%    10    8.4   9.1   7.9  12.3   1.4
  3.|-- 81.213.147.1               0.0%    10   12.3  13.2  11.8  16.7   1.6
```

#### 8. Show AS Number (-z / --aslookup)
```bash
# Show AS (Autonomous System) number of each hop
$ mtr -z google.com

HOST: localhost                   Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                   0.0%    10    1.2   1.3   1.1   1.8   0.2
  2.|-- AS15897 10.20.30.1         0.0%    10    8.4   9.1   7.9  12.3   1.4
  3.|-- AS15897 81.213.147.1       0.0%    10   12.3  13.2  11.8  16.7   1.6
  4.|-- AS15169 195.175.193.141    0.0%    10   14.5  15.1  13.9  18.2   1.3
```

**AS Number:** Each ISP/organization's unique internet routing number

#### 9. CSV/JSON/XML Output
```bash
# CSV format
$ mtr --csv --report -c 10 google.com

# JSON format
$ mtr --json --report -c 10 google.com

# XML format
$ mtr --xml --report -c 10 google.com
```

#### 10. Interactive Mode Shortcuts

```
h - Help
d - Change display mode
r - Restart statistics
p - Pause/Unpause
q - Quit
```

### Real World MTR Examples and Analysis

#### Example 1: Healthy Connection
```bash
$ mtr --report -c 50 cloudflare.com

Start: 2024-11-25T11:00:00+0000
HOST: localhost                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway (192.168.1.1)            0.0%    50    1.1   1.2   0.9   2.1   0.2
  2.|-- 10.20.30.1                        0.0%    50    7.8   8.3   7.2  11.2   0.9
  3.|-- 81.213.147.1                      0.0%    50   11.5  12.1  10.8  15.3   1.1
  4.|-- 195.175.193.141                   0.0%    50   13.2  13.8  12.5  17.8   1.2
  5.|-- 104.16.132.229                    0.0%    50    7.8   8.2   7.1  11.5   1.0
```

**Analysis:**
> ✅ 0% loss at all hops \
    ✅ Low and consistent latency \
    ✅ Low StDev (no jitter) \
    ✅ Straight performance line

**Result:** Excellent connection quality

#### Example 2: Problem at Specific Hop
```bash
$ mtr --report -c 100 problematic-site.com

HOST: localhost                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                           0.0%   100    1.2   1.3   1.0   2.5   0.2
  2.|-- 10.20.30.1                         0.0%   100    8.4   8.9   7.8  12.1   0.9
  3.|-- 81.213.147.1                      15.0%   100   45.3  52.1  12.3 198.7  34.2
  4.|-- 195.175.193.141                   14.0%   100   56.7  63.4  14.2 215.3  38.9
  5.|-- 203.0.113.1                       13.0%   100   58.9  65.1  15.1 218.9  39.1
  6.|-- target-server.com                 12.0%   100   59.3  65.8  15.5 220.1  39.5
```

**Analysis:**
> ❌ 15% loss starting from 3rd hop \
    ❌ High StDev (34-39ms) - Serious jitter \
    ❌ Very high worst case (198-220ms) \
    ⚠️ Loss rate gradually decreasing (15% → 12%)

**Comment:**
- **3rd hop is problematic:** Probably ISP's backbone router
- **Loss decreasing:** Subsequent hops giving low priority to ICMP (ICMP rate limiting)
- **Real problem:** 3rd hop - Should contact ISP

**Important Note:** If loss is only at last hop, it's usually not significant (ICMP rate limiting).


### Advanced MTR Usage

#### 1. Continuous Monitoring Script
```bash
#!/bin/bash
# mtr-monitor.sh

TARGET="critical-server.com"
THRESHOLD=5  # 5% loss threshold
LOG_FILE="/var/log/mtr-monitor.log"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Get MTR report
    REPORT=$(mtr --report -c 20 --no-dns $TARGET)

    # Check packet loss
    LOSS=$(echo "$REPORT" | tail -1 | awk '{print $3}' | tr -d '%')
    
    if (( $(echo "$LOSS > $THRESHOLD" | bc -l) )); then
        echo "[$TIMESTAMP] ALERT: Packet loss $LOSS% detected!" >> $LOG_FILE
        echo "$REPORT" >> $LOG_FILE
        
        # Send email/Slack notification
        # mail -s "Network Alert" admin@cyclechain.io < $LOG_FILE
    fi
    
    sleep 300  # Check every 5 minutes
done
```


### Interpreting MTR Output: Best Practices

#### 1. Interpreting Packet Loss

**Loss Only at Last Hop:**
```
Hops 1-7: 0% loss
Hop 8 (destination): 10% loss
```
→ **Probably insignificant** (ICMP rate limiting)

**Loss at Middle Hop:**
```
Hops 1-3: 0% loss
Hop 4: 15% loss
Hops 5-8: 15% loss
```
→ **Serious problem** - Entire path after hop 4 is affected

**Gradually Increasing Loss:**
```
Hop 1: 0%
Hop 2: 5%
Hop 3: 10%
Hop 4: 15%
```
→ **Chain effect** - Find first problematic hop

#### 2. Latency Pattern Analysis

**Regular Increase (Normal):**
```
Hop 1:  1ms
Hop 2: 10ms (+9ms)
Hop 3: 20ms (+10ms)
Hop 4: 30ms (+10ms)
```
→ Each hop adding similar delay - **normal**

**Sudden Jump:**
```
Hop 1:  1ms
Hop 2: 10ms
Hop 3: 150ms (+140ms!)
Hop 4: 160ms (+10ms)
```
→ **Problem at hop 3** - International connection, load etc.

**Decreasing Latency (Abnormal):**
```
Hop 1: 50ms
Hop 2: 30ms (???)
Hop 3: 40ms
```
→ **Asymmetric routing** or **time synchronization issue**

#### 3. Jitter (StDev) Evaluation

```
StDev < 5ms:   Excellent - Ideal for real-time applications
StDev 5-20ms:  Good - Sufficient for most applications
StDev 20-50ms: Medium - May have issues with VoIP
StDev > 50ms:  Bad - Serious instability
```

**Important for VoIP:**
- Jitter > 30ms → Voice quality drops
- Latency > 150ms → Delay is noticeable
- Packet loss > 1% → Voice dropouts

---

## Conclusion

In this guide, we've examined the ICMP protocol, ping command, and MTR tool in depth, starting from the basics of the internet.

### Summary of What We've Learned:

1. **Internet Architecture**
   - Flexible and resilient thanks to packet switching
   - Layered architecture (TCP/IP) provides modularity
   - Routing works with distributed intelligence

2. **ICMP Protocol**
   - Control and error notification layer of IP
   - Foundation of tools like ping and traceroute
   - Should be used in controlled manner for security

3. **Ping Command**
   - Simple but powerful diagnostic tool
   - Reachability, latency and loss detection
   - First step of systematic troubleshooting

4. **MTR Tool**
   - Advanced version of ping + traceroute
   - Real-time, statistical analysis
   - Very effective in localizing network problems

### Mastering Yoda & Resources:

**RFC Documents:**
- [RFC 791: Internet Protocol (IP)](https://www.rfc-editor.org/rfc/rfc791 "{nofollow} RFC 791 - Internet Protocol")
- [RFC 792: Internet Control Message Protocol (ICMP)](https://www.rfc-editor.org/rfc/rfc792 "{nofollow} RFC 792 - Internet Control Message Protocol")
- [RFC 2151: A Primer On Internet and TCP/IP Tools and Utilities](https://www.rfc-editor.org/rfc/rfc2151 "{nofollow} RFC 2151 - A Primer On Internet and TCP/IP Tools")
- [RFC 4443: Internet Control Message Protocol (ICMPv6)](https://www.rfc-editor.org/rfc/rfc4443 "{nofollow} RFC 4443 - Internet Control Message Protocol for IPv6")

**Books:**
- ["TCP/IP Illustrated, Volume 1" - W. Richard Stevens](https://www.amazon.com/TCP-Illustrated-Vol-Addison-Wesley-Professional/dp/0201633469 "{nofollow} TCP/IP Illustrated book")
- ["Computer Networks" - Andrew S. Tanenbaum](https://www.amazon.com/Computer-Networks-5th-Andrew-Tanenbaum/dp/0132126952 "{nofollow} Computer Networks book")
- ["The TCP/IP Guide" - Charles M. Kozierok](http://www.tcpipguide.com/ "{nofollow} The TCP/IP Guide website")

**Online Tools:**
- [https://mtr.sh](https://mtr.sh "{nofollow} Web-based MTR tool") - Web-based MTR
- [https://www.subnet-calculator.com](https://www.subnet-calculator.com "{nofollow} IP calculation tool") - IP calculation
- [https://bgp.he.net](https://bgp.he.net "{nofollow} BGP routing info tool") - BGP routing information
- [https://ping.pe](https://ping.pe "{nofollow} Global Ping and MTR visualization tool") - Global Ping & MTR (Colored block visualization)
- [https://www.uptrends.com/tools/traceroute](https://www.uptrends.com/tools/traceroute "{nofollow} Map-based traceroute display") - Map-based Visual Traceroute
- [https://maplatency.com](https://maplatency.com "{nofollow} World-wide ping heat map") - Visual Ping Heat Map (Heatmap)
- [https://toolbox.googleapps.com/apps/dig](https://toolbox.googleapps.com/apps/dig "{nofollow} Google Dig and Trace tool") - Google Admin Dig & Trace
- [https://tools.keycdn.com/traceroute](https://tools.keycdn.com/traceroute "{nofollow} Geo-located traceroute") - Geo-Location Traceroute
- [https://radar.cloudflare.com](https://radar.cloudflare.com "{nofollow} Real-time internet traffic and attack map") - Cloudflare Radar (Traffic Map)
- [https://lg.ring.nlnog.net](https://lg.ring.nlnog.net "{nofollow} NLNOG Looking Glass tool") - Multi-Location Looking Glass (Command line outputs)
- [https://threatmap.fortiguard.com](https://threatmap.fortiguard.com "{nofollow} Live cyber attack map") - Live Cyber Threat Map (Visual)

### Final Word

The Internet is one of the most complex and impressive engineering achievements in human history. Therefore, the tools we examined are the most basic ways to check the health of this massive structure and diagnose problems.

Pinging is not just sending a packet and waiting for a response; it's being part of the network that connects billions of people together. Every ICMP Echo Request is a small ambassador that embarks on a journey through the nervous system of the internet.

When you monitor your network with MTR, you're actually observing the data flow over fiber optic cables stretching around the world, giant data centers, and countless routers.

> I also published a longer, more detailed version (with extra examples) on my blog: [https://cyclechain.io/blog/en/p/anatomy-of-network-diagnostics-icmp-ping-mtr/](https://cyclechain.io/blog/en/p/anatomy-of-network-diagnostics-icmp-ping-mtr/ "Deep Dive into the Internet: The Anatomy of Network Diagnostics with ICMP, Ping, and MTR") - Deep Dive into the Internet: The Anatomy of Network Diagnostics with ICMP, Ping, and MTR

---

*Last updated: November 25, 2024*
*Author: Fatih Mert Doğancan*
*License: Creative Commons BY-SA 4.0*