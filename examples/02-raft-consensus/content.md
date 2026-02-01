# Raft Consensus Algorithm

经典分布式系统论文讲解。Raft 是 Diego Ongaro 和 John Ousterhout 在 2014 年发表的共识算法，设计目标是比 Paxos 更容易理解。这份 slides 适合用于技术分享或论文讲解。

---

## Slide 1: Title

**In Search of an Understandable Consensus Algorithm**

*The Raft Consensus Algorithm*

Diego Ongaro and John Ousterhout
Stanford University

USENIX ATC 2014

---

## Slide 2: What is Consensus?

**What is Consensus?**

The problem:
- Multiple servers need to agree on a single value
- Servers may fail or be unreachable
- Network may be slow or partition

**Real-world examples**:
- Leader election in a cluster
- Distributed configuration (etcd, Consul)
- Replicated state machines (databases)

**Requirements**:
1. Safety: Never return incorrect result
2. Availability: Functional if majority are alive
3. Timing: Does not depend on clock synchronization

---

## Slide 3: The Problem with Paxos

**The Problem with Paxos**

Paxos has been the gold standard since 1990, but...

- **Hard to understand**: Complex multi-phase protocol
- **Hard to implement**: Many details left unspecified
- **No practical guidance**: Academic paper, not engineering guide

> "There are significant gaps between the description of the Paxos algorithm and the needs of a real-world system."
> — Chubby authors (Google)

**Goal of Raft**: Equivalent correctness, much easier to understand.

---

## Slide 4: Raft Overview

**Raft: Decomposed Consensus**

Three sub-problems:

```
┌─────────────────┐
│  Leader Election │ ← Choose one leader
├─────────────────┤
│  Log Replication │ ← Leader replicates to followers
├─────────────────┤
│     Safety       │ ← Maintain consistency
└─────────────────┘
```

Key insight: **Strong leader model**
- Leader handles all client requests
- Simplifies reasoning about the system
- Only one direction for data flow (leader → followers)

---

## Slide 5: Server States

**Server States**

Three possible states:

```
              times out,           receives votes
              starts election      from majority
         ┌──────────┐         ┌──────────┐
         │          │         │          │
         ▼          │         ▼          │
    ┌─────────┐     │    ┌─────────┐     │
    │ Follower│─────┴───▶│Candidate│─────┴───▶┌─────────┐
    └─────────┘          └─────────┘          │ Leader  │
         ▲                    │               └─────────┘
         │                    │                    │
         │   discovers current leader             │
         │   or new term                          │
         └────────────────────┴────────────────────┘
```

- **Follower**: Passive, responds to requests
- **Candidate**: Trying to become leader
- **Leader**: Handles all client interactions

---

## Slide 6: Terms

**Terms: Logical Clock**

```
     Term 1        Term 2       Term 3       Term 4
   ┌─────────────┬────────────┬───────────┬────────────┐
   │ Election │  │ Election │ │ Election │  Normal    │
   │   │      │  │   │      │ │   │      │ Operation  │
   │   └──────│  │   └──────│ │   └──────│            │
   │   Leader │  │   Split  │ │   Leader │            │
   │   Found  │  │   Vote   │ │   Found  │            │
   └─────────────┴────────────┴───────────┴────────────┘
                      Time ────────────────────────────▶
```

- Each term has at most one leader
- Terms act as a logical clock
- Servers detect obsolete information by comparing terms
- If a server's term is smaller, it updates to larger term

---

## Slide 7: Leader Election

**Leader Election**

Process:
1. Follower times out (no heartbeat from leader)
2. Converts to Candidate, increments term
3. Votes for itself
4. Sends RequestVote RPCs to all servers
5. Wins if receives majority votes

Vote rules:
- Each server votes once per term
- Vote for first candidate that:
  - Has term ≥ server's term
  - Has log at least as up-to-date

**Randomized election timeouts** prevent split votes.

---

## Slide 8: Log Replication

**Log Replication**

```
Client ──▶ Leader ──AppendEntries──▶ Followers
                                          │
             ◀───────Ack──────────────────┘
             │
       Commit Entry
             │
             ▼
       Apply to State Machine
```

Log structure:
```
Index:  1    2    3    4    5    6
       ┌────┬────┬────┬────┬────┬────┐
Term:  │ 1  │ 1  │ 1  │ 2  │ 2  │ 2  │
       ├────┼────┼────┼────┼────┼────┤
Cmd:   │x←3 │y←1 │y←9 │x←2 │x←4 │z←7 │
       └────┴────┴────┴────┴────┴────┘
```

