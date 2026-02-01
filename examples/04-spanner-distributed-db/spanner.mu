---
title: "Spanner: Google's Globally-Distributed Database"
author: Wilson Hsieh
theme: google-blue
---

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                                                                │
│              **Spanner: Google's**                             │
│           **Globally-Distributed Database**                    │
│                                                                │
│                      Wilson Hsieh                              │
│                representing a host of authors                  │
│                                                                │
│                       OSDI 2012                                │
│                                                                │
│                       [Google]                                 │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Title slide with Google logo at bottom
> Blue gradient background typical of Google presentations

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                    **What is Spanner?**                        │
│                                                                │
│  • **Distributed multiversion database**                       │
│    ▪ General-purpose transactions (ACID)                       │
│    ▪ SQL query language                                        │
│    ▪ Schematized tables                                        │
│    ▪ Semi-relational data model                                │
│                                                                │
│  • **Running in production**                                   │
│    ▪ Storage for Google's ad data                              │
│    ▪ Replaced a sharded MySQL database                         │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Introduction to Spanner's key features
> Two main bullet groups: capabilities and production status

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                  **Example: Social Network**                   │
│                                                                │
│      ┌─────────┐                              ┌─────────┐     │
│      │ x1000   │ San Francisco                │ x1000   │ Sao Paulo │
│      │ ░░░░░   │ Seattle          ┌────────┐  │ ░░░░░   │ Santiago │
│      │ ░░░░░   │ Arizona          │User    │  │ ░░░░░   │ Buenos Aires │
│      └─────────┘                  │posts   │  └─────────┘     │
│         US                        │Friend  │    Brazil        │
│                                   │lists   │                  │
│      ┌─────────┐                  └────────┘  ┌─────────┐     │
│      │ x1000   │ London                       │ x1000   │ Moscow │
│      │ ░░░░░   │ Paris                        │ ░░░░░   │ Berlin │
│      │ ░░░░░   │ Berlin                       │ ░░░░░   │ Krakow │
│      └─────────┘ Madrid                       └─────────┘     │
│        Spain     Lisbon                         Russia        │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> World map showing data distribution across 4 regions
> Each region has x1000 servers storing user posts and friend lists
> Central database icon showing shared data model
> US (green), Spain (orange), Brazil (red), Russia (purple)

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                        **Overview**                            │
│                                                                │
│  • **Feature:** Lock-free distributed read transactions        │
│                                                                │
│  • **Property:** External consistency of distributed           │
│    transactions                                                │
│    ▪ First system at global scale                              │
│                                                                │
│  • **Implementation:** Integration of concurrency              │
│    control, replication, and 2PC                               │
│    ▪ Correctness and performance                               │
│                                                                │
│  • **Enabling technology:** TrueTime                           │
│    ▪ Interval-based global time                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Four key aspects of Spanner
> Feature, Property, Implementation, Enabling technology

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                    **Read Transactions**                       │
│                                                                │
│  • Generate a page of friends' recent posts                    │
│    ▪ Consistent view of friend list and their posts            │
│                                                                │
│                                                                │
│                                                                │
│                   **Why consistency matters**                  │
│                                                                │
│       1. Remove untrustworthy person X as friend               │
│                                                                │
│       2. Post P: "My government is repressive..."              │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Motivating example for why consistency matters
> Privacy scenario: unfriending before posting sensitive content
> Without consistency, X might still see post P

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                     **Single Machine**                         │
│                                                                │
│          Block writes                                          │
│              ║                                                 │
│  Friend1 post─╫────────→┌──────────────┐                       │
│  Friend2 post─╫────────→│  User posts  │←── Generate my page   │
│       ...     ║         │  Friend lists│                       │
│  Friend999 post─╫──────→│              │                       │
│  Friend1000 post─╫─────→└──────────────┘                       │
│              ║                                                 │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Single machine scenario
> All writes blocked during read transaction
> Single database contains user posts and friend lists
> Orange/peach colored database cylinder

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                   **Multiple Machines**                        │
│                                                                │
│          Block writes                                          │
│              ║                                                 │
│  Friend1 post─╫───────→┌──────────────┐                        │
│  Friend2 post─╫───────→│  User posts  │←─┐                     │
│              ║         │  Friend lists│  │                     │
│       ...    ║         └──────────────┘  │   Generate          │
│              ║                           ├─── my page          │
│  Friend999 post─╫─────→┌──────────────┐  │                     │
│  Friend1000 post─╫────→│  User posts  │←─┘                     │
│              ║         │  Friend lists│                        │
│                        └──────────────┘                        │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Two machines scenario - data sharded across machines
> Both machines need to be blocked for consistent read
> Green database (top) and pink database (bottom)

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                  **Multiple Datacenters**                      │
│                                                                │
│  Friend1 post ──→  ┌──────────┐ x1000                          │
│      US            │ ░░░░░░░░ │  ←─┐                           │
│                    └──────────┘    │                           │
│  Friend2 post ──→  ┌──────────┐ x1000                          │
│     Spain          │ ░░░░░░░░ │  ←─┤   Generate                │
│       ...          └──────────┘    ├───  my page               │
│  Friend999 post ─→ ┌──────────┐ x1000                          │
│     Brazil         │ ░░░░░░░░ │  ←─┤                           │
│                    └──────────┘    │                           │
│  Friend1000 post → ┌──────────┐ x1000                          │
│     Russia         │ ░░░░░░░░ │  ←─┘                           │
│                    └──────────┘                                │
└────────────────────────────────────────────────────────────────┘

