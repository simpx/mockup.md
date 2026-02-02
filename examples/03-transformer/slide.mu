---
title: Transformers
author: Introduction to Transformers
theme: academic
---


# 1

┌────────────────────────────────────────────────────────────────────┐
│                                                                    │
│  ┌──────────────────┬─────────────────────────────────────────┐   │
│  │                  │                                         │   │
│  │                  │   **Introduction to Transformers**      │   │
│  │                  │                                         │   │
│  │   Transformers   │                                         │   │
│  │                  │                                         │   │
│  │                  │                                         │   │
│  │                  │                                         │   │
│  └──────────────────┴─────────────────────────────────────────┘   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘

> Left panel background: #C65D34


# 2

┌────────────────────────────────────────────────────────────────────┐
│  **LLMs are built out of transformers**                            │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Transformer: a specific kind of network architecture, like a      │
│  fancier feedforward network, but based on attention               │
│                                                                    │
│  ╔════════════════════════════════════════════════════════════╗   │
│  ║              **Attention Is All You Need**                 ║   │
│  ╠════════════════════════════════════════════════════════════╣   │
│  ║                                                            ║   │
│  ║  Ashish Vaswani*    Noam Shazeer*    Niki Parmar*         ║   │
│  ║  Google Brain       Google Brain     Google Research       ║   │
│  ║                                                            ║   │
│  ║  Jakob Uszkoreit*   Llion Jones*     Aidan N. Gomez*      ║   │
│  ║  Google Research    Google Research  U of Toronto          ║   │
│  ║                                                            ║   │
│  ║  Lukasz Kaiser*     Illia Polosukhin*                      ║   │
│  ║  Google Brain                                              ║   │
│  ╚════════════════════════════════════════════════════════════╝   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 3

┌────────────────────────────────────────────────────────────────────┐
│  **A very approximate timeline**                                   │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  1990  Static Word Embeddings                                      │
│                                                                    │
│  2003  Neural Language Model                                       │
│                                                                    │
│  2008  Multi-Task Learning                                         │
│                                                                    │
│  2015  Attention                                                   │
│                                                                    │
│  2017  Transformer                                                 │
│                                                                    │
│  2018  Contextual Word Embeddings and Pretraining                  │
│                                                                    │
│  2019  Prompting                                                   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 4

┌────────────────────────────────────────────────────────────────────┐
│                                                                    │
│  ┌──────────────────┬─────────────────────────────────────────┐   │
│  │                  │                                         │   │
│  │                  │   **Attention**                         │   │
│  │                  │                                         │   │
│  │   Transformers   │                                         │   │
│  │                  │                                         │   │
│  │                  │                                         │   │
│  │                  │                                         │   │
│  └──────────────────┴─────────────────────────────────────────┘   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘

> Left panel background: #C65D34


# 5

┌────────────────────────────────────────────────────────────────────┐
│  **Instead of starting with the big picture**                      │
├────────────────────────────────────────────────────────────────────┤
│  Let's consider the embeddings for an individual word              │
│  from a particular layer                                           │
│                                                                    │
│  Next token      long      and     thanks     for       all        │
│                   ↑         ↑        ↑         ↑         ↑         │
│  Language       ┌───┐    ┌───┐    ┌───┐    ┌───┐    ┌───┐         │
│  Modeling       │ U │    │ U │    │ U │    │ U │    │ U │    ...  │
│  Head           └─┬─┘    └─┬─┘    └─┬─┘    └─┬─┘    └─┬─┘         │
│                   │        │        │        │        │            │
│  Stacked        ┌─┴─┐    ┌─┴─┐    ┌─┴─┐    ┌─┴─┐    ┌─┴─┐         │
│  Transformer    │...│←───│...│←───│...│←───│...│←───│...│    ...  │
│  Blocks         └─┬─┘    └─┬─┘    └─┬─┘    └─┬─┘    └─┬─┘         │
│                   │        │        │        │        │            │
│                 ┌─┴─┐    ┌─┴─┐    ┌─┴─┐    ┌─┴─┐    ┌─┴─┐         │
│  Input          │x1 │    │x2 │    │x3 │    │x4 │    │x5 │    ...  │
│  Encoding       │E+1│    │E+2│    │E+3│    │E+4│    │E+5│         │
│                 └─┬─┘    └─┬─┘    └─┬─┘    └─┬─┘    └─┬─┘         │
│                   │        │        │        │        │            │
│  Input tokens    So      long      and    thanks     for           │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 6

