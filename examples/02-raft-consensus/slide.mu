---
title: Designing for Understandability: the Raft Consensus Algorithm
author: Diego Ongaro, John Ousterhout
theme: academic-blue
---


# 1

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                                                                │
│        **Designing for Understandability:**                    │
│           **the Raft Consensus Algorithm**                     │
│                                                                │
│                      Diego Ongaro                              │
│                     John Ousterhout                            │
│                                                                │
│                    Stanford University                         │
│                                                                │
│                      [PLATFORMLAB]                             │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Title slide with Stanford PlatformLab logo at bottom


# 2

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│              **Algorithms Should Be Designed For ...**         │
│                                                                │
│                                                                │
│                       Correctness?                             │
│                                                                │
│                                   Efficiency?                  │
│                                                                │
│              Conciseness?                                      │
│                                                                │
│                      **Understandability!**                    │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Words scattered across slide, building up
> "Understandability!" in red, emphasized as the answer
> Gray text for first three, red bold for the answer


# 3

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                         **Overview**                           │
│                                                                │
│  • **Consensus:**                                              │
│    ▪ Allows collection of machines to work as coherent group  │
│    ▪ Continuous service, even if some machines fail           │
│                                                                │
│  • **Paxos has dominated discussion for 25 years**            │
│    ▪ Hard to understand                                       │
│    ▪ Not complete enough for real implementations             │
│                                                                │
│  • **New consensus algorithm: Raft**                          │
│    ▪ Primary design goal: understandability                   │
│    ▪ Complete foundation for implementation                   │
│    ▪ Different problem decomposition                          │
│                                                                │
│  • **Results:**                                                │
│    ▪ User study shows Raft more understandable than Paxos     │
│    ▪ Widespread adoption                                      │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Bullet point overview slide
> "understandability" in red color


# 4

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                      **State Machine**                         │
│                                                                │
│  • Responds to external stimuli                                │
│                                                                │
│  • Manages internal state           ┌─────────────────────┐   │
│                                     │      request        │   │
│  • Examples: many storage      ┌────┴──┐           ┌──○──┐│   │
│    systems, services           │Clients│  ────→   │ ○  ○ ││   │
│    ▪ Memcached                 └───────┘   result  │State ││   │
│    ▪ RAMCloud                      ←────          │Machine││   │
│    ▪ HDFS name node                               └──────┘│   │
│    ▪ ...                                                  │   │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Left side: bullet points
> Right side: diagram showing Clients sending request to State Machine, getting result back
> State machine shown as connected nodes/circles


# 5

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                  **Replicated State Machine**                  │
│                                                                │
│                         Clients                                │
│                    ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐                   │
│                    └──┘ └──┘ └──┘ └──┘ └──┘                   │
│                              ↓ z←x                             │
│   ┌─────────────────┬─────────────────┬─────────────────┐     │
│   │  Consensus  SM  │  Consensus  SM  │  Consensus  SM  │     │
│   │   Module        │   Module        │   Module        │     │
│   ├─────────────────┼─────────────────┼─────────────────┤     │
│   │      Log        │      Log        │      Log        │     │
│   │ x←1│y←3│x←4│z←x │ x←1│y←3│x←4│z←x │ x←1│y←3│x←4│z←x │     │
│   └─────────────────┴─────────────────┴─────────────────┘     │
│                          Servers                               │
│                                                                │
│  • Replicated log ensures state machines execute same commands │
│  • Consensus module ensures proper log replication             │
│  • System makes progress as long as majority of servers are up │
│  • Failure model: delayed/lost messages, fail-stop             │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Three server boxes with Consensus Module, State Machine, and Log
> Logs shown as table cells with commands: x←1, y←3, x←4, z←x
> Clients at top sending commands to servers