> Scaling to multiple datacenters worldwide
> Each region has x1000 servers (stacked cylinders)
> US (green), Spain (orange), Brazil (red), Russia (purple)
> No global lock - need different approach

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                   **Version Management**                       │
│                                                                │
│  • Transactions that write use strict 2PL                      │
│    ▪ Each transaction T is assigned a timestamp s              │
│    ▪ Data written by T is timestamped with s                   │
│                                                                │
│   ┌──────────┬───────────┬───────────┬───────────┐            │
│   │   Time   │    <8     │     8     │    15     │            │
│   ├──────────┼───────────┼───────────┼───────────┤            │
│   │My friends│    [X]    │    []     │           │            │
│   │My posts  │           │           │    [P]    │            │
│   │X's friends│   [me]   │    []     │           │            │
│   └──────────┴───────────┴───────────┴───────────┘            │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Multiversion concurrency control
> Table showing data versions at different timestamps
> At time 8: unfriending happens (both remove each other)
> At time 15: post P is made

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                 **Synchronizing Snapshots**                    │
│                                                                │
│                                                                │
│                    Global wall-clock time                      │
│                                                                │
│                            ==                                  │
│                                                                │
│                   External Consistency:                        │
│        Commit order respects global wall-time order            │
│                                                                │
│                            ==                                  │
│                                                                │
│      Timestamp order respects global wall-time order           │
│                          given                                 │
│              timestamp order == commit order                   │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Key insight: equivalence chain
> Global time = External consistency = Timestamp order
> Foundation of Spanner's correctness

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                 **Timestamps, Global Clock**                   │
│                                                                │
│  • Strict two-phase locking for write transactions             │
│  • Assign timestamp while locks are held                       │
│                                                                │
│                                                                │
│         Acquired locks                    Release locks        │
│              ↓                                  ↓               │
│   ┌──┐  ├────┼──────────────────────────────────┼────┤         │
│   │  │  │ T  │                                  │    │         │
│   └──┘  ├────┴──────────────────────────────────┴────┤         │
│              ↑                                                 │
│         Pick s = now()                                         │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Timeline diagram showing transaction T
> Timestamp assigned after acquiring locks, before releasing
> Purple cylinder represents database server

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                  **Timestamp Invariants**                      │
│                                                                │
│  • **Timestamp order == commit order**                         │
│                                                                │
│   ┌────┐  T₁ ├───────────────────┼──────────┼────────┤        │
│   │    │                                                       │
│   └────┘  T₂ ├────┼────┼─────────────────────────────┤        │
│                                                                │
│  • **Timestamp order respects global wall-time order**         │
│                                                                │
│   ┌────┐  T₃ ├────┼────┼────┤                                 │
│   │    │                                                       │
│   └────┘                  T₄ ├─────────┼──────────┼─────┤     │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Two key invariants for correctness
> First: transactions on same server maintain timestamp=commit order
> Second: across servers, wall-time order is respected
> Green and purple cylinders represent different servers

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                        **TrueTime**                            │
│                                                                │
│  • "Global wall-clock time" with bounded uncertainty           │
│                                                                │
│                                                                │
│                                                                │
│                ┌─────────────────────┐                         │
│        ────────┤     TT.now()        ├──────────→ time         │
│                └─────────────────────┘                         │
│                ↑                     ↑                         │
│            earliest              latest                        │
│                ←───────────────────→                           │
│                        2*ε                                     │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> TrueTime API returns an interval, not a point
> True time is guaranteed to be within [earliest, latest]
> Uncertainty bound is 2*epsilon

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                 **Timestamps and TrueTime**                    │
│                                                                │
│         Acquired locks                    Release locks        │
│              ↓                                  ↓               │
│   ┌──┐  ├────┼─────────────┼────┼───────────────┼────┤         │
│   │  │  │ T  │             │    │               │    │         │
│   └──┘  ├────┴─────────────┴────┴───────────────┴────┤         │
│              ↑             ↑    ↑                              │
│     Pick s = TT.now().latest   Wait until                      │
│                            s   TT.now().earliest > s           │
│                                                                │
│                ←─────────────────→                             │
│                    Commit wait                                 │
│                 average ε │ average ε                          │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Commit wait: wait out the uncertainty
> Pick timestamp at latest bound, wait until earliest passes it
> Total wait time is approximately 2*epsilon (average)

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                **Commit Wait and Replication**                 │
│                                                                │
│   ┌────┐                                                       │
│   │    │  Start consensus    Achieve consensus  Notify slaves  │
│   └────┘         ↓                  ↓                ↓         │
│                                                                │
│         Acquired locks                         Release locks   │
│              ↓                                      ↓          │
│   ┌──┐  ├────┼────────────────────┼────────────────┼────┤     │
│   │  │  │ T  │                    │                │    │     │
│   └──┘  ├────┴────────────────────┴────────────────┴────┤     │
│              ↑                    ↑                            │
│           Pick s            Commit wait done                   │
│                                                                │
│   ┌────┐                                                       │
│   └────┘                                                       │
└────────────────────────────────────────────────────────────────┘