┌────────────────────────────────────────────────────────────────────┐
│  **Problem with static embeddings (word2vec)**                     │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  They are static! The embedding for a word doesn't reflect         │
│  how its meaning changes in context.                               │
│                                                                    │
│                                                                    │
│    The chicken didn't cross the road because (it) was too tired    │
│                                               ~~~                  │
│                                                                    │
│  What is the meaning represented in the static embedding           │
│  for "it"?                                                         │
│                                                                    │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘

> "it" is circled to highlight ambiguity


# 7

┌────────────────────────────────────────────────────────────────────┐
│  **Contextual Embeddings**                                         │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • Intuition: a representation of meaning of a word                │
│    should be different in different contexts!                      │
│                                                                    │
│  • **Contextual Embedding**: each word has a different             │
│    vector that expresses different meanings                        │
│    depending on the surrounding words                              │
│                                                                    │
│  • How to compute contextual embeddings?                           │
│      • **Attention**                                               │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 8

┌────────────────────────────────────────────────────────────────────┐
│  **Contextual Embeddings**                                         │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│    The chicken didn't cross the road because it                    │
│                                                                    │
│  What should be the properties of "it"?                            │
│                                                                    │
│    The chicken didn't cross the road because it was too **tired**  │
│    The chicken didn't cross the road because it was too **wide**   │
│                                                                    │
│                                                                    │
│  At this point in the sentence, it's probably referring to         │
│  either the chicken or the street                                  │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 9

┌────────────────────────────────────────────────────────────────────┐
│  **Intuition of attention**                                        │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Build up the contextual embedding from a word by                  │
│  selectively integrating information from all the                  │
│  neighboring words                                                 │
│                                                                    │
│  We say that a word "attends to" some neighboring                  │
│  words more than others                                            │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 10

┌────────────────────────────────────────────────────────────────────┐
│  **Intuition of attention**                                        │
├────────────────────────────────────────────────────────────────────┤
│                       columns corresponding to input tokens        │
│                                                                    │
│              T  c  d  c  t  r  b  i  w  t  t                       │
│              h  h  i  r  h  o  e  t  a  o  i                       │
│  Layer k+1   e  i  d  o  e  a  c     s  o  r                       │
│                 c  n  s     d  a              e                    │
│                 k  '  s        u              d                    │
│                 e  t           s                                   │
│                 n              e                                   │
│                    ↑           ↑                                   │
│        self-attention distribution                                 │
│                 ╱              │                                   │
│                ╱               │                                   │
│  Layer k     The chicken ... road ... it ...                       │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘

> Show attention weights from "it" attending to "chicken" and "road"


# 11

┌────────────────────────────────────────────────────────────────────┐
│  **Attention definition**                                          │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  A mechanism for helping compute the embedding for                 │
│  a token by selectively attending to and integrating               │
│  information from surrounding tokens (at the previous              │
│  layer).                                                           │
│                                                                    │
│  More formally: a method for doing a weighted sum of               │
│  vectors.                                                          │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 12

┌────────────────────────────────────────────────────────────────────┐
│  **Attention is left-to-right**                                    │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│                 ╭───╮   ╭───╮   ╭───╮   ╭───╮   ╭───╮             │
│                 │a1 │   │a2 │   │a3 │   │a4 │   │a5 │             │
│                 ╰─┬─╯   ╰─┬─╯   ╰─┬─╯   ╰─┬─╯   ╰─┬─╯             │
│                   │       │       │       │       │                │
│  Self-Attention ┌─┴─┐   ┌─┴─┐   ┌─┴─┐   ┌─┴─┐   ┌─┴─┐             │
│  Layer          │att│   │att│   │att│   │att│   │att│             │
│                 └─┬─┘   └┬┬─┘   └┬┬┬┘   └┬┬┬┬   └┬┬┬┬┬            │
│                   │      ││      │││     ││││    │││││             │
│                   │     ╱ │     ╱╱ │    ╱╱╱│    ╱╱╱╱│              │
│                   │    ╱  │    ╱╱  │   ╱╱╱ │   ╱╱╱╱ │              │
│                 ╭─┴─╮ ╭─┴─╮ ╭─┴─╮ ╭─┴─╮ ╭─┴─╮                     │
│                 │x1 │ │x2 │ │x3 │ │x4 │ │x5 │                     │
│                 ╰───╯ ╰───╯ ╰───╯ ╰───╯ ╰───╯                     │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 13