# 6

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                   **Paxos (Single Decree)**                    │
│                                                                │
│   **Proposers**                              **Acceptors**     │
│                                                                │
│   Choose unique proposal #                                     │
│                         ─────propose(proposal #)─────→         │
│                                                                │
│                                        proposal # > any prev?  │
│                         ←──highest proposal # accepted,──      │
│   Majority? Select value       corresponding value             │
│   for highest proposal #                                       │
│   returned; if none,                                           │
│   choose own value      ─────accept(proposal #, value)────→    │
│                                                                │
│                                        proposal # >= any prev? │
│                         ←────────accepted────────              │
│   Majority? Value chosen                                       │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Two-column layout: Proposers on left, Acceptors on right
> Arrows showing message flow between them
> Protocol steps described on each side


# 7

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                     **Paxos Problems**                         │
│                                                                │
│  • **Impenetrable:** hard to develop    ┌────────────────────┐│
│    intuitions                           │"The dirty little   ││
│    ▪ Why does it work?                  │secret of the NSDI  ││
│    ▪ What is the purpose of each phase? │community is that   ││
│                                         │at most five people ││
│  • **Incomplete**                       │really, truly       ││
│    ▪ Only agrees on single value        │understand every    ││
│    ▪ Doesn't address liveness           │part of Paxos :-)"  ││
│    ▪ Choosing proposal values?          │  — NSDI reviewer   ││
│    ▪ Cluster membership management?     └────────────────────┘│
│                                         ┌────────────────────┐│
│  • **Inefficient**                      │"There are signifi- ││
│    ▪ Two rounds of messages             │cant gaps between   ││
│                                         │the description of  ││
│  • **No agreement on the details**      │Paxos and the needs ││
│                                         │of a real-world     ││
│  **Not a good foundation for**          │system..."          ││
│  **practical implementations**          │  — Chubby authors  ││
│                                         └────────────────────┘│
└────────────────────────────────────────────────────────────────┘

> Left: bullet points listing problems
> Right: two quote boxes from NSDI reviewer and Chubby authors
> Bottom conclusion in red


# 8

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                      **Raft Challenge**                        │
│                                                                │
│  • Is there a different consensus algorithm that's easier      │
│    to understand?                                              │
│                                                                │
│  • Make design decisions based on **understandability**:       │
│    ▪ Which approach is easier to explain?                      │
│                                                                │
│  • **Techniques:**                                             │
│    ▪ Problem decomposition                                     │
│    ▪ Minimize state space                                      │
│      • Handle multiple problems with a single mechanism        │
│      • Eliminate special cases                                 │
│      • Maximize coherence                                      │
│      • Minimize nondeterminism                                 │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Standard bullet point slide
> "understandability" highlighted in red


# 9

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                    **Raft Decomposition**                      │
│                                                                │
│  **1. Leader election:**                                       │
│     ▪ Select one server to act as leader                       │
│     ▪ Detect crashes, choose new leader                        │
│                                                                │
│  **2. Log replication (normal operation)**                     │
│     ▪ Leader accepts commands from clients, appends to its log │
│     ▪ Leader replicates its log to other servers               │
│       (overwrites inconsistencies)                             │
│                                                                │
│  **3. Safety**                                                 │
│     ▪ Keep logs consistent                                     │
│     ▪ Only servers with up-to-date logs can become leader      │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Three numbered sections with sub-bullets
> Clear decomposition of Raft into three parts


# 10

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                   **Server States and RPCs**                   │
│                                                                │
│                          start                                 │
│                            ↓                                   │
│                     ┌───────────┐                              │
│   discover    ┌────→│ Follower  │←─── Passive (expects         │
│   higher      │     └─────┬─────┘     regular heartbeats)      │
│   term        │           │                                    │
│               │      no heartbeat                              │
│               │           ↓                                    │
│               │     ┌───────────┐                              │
│               └─────│ Candidate │←─── Issues RequestVote RPCs  │
│                     └─────┬─────┘     to get elected           │
│                           │                                    │
│                     win election                               │
│                           ↓                                    │
│                     ┌───────────┐     Issues AppendEntries:    │
│                     │  Leader   │←─── • Replicate its log      │
│                     └───────────┘     • Heartbeats             │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> State diagram with three states: Follower, Candidate, Leader
> Arrows showing transitions between states
> Annotations on right explaining each state's behavior


# 11

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                          **Terms**                             │
│                                                                │
│   ┌───────┬───────┬─────────────────┬───────┬───────┐         │
│   │Term 1 │Term 2 │     Term 3      │Term 4 │Term 5 │ ──→time │
│   │ E │   │ E │   │ E │             │ E │   │ E │   │         │
│   └───┴───┴───┴───┴───┴─────────────┴───┴───┴───┴───┘         │
│       ↖       ↖       ↖                 ↑                      │
│     Elections    Normal              Split                     │
│                 Operation            Vote                      │
│                                                                │
│  • **At most 1 leader per term**                               │
│  • **Some terms have no leader (failed election)**             │
│  • **Each server maintains current term value (no global view)**│
│    ▪ Exchanged in every RPC                                    │
│    ▪ Peer has later term? Update term, revert to follower      │
│    ▪ Incoming RPC has obsolete term? Reply with error          │
│                                                                │
│  **Terms identify obsolete information**                       │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Timeline diagram showing terms 1-5
> E = Election phase (short), followed by normal operation (longer)
> Term 4 shows split vote (no leader)
> Bottom: key bullet points about terms


# 12

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                     **Leader Election**                        │
│                                                                │
│                    ┌──────────────────┐                        │
│                    │ Become candidate │                        │
│                    └────────┬─────────┘                        │
│                             ↓                                  │
│             ┌───────────────────────────────┐                  │
│   timeout ──│  currentTerm++, vote for self │←─┐               │
│             └───────────────┬───────────────┘  │               │
│                             ↓                  │ timeout       │
│                 ┌─────────────────────┐        │               │
│                 │ Send RequestVote    │────────┘               │
│                 │ RPCs to other       │                        │
│                 │ servers             │                        │
│                 └──────────┬──────────┘                        │
│            votes from      │        RPC from                   │
│            majority        ↓        leader                     │
│        ┌──────────────┐         ┌──────────────┐              │
│        │Become leader,│         │   Become     │              │
│        │send heartbeats│         │  follower    │              │
│        └──────────────┘         └──────────────┘              │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Flowchart showing election process
> Start: Become candidate
> Increment term, vote for self
> Send RequestVote RPCs
> Two outcomes: become leader (majority) or become follower (RPC from leader)
> Timeout loops back


# 13

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                   **Election Correctness**                     │
│                                                                │
│  • **Safety: allow at most one winner per term**               │
│    ▪ Each server gives only one vote per term (persist on disk)│
│    ▪ Majority required to win election                         │
│                                                                │
│         ┌───┐ ┌───┐ ┌ ─ ┐ ┌───┐ ┌───┐                         │
│   B can't│   │ │   │       │   │ │   │  Voted for              │
│   also   └───┘ └───┘ └ ─ ┘ └───┘ └───┘  candidate A            │
│   get              Servers                                     │
│   majority                                                     │
│                                                                │
│  • **Liveness: some candidate must eventually win**            │
│    ▪ Choose election timeouts randomly in [T, 2T] (150-300ms)  │
│    ▪ One server usually times out and wins before others       │
│    ▪ Works well if T >> broadcast time                         │
│                                                                │
│  • **Randomized approach simpler than ranking**                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Diagram showing 5 servers, 3 already voted for A
> Dotted box around the 3 that voted, showing B can't get majority
> Bullet points explaining safety and liveness


# 14

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                    **Normal Operation**                        │
│                                                                │
│  • Client sends command to leader                              │
│                                                                │
│  • Leader appends command to its log                           │
│                                                                │
│  • Leader sends AppendEntries RPCs to all followers            │
│                                                                │
│  • Once new entry **committed**:                               │
│    ▪ Leader executes command in its state machine,             │
│      returns result to client                                  │
│    ▪ Leader notifies followers of committed entries            │
│      in subsequent AppendEntries RPCs                          │
│    ▪ Followers execute committed commands in their             │
│      state machines                                            │
│                                                                │
│  • **Crashed/slow followers?**                                 │
│    ▪ Leader retries AppendEntries RPCs until they succeed      │
│                                                                │
│  • **Optimal performance in common case:**                     │
│    ▪ One successful RPC to any majority of servers             │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Standard bullet point slide describing normal operation flow
> "committed" in red


# 15

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                      **Log Structure**                         │
│                                                                │
│   term─┐  1    2    3    4    5    6    7    8    9   10       │
│        │ ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐            │
│ leader │ │ 1 │ 1 │ 1 │ 2 │ 2 │ 3 │ 3 │ 3 │ 3 │ 3 │ term 3     │
│        │ │x←3│q←8│j←2│x←q│z←5│y←1│y←3│q←j│x←4│z←6│            │
│        │ └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘            │
│ command┘         │ ┌───┬───┬───┬───┬───┬───┬───┐              │
│                  │ │ 1 │ 1 │ 1 │ 2 │ 2 │ 3 │ 3 │              │
│       followers  │ │x←3│q←8│j←2│x←q│z←5│y←1│y←3│              │
│                  │ └───┴───┴───┴───┴───┴───┴───┘              │
│                  │ ┌───┬───┐                                   │
│                  │ │ 1 │ 1 │                                   │
│                  │ │x←3│q←8│                                   │
│                  │ └───┴───┘                                   │
│                  └────────────────┘                            │
│                   committed entries                            │
│                                                                │
│  • Must survive crashes (store on disk)                        │
│  • Entry **committed** if replicated on majority by leader     │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Log visualization: leader at top, followers below
> Each cell shows term number and command
> Color-coded by term (1=blue, 2=yellow, 3=green)
> Committed entries bracket shown


# 16

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                    **Log Inconsistencies**                     │
│                                                                │
│  Crashes can result in log inconsistencies:                    │
│                                                                │
│       1   2   3   4   5   6   7   8   9  10                    │
│  s1  │ 1 │ 1 │ 1 │ 2 │ 2 │ 3 │ 3 │ 3 │   │   │ ← leader term 4│
│  s2  │ 1 │ 1 │ 1 │ 2 │ 2 │ 3 │ 3 │   │   │   │                │
│  s3  │ 1 │ 1 │ 1 │ 2 │ 2 │ 3 │ 3 │ 3 │ 3 │   │                │
│  s4  │ 1 │ 1 │   │   │   │   │   │   │   │   │                │
│  s5  │ 1 │ 1 │ 1 │ 2 │ 2 │ 2 │ 2 │ 2 │ 2 │   │                │
│                                                                │
│  **Raft minimizes special code for repairing inconsistencies:**│
│    ▪ Leader assumes its log is correct                         │
│    ▪ Normal operation will repair all inconsistencies          │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Table showing 5 servers (s1-s5) with different log states
> Each cell shows term number
> Shows missing entries, extra entries, wrong entries
> s1 is the leader for term 4


# 17

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                   **Log Matching Property**                    │
│                                                                │
│  **Goal: high level of consistency between logs**              │
│                                                                │
│  • If log entries on different servers have same index & term: │
│    ▪ They store the same command                               │
│    ▪ The logs are identical in all preceding entries           │
│                                                                │
│      1   2   3   4   5   6   7   8   9  10                     │
│     │ 1 │ 1 │ 1 │ 2 │ 2 │ 3 │ 3 │ 3 │ 3 │ 3 │                 │
│     │x←3│q←8│j←2│x←q│z←5│y←1│y←3│q←j│x←4│z←6│                 │
│                                                                │
│     │ 1 │ 1 │ 1 │ 2 │ 2 │ 3 │ 4 │ 4 │                         │
│     │x←3│q←8│j←2│x←q│z←5│y←1│x←z│y←7│                         │
│                       ↑                                        │
│                    same here                                   │
│                                                                │
│  • If a given entry is committed, all preceding entries        │
│    are also committed                                          │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Two log examples showing matching property
> Arrow pointing to index 6 where logs match (same term & index)
> All entries before that point are identical


# 18

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│               **AppendEntries Consistency Check**              │
│                                                                │
│  • AppendEntries RPCs include <index, term> of preceding entry │
│  • Follower must contain matching entry; otherwise rejects     │
│    ▪ Leader retries with lower log index                       │
│  • Implements an **induction step**, ensures Log Matching      │
│                                                                │
│   Example #1: success    Example #2: mismatch   Example #3     │
│                                                                │
│   leader:   │2│3│        leader:   │2│3│        leader:   │2│3│
│             │ │↓│                  │ │↓│                  │ │↓│
│   before:   │2│ │        before:   │1│1│1│      before:   │1│1│
│   after:    │2│3│        after:    │1│1│1│      after:    │2│3│
│              ✓                      ✗ retry               ✓   │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Three examples showing consistency check
> Example 1: terms match, entry appended (success)
> Example 2: terms don't match, rejected (mismatch)
> Example 3: after retry at lower index, success


# 19

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                **Safety: Leader Completeness**                 │
│                                                                │
│  • Once log entry committed, all      Leader election term 4:  │
│    future leaders must store that                              │
│    entry                                      1 2 3 4 5 6 7 8 9│
│                                          s1 │1│1│1│2│2│3│3│3│ │
│  • Servers with incomplete logs          s2 │1│1│1│2│2│3│3│   │
│    must not get elected:                 s3 │1│1│1│2│2│3│3│3│3│
│                                          s4 │1│1│1│2│2│3│3│3│ │
│    ▪ Candidates include index            s5 │1│1│1│2│2│2│2│2│2│
│      and term of last log entry                                │
│      in RequestVote RPCs                                       │
│                                                                │
│    ▪ Voting server denies vote                                 │
│      if its log is more up-to-date                             │
│                                                                │
│    ▪ Logs ranked by <lastTerm, lastIndex>                      │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Left: explanation of leader completeness
> Right: table showing 5 servers with their logs
> s3 has longest log with term 3, s5 has many term 2 entries


# 20

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                     **Raft Evaluation**                        │
│                                                                │
│  • **Formal proof of safety**                                  │
│    ▪ Ongaro dissertation                                       │
│    ▪ UW mechanically checked proof (50 klines)                 │
│                                                                │
│  • **C++ implementation (2000 lines)**                         │
│    ▪ 100's of clusters deployed by Scale Computing             │
│                                                                │
│  • **Performance analysis of leader election**                 │
│    ▪ Converges quickly even with 12-24 ms timeouts             │
│                                                                │
│  • **User study of understandability**                         │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Standard bullet point slide
> Four evaluation criteria listed


# 21

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│            **User Study: Is Raft Simpler than Paxos?**         │
│                                                                │
│  • **43 students in 2 graduate OS classes** (Berkeley/Stanford)│
│    ▪ Group 1: Raft video, quiz → Paxos video, quiz             │
│    ▪ Group 2: Paxos video, quiz → Raft video, quiz             │
│                                                                │
│  • **Instructional videos:**                                   │
│    ▪ Same instructor (Ousterhout)                              │
│    ▪ Covered same functionality                                │
│    ▪ Fleshed out missing pieces for Paxos                      │
│    ▪ Videos available on YouTube                               │
│                                                                │
│  • **Quizzes:**                                                │
│    ▪ Questions in 3 general categories                         │
│    ▪ Same weightings for both tests                            │
│                                                                │
│  • **Experiment favored Paxos slightly:**                      │
│    ▪ 15 students had prior experience with Paxos               │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Details of user study methodology


# 22

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                    **User Study Results**                      │
│                                                                │
│   Raft grade                        number of participants     │
│       60│                                 20│ ■                │
│         │      .  .                         │ ■  ■             │
│       50│    . .                          15│    ■             │
│         │   ..  . .                         │                  │
│       40│  . . ..                         10│                  │
│         │ . . ..   .                        │ □                │
│       30│.. . . .                          5│ □  ▨  □          │
│         │. ..                               │ ▨     ▨  ■       │
│       20│. .   . .                         0└────────────────  │
│         │.   . .                            implement  explain │
│       10│.  .                                                  │
│         │.                                ▨ Paxos much easier  │
│        0└──────────────                   □ Roughly equal      │
│         0  10 20 30 40 50 60              ■ Raft much easier   │
│              Paxos grade                                       │
│                                                                │
│     . = Raft then Paxos    Most points above diagonal line     │
│     x = Paxos then Raft    → Raft scores higher                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Left: scatter plot comparing Raft vs Paxos quiz grades
> Most dots above the diagonal = Raft scores higher
> Right: bar chart showing subjective assessment
> Overwhelming preference for Raft in both "implement" and "explain"


# 23

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                          **Impact**                            │
│                                                                │
│   **Hard to publish:**              **Widely adopted:**        │
│                                                                │
│   • Rejected 3 times at major       • 25 implementations       │
│     conferences                       before paper published   │
│                                                                │
│   • Finally published in            • 83 implementations       │
│     USENIX ATC 2014                   currently listed on      │
│                                       Raft home page           │
│   • Challenges:                                                │
│     ▪ PCs uncomfortable with        • >10 versions in          │
│       understandability as metric     production               │
│     ▪ Hard to evaluate                                         │
│     ▪ Complexity impresses PCs      • Taught in graduate       │
│                                       OS classes               │
│                                       ▪ MIT, Stanford,         │
│                                         Washington, Harvard,   │
│                                         Duke, Brown, ...       │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Two-column layout contrasting publication difficulty with adoption success


# 24

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                       **Conclusions**                          │
│                                                                │
│  • **Understandability deserves more emphasis in**             │
│    **algorithm design**                                        │
│    ▪ Decompose the problem                                     │
│    ▪ Minimize state space                                      │
│                                                                │
│  • **Making a system simpler can have high impact**            │
│                                                                │
│  • **Raft better than Paxos for teaching and implementation:** │
│    ▪ Easier to understand                                      │
│    ▪ More complete                                             │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Three main conclusion points
> Emphasizes understandability as key design principle


# 25

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                       **Why "Raft"?**                          │
│                                                                │
│                                                                │
│               ┌─────────────────────┐                          │
│               │ **R**eplicated      │                          │
│               │ **A**nd             │         ∧∧               │
│               │ **F**ault           │        ∧  ∧ Paxos        │
│               │ **T**olerant        │       ∧    ∧             │
│               └─────────────────────┘      ~~~~~~~~            │
│                        │                 ~~~~~~~~              │
│                   ┌────┴────┐           ~~~~~~~~               │
│                   │ 🪵🪵🪵  │          ~~~~~~~~                │
│                   │  Raft   │         ~~~~~~~~                 │
│                   └─────────┘        ~~~~~~~~                  │
│                     ~~~~~~~~        ~~~~~~~~                   │
│                    ~~~~~~~~        ~~~~~~~~                    │
│                                                                │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Fun closing slide with visual pun
> Raft (wooden logs) floating in water toward Paxos island
> RAFT = Replicated And Fault Tolerant acronym