> Commit wait overlaps with Paxos consensus
> Three purple cylinders: leader and two replicas
> Consensus achieved during commit wait period

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│               **Commit Wait and 2-Phase Commit**               │
│                                                                │
│                Start logging   Done logging                    │
│                      ↓              ↓                          │
│              Acquired locks              Release locks         │
│   ┌────┐ TC  ├──┼────┼──────────┼──────────────┼─┤ Committed  │
│   │    │          ↓            ↗↑              ↓               │
│   └────┘     Acquired locks     │        Release locks         │
│   ┌────┐ TP1 ├─────┼────────────┼────────────────┼─┤          │
│   │    │                       Prepared                        │
│   └────┘     Acquired locks    Send s    Release locks         │
│   ┌────┐ TP2 ├──┼──────────────┼────────────────┼─┤           │
│   │    │        ↑              ↑                ↑              │
│   └────┘   Compute s      Compute     Commit wait done         │
│            for each       overall s    Notify participants     │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> 2PC with TrueTime integration
> TC = Transaction Coordinator, TP1/TP2 = Participants
> Each participant computes local s, coordinator picks max

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                        **Example**                             │
│                                                                │
│        Remove X from                           Risky post P    │
│        my friend list                                          │
│             ↓                                       ↓          │
│   ┌────┐TC  ├────────────────┼──────────────┤  T₂ ├────┼────┤ │
│   │    │    sC=6             s=8            │      │   s=15   │
│   └────┘         Remove myself                                 │
│                  from X's friend list                          │
│   ┌────┐TP  ├──────────────────────────────────────────┼────┤ │
│   │    │    sP=8                                       s=8     │
│   └────┘                                                       │
│   ┌──────────┬───────────┬───────────┬───────────┐            │
│   │   Time   │    <8     │     8     │    15     │            │
│   ├──────────┼───────────┼───────────┼───────────┤            │
│   │My friends│    [X]    │    []     │           │            │
│   │My posts  │           │           │    [P]    │            │
│   │X's friends│   [me]   │    []     │           │            │
│   └──────────┴───────────┴───────────┴───────────┘            │
└────────────────────────────────────────────────────────────────┘