┌────────────────────────────────────────────────────────────────────┐
│  **Simplified version of attention**                               │
│  A sum of prior words weighted by their similarity                 │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Given a sequence of token embeddings:                             │
│                                                                    │
│      x1   x2   x3   x4   x5   x6   x7   xi                         │
│                                                                    │
│  Produce: ai = a weighted sum of x1 through x7 (and xi)            │
│  Weighted by their similarity to xi                                │
│                                                                    │
│                                                                    │
│              score(xi, xj) = xi · xj                               │
│                                                                    │
│              αij = softmax(score(xi, xj))  ∀j ≤ i                  │
│                                                                    │
│              ai = Σ αij·xj                                         │
│                  j≤i                                                │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 14

┌────────────────────────────────────────────────────────────────────┐
│  **An Actual Attention Head: slightly more complicated**           │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  High-level idea: instead of using vectors (like xi and x4)        │
│  directly, we'll represent 3 separate roles each vector xi plays:  │
│                                                                    │
│  • **query**: As the *current element* being compared to the       │
│    preceding inputs.                                               │
│                                                                    │
│  • **key**: as *a preceding input* that is being compared to       │
│    the current element to determine a similarity                   │
│                                                                    │
│  • **value**: a value of a preceding element that gets             │
│    weighted and summed                                             │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 15

┌────────────────────────────────────────────────────────────────────┐
│  **Attention intuition**                                           │
├────────────────────────────────────────────────────────────────────┤
│                       columns corresponding to input tokens        │
│                                                            *query* │
│              T  c  d  c  t  r  b  i  w  t  t                       │
│              h  h  i  r  h  o  e  t  a  o  i                       │
│  Layer k+1   e  i  d  o  e  a  c     s  o  r                       │
│                 c  n  s     d  a              e                    │
│                 k  '  s        u              d                    │
│                 e  t           s                                   │
│                 n              e         ↑                         │
│        self-attention distribution       │                         │
│                 ↑              ↑          │                        │
│  Layer k       The chicken ... road ... it ...                     │
│                                                                    │
│      x1   x2   x3   x4   x5   x6   x7   xi                         │
│                     *values*                                       │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 16

┌────────────────────────────────────────────────────────────────────┐
│  **Intuition of attention with keys**                              │
├────────────────────────────────────────────────────────────────────┤
│                       columns corresponding to input tokens        │
│                                                            *query* │
│  Layer k+1    The chicken didn't cross the road because it ...     │
│                                                         ↑          │
│        self-attention distribution                      │          │
│                 ↑              ↑                         │          │
│  Layer k      The chicken ... road ... because  it ...             │
│                                                                    │
│      x1   x2   x3   x4   x5   x6   x7   xi                         │
│     ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐                       │
│     │k │ │k │ │k │ │k │ │k │ │k │ │k │ │k │   *keys*               │
│     │v │ │v │ │v │ │v │ │v │ │v │ │v │ │v │   *values*             │
│     └──┘ └──┘ └──┘ └──┘ └──┘ └──┘ └──┘ └──┘                       │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 17

┌────────────────────────────────────────────────────────────────────┐
│  **An Actual Attention Head: slightly more complicated**           │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  We'll use matrices to project each vector xi into a               │
│  representation of its role as query, key, value:                  │
│                                                                    │
│  • **query**: W^Q                                                  │
│  • **key**: W^K                                                    │
│  • **value**: W^V                                                  │
│                                                                    │
│                                                                    │
│         qi = xi·W^Q;    ki = xi·W^K;    vi = xi·W^V                │
│                                                                    │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 18

┌────────────────────────────────────────────────────────────────────┐
│  **An Actual Attention Head: slightly more complicated**           │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Given these 3 representation of xi                                │
│                                                                    │
│         qi = xi·W^Q;    ki = xi·W^K;    vi = xi·W^V                │
│                                                                    │
│  To compute similarity of current element xi with                  │
│  some prior element xj                                             │
│                                                                    │
│  We'll use dot product between qi and kj.                          │
│                                                                    │
│  And instead of summing up xj, we'll sum up vj                     │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 19