- Leader appends command to local log
- Sends AppendEntries RPC to followers
- Once majority acknowledge, leader commits
- Leader notifies followers of committed entries

---

## Slide 9: Log Matching Property

**Log Matching Property**

**Two guarantees**:
1. If two entries in different logs have same index and term, they store the same command
2. If two entries have same index and term, all preceding entries are also identical

How it's maintained:
- Leader creates only one entry per index in a given term
- AppendEntries consistency check:
  - RPC includes index & term of entry preceding new ones
  - Follower refuses if it doesn't match
  - Leader decrements nextIndex and retries

---

## Slide 10: Safety - Election Restriction

**Safety: Election Restriction**

Problem: How to ensure new leader has all committed entries?

Solution: **Voting restriction**

RequestVote includes candidate's last log entry (index, term).
Voter denies vote if its own log is more up-to-date.

More up-to-date means:
1. Last entry has higher term, OR
2. Same term but longer log

```
S1: [1][1][1][2]      ← Can be leader (longest with term 2)
S2: [1][1][1]         ← Cannot (shorter)
S3: [1][1]            ← Cannot (shorter)
```

This ensures leader completeness property.

---

## Slide 11: Committing Entries

**Committing Entries from Previous Terms**

Subtle issue:
- Leader cannot commit entries from previous terms by counting replicas
- Must commit an entry from current term first

```
(a) S1 is leader term 2, replicates to S2
     S1: [1][2]
     S2: [1][2]
     S3: [1]

(b) S1 crashes, S5 becomes leader term 3
     S5: [1][3]   ← Entry [2] not committed!

(c) S5 crashes, S1 becomes leader term 4
     Must replicate [4] first before [2] is considered committed
```

---

## Slide 12: Cluster Membership Changes

**Cluster Membership Changes**

Problem: Adding/removing servers without downtime

Naive approach is dangerous:
```
Cold: {S1, S2, S3}
Cnew: {S1, S2, S3, S4, S5}

At some point, two disjoint majorities could exist!
```

Raft solution: **Joint Consensus** (Coldnew)

1. Leader creates Coldnew config entry
2. Decisions require majorities from BOTH old and new
3. Once committed, leader creates Cnew entry
4. Old servers can be shut down

---

## Slide 13: Log Compaction

**Log Compaction (Snapshotting)**

Problem: Log grows unbounded

Solution: Periodic snapshots

```
┌─────────────────────────────────────────┐
│              Snapshot                   │
│  ┌─────────────────────────────────┐   │
│  │ last included index: 5          │   │
│  │ last included term: 3           │   │
│  │ state: {x=0, y=9, z=7}          │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
                        Log
                    ┌────┬────┬────┐
                    │ 4  │ 4  │ 5  │
                    └────┴────┴────┘
                     6    7    8
```

- Each server snapshots independently
- Includes last applied index/term
- Discard log entries up to that point
- InstallSnapshot RPC for slow followers

---

## Slide 14: Comparison with Paxos

**Raft vs Paxos**

| Aspect | Raft | Paxos |
|--------|------|-------|
| Leader | Strong, single | Weak, multiple |
| Log | Sequential, no gaps | May have gaps |
| Membership | Built-in | Not specified |
| Understandability | High | Low |
| Implementation | Clear guidance | Many variations |

Study results (43 students):
- Raft quiz scores: 25% higher on average
- 33 of 43 found Raft easier to understand

---

## Slide 15: Real-World Usage

**Real-World Implementations**

- **etcd**: Kubernetes' distributed key-value store
- **Consul**: HashiCorp's service mesh
- **TiKV**: Distributed transactional KV (used by TiDB)
- **CockroachDB**: Distributed SQL database
- **RethinkDB**: Realtime database
- **LogCabin**: Reference implementation by Ongaro

**Why Raft won**:
- Clear specification
- Reference implementation available
- Active community and tooling

---

## Slide 16: Summary

**Summary**

Raft achieves consensus through decomposition:

1. **Leader Election**: Randomized timeouts, majority voting
2. **Log Replication**: Leader-driven, strong consistency
3. **Safety**: Voting restriction, careful commit rules

**Key innovations**:
- Strong leader model
- Randomized election timeouts
- Joint consensus for membership changes
- Clear separation of concerns

**Resources**:
- Paper: raft.github.io
- Visualization: thesecretlivesofdata.com/raft

---

## 设计建议

- **配色**: 使用学术风格，蓝色为主色调
- **动画**: 可以为状态转换图添加动画
- **图表**: 使用清晰的框图和流程图
- **代码**: 伪代码使用等宽字体