> Concrete example showing the social network scenario
> TC proposes s=6, TP proposes s=8, final s=max(6,8)=8
> Post P gets timestamp 15, after unfriending at 8
> X can never see post P due to consistent snapshots

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                  **What Have We Covered?**                     │
│                                                                │
│  • Lock-free read transactions across datacenters              │
│                                                                │
│  • External consistency                                        │
│                                                                │
│  • Timestamp assignment                                        │
│                                                                │
│  • TrueTime                                                    │
│    ▪ Uncertainty in time can be waited out                     │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Summary of main topics covered so far
> Four key concepts explained

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                **What Haven't We Covered?**                    │
│                                                                │
│  • How to read at the present time                             │
│                                                                │
│  • Atomic schema changes                                       │
│    ▪ Mostly non-blocking                                       │
│    ▪ Commit in the future                                      │
│                                                                │
│  • Non-blocking reads in the past                              │
│    ▪ At any sufficiently up-to-date replica                    │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Topics not covered in this talk
> Refer to paper for details

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                  **TrueTime Architecture**                     │
│                                                                │
│   ┌──────────────┬──────────────┬─────┬──────────────┐        │
│   │  Datacenter 1│  Datacenter 2│ ... │  Datacenter n│        │
│   ├──────────────┼──────────────┼─────┼──────────────┤        │
│   │ ┌────┐┌────┐ │ ┌────┐┌────┐ │     │ ┌────┐┌────┐ │        │
│   │ │GPS ││GPS │ │ │GPS ││Atom│ │     │ │GPS ││GPS │ │        │
│   │ │time││time│ │ │time││clk │ │     │ │time││time│ │        │
│   │ └──┬─┘└──┬─┘ │ └──┬─┘└──┬─┘ │     │ └──┬─┘└──┬─┘ │        │
│   │    │     │   │    └──┬──┘   │     │    │     │   │        │
│   │    └──┬──┘   │       │      │     │    └──┬──┘   │        │
│   │       ↓      │       └──────┼─────┼──────→│      │        │
│   │   ┌──────┐   │              │     │   ┌──────┐   │        │
│   │   │Client│   │              │     │   │Client│   │        │
│   │   └──────┘   │              │     │   └──────┘   │        │
│   └──────────────┴──────────────┴─────┴──────────────┘        │
│                                                                │
│       Compute reference [earliest, latest] = now ± ε          │
└────────────────────────────────────────────────────────────────┘