┌────────────────────────────────────────────────────────────────────┐
│  **Final equations for one attention head**                        │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│                                                                    │
│         qi = xi·W^Q;    kj = xj·W^K;    vj = xj·W^V                │
│                                                                    │
│                              qi · kj                               │
│         score(xi, xj)  =    ────────                               │
│                               √dk                                  │
│                                                                    │
│         αij  =  softmax(score(xi, xj))  ∀j ≤ i                     │
│                                                                    │
│         ai  =  Σ αij·vj                                            │
│               j≤i                                                  │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 20

┌────────────────────────────────────────────────────────────────────┐
│  **Calculating the value of a3**                                   │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│                                            Output: a3              │
│                                               ↑                    │
│  6. Sum the weighted                        [Σ]                    │
│     value vectors                          ↗  ↑  ↖                 │
│                                           ╱   │   ╲                │
│  5. Weigh each value vector        α3,1  α3,2  α3,3                │
│                                      ↑     ↑     ↑                 │
│  4. Turn into αi,j weights          [softmax row]                  │
│     via softmax                      ↑     ↑     ↑                 │
│                                     ÷√dk  ÷√dk  ÷√dk               │
│  3. Divide score by √dk              ↑     ↑     ↑                 │
│                                     [·]   [·]   [·]                │
│  2. Compare x3's query with         ╱↖    ╱│    ╱│                 │
│     the keys for x1, x2, x3        k  q  k  q  k  q                │
│                                    ↑  ↑  ↑  ↑  ↑  ↑                │
│  1. Generate key, query,          W^k W^q W^k W^q W^k W^q          │
│     value vectors                  ↑  ↑  ↑  ↑  ↑  ↑                │
│                                   x1     x2     x3                 │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 21

┌────────────────────────────────────────────────────────────────────┐
│  **Actual Attention: slightly more complicated**                   │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • Instead of one attention head, we'll have lots of them!         │
│  • Intuition: each head might be attending to the context          │
│    for different purposes                                          │
│      • Different linguistic relationships or patterns              │
│                                                                    │
│     qi^c = xi·W^Qc;   kj^c = xj·W^Kc;   vj^c = xj·W^Vc;  ∀c 1≤c≤h │
│                                                                    │
│                             qi^c · kj^c                            │
│     score^c(xi, xj)  =     ───────────                             │
│                                √dk                                 │
│                                                                    │
│     αij^c  =  softmax(score^c(xi, xj))  ∀j ≤ i                     │
│                                                                    │
│     head_i^c  =  Σ αij^c · vj^c                                    │
│                 j≤i                                                │
│                                                                    │
│     ai  =  (head^1 ⊕ head^2 ... ⊕ head^h) W^O                      │
│                                                                    │
│     MultiHeadAttention(xi, [x1,...,xN])  =  ai                     │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 22

┌────────────────────────────────────────────────────────────────────┐
│  **Multi-head attention**                                          │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│                              ai  [1 x d]                           │
│                               ↑                                    │
│  Project down to d          [W^O]  [hdv x d]                       │
│                               ↑                                    │
│  Concatenate Outputs     [...................] [1 x hdv]           │
│                            ↑       ↑       ↑                       │
│                         [1xdv]  [1xdv]  [1xdv]                     │
│  Each head              ┌─────┐ ┌─────┐     ┌─────┐               │
│  attends differently    │Head1│ │Head2│ ... │Head8│               │
│  to context             │W^K  │ │W^K  │     │W^K  │               │
│                         │W^V  │ │W^V  │     │W^V  │               │
│                         │W^Q  │ │W^Q  │     │W^Q  │               │
│                         └──┬──┘ └──┬──┘     └──┬──┘               │
│                           ╱╲      ╱╲          ╱╲                   │
│                          ╱  ╲    ╱  ╲        ╱  ╲                  │
│    ... xi-3  xi-2  xi-1        xi [1 x d]                          │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘


# 23

┌────────────────────────────────────────────────────────────────────┐
│  **Summary**                                                       │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Attention is a method for enriching the representation of         │
│  a token by incorporating contextual information                   │
│                                                                    │
│  The result: the embedding for each word will be different         │
│  in different contexts!                                            │
│                                                                    │
│  Contextual embeddings: a representation of word meaning           │
│  in its context.                                                   │
│                                                                    │
│  We'll see in the next lecture that attention can also be          │
│  viewed as a way to move information from one token to another.    │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