> TrueTime infrastructure across datacenters
> GPS timemasters provide reference time
> Atomic clock timemaster provides backup
> Clients poll multiple timemasters

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                 **TrueTime Implementation**                    │
│                                                                │
│        now = reference now + local-clock offset                │
│        ε = reference ε + worst-case local-clock drift          │
│                                                                │
│         ε                                                      │
│       +6ms ┤           ╱          ╱          ╱                 │
│            │         ╱          ╱          ╱                   │
│            │       ╱          ╱          ╱      200 μs/sec     │
│            │     ╱          ╱          ╱                       │
│   reference│   •          •          •                         │
│  uncertainty├────────┼────────┼────────┼────────→ time         │
│            0sec    30sec    60sec    90sec                     │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Sawtooth pattern: uncertainty grows between syncs
> Reference uncertainty at sync points (dots)
> 200 microseconds/second drift rate
> Sync every 30 seconds keeps epsilon bounded

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│               **What If a Clock Goes Rogue?**                  │
│                                                                │
│  • Timestamp assignment would violate external                 │
│    consistency                                                 │
│                                                                │
│  • Empirically unlikely based on 1 year of data                │
│    ▪ Bad CPUs 6 times more likely than bad clocks              │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Safety relies on clock correctness
> Empirical evidence shows clocks are reliable
> CPU failures more common than clock failures

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                **Network-Induced Uncertainty**                 │
│                                                                │
│    Epsilon (ms)                            Epsilon (ms)        │
│     10│┌────────────────────┐               6│┌────────────┐  │
│       ││▓▓▓▓ 99.9           │                ││▓▓▓▓ 99.9   │  │
│      8│├────────────────────┤               5│├────────────┤  │
│       ││░░░░░░░░░░░░░░░░░░░ │                ││░░░░░░░░░░░ │  │
│      6│├────────────────────┤               4│├─────────── │  │
│       ││████ 99             │                ││████ 99     │  │
│      4│├────────────────────┤               3│├────────────┤  │
│       ││                    │                ││            │  │
│      2│├────────────────────┤               2│├────────────┤  │
│       ││──── 90             │                ││──── 90     │  │
│       └┴────┬────┬────┬─────┘               1└┴────┬────┬──┘  │
│       Mar29 Mar30 Mar31 Apr1              6AM 8AM 10AM 12PM   │
│              Date                          Date (April 13)    │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Two graphs showing epsilon distribution over time
> Left: 4-day view (Mar 29 - Apr 1)
> Right: zoomed view of single day (April 13)
> 90th, 99th, 99.9th percentiles shown
> 99.9th percentile stays under 10ms

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                 **What's in the Literature**                   │
│                                                                │
│  • External consistency/linearizability                        │
│                                                                │
│  • Distributed databases                                       │
│                                                                │
│  • Concurrency control                                         │
│                                                                │
│  • Replication                                                 │
│                                                                │
│  • Time (NTP, Marzullo)                                        │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Related work from academic literature
> Builds on decades of distributed systems research

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                      **Future Work**                           │
│                                                                │
│  • **Improving TrueTime**                                      │
│    ▪ Lower ε < 1 ms                                            │
│                                                                │
│  • **Building out database features**                          │
│    ▪ Finish implementing basic features                        │
│    ▪ Efficiently support rich query patterns                   │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Two main areas for future development
> Lower latency through better time sync
> Richer database functionality

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                       **Conclusions**                          │
│                                                                │
│  • **Reify clock uncertainty in time APIs**                    │
│    ▪ Known unknowns are better than unknown unknowns           │
│    ▪ Rethink algorithms to make use of uncertainty             │
│                                                                │
│  • **Stronger semantics are achievable**                       │
│    ▪ Greater scale != weaker semantics                         │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Two key takeaways
> 1. Expose uncertainty in APIs, design around it
> 2. Scale doesn't require giving up strong consistency

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                         **Thanks**                             │
│                                                                │
│  • To the Spanner team and customers                           │
│                                                                │
│  • To our shepherd and reviewers                               │
│                                                                │
│  • To lots of Googlers for feedback                            │
│                                                                │
│  • To you for listening!                                       │
│                                                                │
│                                                                │
│  • **Questions?**                                              │
│                                                                │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Acknowledgments slide
> Standard thank you to team, reviewers, audience
