# Attention Is All You Need

Google 2017 年发表的 Transformer 论文，这是现代 AI 革命的奠基之作。GPT、BERT、LLaMA 等所有大语言模型都基于这个架构。适合 AI/ML 技术分享、论文讲解和学术研讨。

---

## Slide 1: Title

**Attention Is All You Need**

Vaswani et al.

Google Brain & Google Research

NeurIPS 2017

*The paper that changed everything in AI*

---

## Slide 2: The Problem

**The Problem with Sequence Models**

Previous state-of-the-art: RNNs and LSTMs

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   RNN/LSTM Processing:                                      │
│                                                             │
│   Input:  "The cat sat on the mat"                          │
│                                                             │
│   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐            │
│   │The│──▶│cat│──▶│sat│──▶│on │──▶│the│──▶│mat│            │
│   └───┘   └───┘   └───┘   └───┘   └───┘   └───┘            │
│     ↓       ↓       ↓       ↓       ↓       ↓              │
│   t=1     t=2     t=3     t=4     t=5     t=6              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Problems:
- **Sequential**: Can't parallelize - slow training
- **Long-range dependencies**: Information gets diluted
- **Vanishing gradients**: Hard to learn long sequences

---

## Slide 3: The Solution

**The Transformer: Parallelizable Attention**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Transformer Processing:                                   │
│                                                             │
│   Input:  "The cat sat on the mat"                          │
│                                                             │
│   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐            │
│   │The│   │cat│   │sat│   │on │   │the│   │mat│            │
│   └─┬─┘   └─┬─┘   └─┬─┘   └─┬─┘   └─┬─┘   └─┬─┘            │
│     │       │       │       │       │       │              │
│     ▼       ▼       ▼       ▼       ▼       ▼              │
│   ╔═══════════════════════════════════════════════╗        │
│   ║           SELF-ATTENTION LAYER               ║        │
│   ║    (All tokens attend to all tokens)          ║        │
│   ╚═══════════════════════════════════════════════╝        │
│     │       │       │       │       │       │              │
│     ▼       ▼       ▼       ▼       ▼       ▼              │
│   Output (all computed in parallel!)                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Key insight: **Replace recurrence with attention**

---

## Slide 4: Architecture Overview

**The Transformer Architecture**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│         ENCODER                    DECODER                  │
│   ┌─────────────────┐        ┌─────────────────┐           │
│   │                 │        │                 │           │
│   │  ┌───────────┐  │        │  ┌───────────┐  │           │
│   │  │  Feed     │  │        │  │  Feed     │  │           │
│   │  │  Forward  │  │        │  │  Forward  │  │           │
│   │  └─────┬─────┘  │        │  └─────┬─────┘  │           │
│   │        │        │        │        │        │           │
│   │  ┌─────┴─────┐  │        │  ┌─────┴─────┐  │           │
│   │  │   Multi   │  │   ──────▶ │  Cross    │  │           │
│   │  │   Head    │  │        │  │  Attention│  │           │
│   │  │  Attention│  │        │  └─────┬─────┘  │           │
│   │  └─────┬─────┘  │        │        │        │           │
│   │        │        │        │  ┌─────┴─────┐  │           │
│   │        ▲        │        │  │  Masked   │  │           │
│   │        │        │        │  │  Self     │  │           │
│   └────────┼────────┘        │  │  Attention│  │           │
│            │                 │  └─────┬─────┘  │           │
│     Input Embedding          │        │        │           │
│     + Positional Enc         │        ▲        │           │
│                              └────────┼────────┘           │
│                                       │                    │
│                                Output Embedding            │
│                                + Positional Enc            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 5: Self-Attention

**Self-Attention Mechanism**

The core innovation:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   For each word, compute attention to ALL other words:      │
│                                                             │
│   "The animal didn't cross the street because it was tired" │
│                                                  │          │
│                                                  ▼          │
│                                          What does "it"     │
│                                          refer to?          │
│                                                             │
│   Attention weights from "it":                              │
│   ┌────────────────────────────────────────────────────┐   │
│   │ The    animal  didn't  cross  street  because  it  │   │
│   │ ▁▁▁    ████    ▁▁▁     ▁▁     ▁▁▁     ▁▁       █   │   │
│   │ 0.05   0.60    0.02    0.03   0.05    0.05    0.20 │   │
│   └────────────────────────────────────────────────────┘   │
│                  ▲                                          │
│                  │                                          │
│            "it" attends most to "animal"                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 6: Query, Key, Value

**Q, K, V: The Attention Formula**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Each input token X is projected into three vectors:       │
│                                                             │
│   ┌───┐                                                     │
│   │ X │ ──┬──▶ Query (Q) = What am I looking for?           │
│   └───┘   │                                                 │
│           ├──▶ Key (K)   = What do I contain?               │
│           │                                                 │
│           └──▶ Value (V) = What do I actually say?          │
│                                                             │
│   ─────────────────────────────────────────────────────     │
│                                                             │
│   The Attention Formula:                                    │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │            Attention(Q, K, V) =                     │   │
│   │                                                     │   │
│   │                    Q · K^T                          │   │
│   │            softmax(───────) · V                     │   │
│   │                     √d_k                            │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
│   √d_k: scaling factor to prevent softmax saturation        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 7: Multi-Head Attention

**Multi-Head Attention**

Why one attention when you can have many?

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Input X                                                   │
│     │                                                       │
│     ├────────┬────────┬────────┬────────┐                  │
│     ▼        ▼        ▼        ▼        ▼                  │
│   ┌────┐   ┌────┐   ┌────┐   ┌────┐   ┌────┐               │
│   │Head│   │Head│   │Head│   │Head│   │... │               │
│   │ 1  │   │ 2  │   │ 3  │   │ 4  │   │ h  │               │
│   └──┬─┘   └──┬─┘   └──┬─┘   └──┬─┘   └──┬─┘               │
│      │        │        │        │        │                 │
│      └────────┴────────┼────────┴────────┘                 │
│                        │                                    │
│                        ▼                                    │
│                   ┌─────────┐                               │
│                   │ Concat  │                               │
│                   └────┬────┘                               │
│                        │                                    │
│                        ▼                                    │
│                   ┌─────────┐                               │
│                   │Linear W │                               │
│                   └────┬────┘                               │
│                        │                                    │
│                        ▼                                    │
│                     Output                                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Each head can learn different relationships:
- Head 1: Syntax (subject-verb)
- Head 2: Coreference (pronouns)
- Head 3: Semantic similarity
- etc.

---

## Slide 8: Positional Encoding

**Positional Encoding**

Attention has no notion of position - need to add it:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Problem: "John loves Mary" ≠ "Mary loves John"            │
│            But attention treats them the same!              │
│                                                             │
│   Solution: Add position information to embeddings          │
│                                                             │
│   PE(pos, 2i)   = sin(pos / 10000^(2i/d))                   │
│   PE(pos, 2i+1) = cos(pos / 10000^(2i/d))                   │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │   pos=0: ▂▅▇▅▂▁▂▅▇▅▂▁▂▅▇▅▂▁                         │   │
│   │   pos=1: ▅▇▅▂▁▂▅▇▅▂▁▂▅▇▅▂▁▂                         │   │
│   │   pos=2: ▇▅▂▁▂▅▇▅▂▁▂▅▇▅▂▁▂▅                         │   │
│   │   ...                                               │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
│   Each position has a unique "fingerprint"                  │
│   Nearby positions have similar encodings                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 9: Feed-Forward Network

**Feed-Forward Network**

After attention, each position goes through FFN:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   ┌────────────────────────────────────────────────────┐   │
│   │                                                    │   │
│   │   FFN(x) = max(0, xW₁ + b₁)W₂ + b₂                │   │
│   │                    └──────┘                        │   │
│   │                      ReLU                          │   │
│   │                                                    │   │
│   └────────────────────────────────────────────────────┘   │
│                                                             │
│   Architecture:                                             │
│                                                             │
│   Input ──▶ Linear (d → 4d) ──▶ ReLU ──▶ Linear (4d → d)   │
│                                                             │
│   d_model = 512                                             │
│   d_ff = 2048 (4x expansion)                                │
│                                                             │
│   ─────────────────────────────────────────────────────     │
│                                                             │
│   Key: Same FFN applied to EACH position independently      │
│        This is where the "knowledge" is stored              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 10: Layer Normalization & Residual

**Residual Connections + Layer Norm**

Training deep networks is hard. These help:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Standard Block:                                           │
│                                                             │
│   ┌────────────┐                                            │
│   │   Input    │                                            │
│   └─────┬──────┘                                            │
│         │                                                   │
│         ├──────────────────────────────┐ (Residual)         │
│         │                              │                    │
│         ▼                              │                    │
│   ┌────────────┐                       │                    │
│   │  Sublayer  │ (Attention or FFN)    │                    │
│   └─────┬──────┘                       │                    │
│         │                              │                    │
│         ▼                              │                    │
│   ┌────────────┐                       │                    │
│   │   Dropout  │                       │                    │
│   └─────┬──────┘                       │                    │
│         │                              │                    │
│         ├◀─────────────────────────────┘                    │
│         │  ADD                                              │
│         ▼                                                   │
│   ┌────────────┐                                            │
│   │ LayerNorm  │                                            │
│   └─────┬──────┘                                            │
│         │                                                   │
│         ▼                                                   │
│      Output                                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 11: Encoder-Decoder

**Encoder-Decoder for Translation**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Input: "I love you"           Output: "Je t'aime"         │
│                                                             │
│   ┌──────────────────┐          ┌──────────────────┐       │
│   │     ENCODER      │          │     DECODER      │       │
│   │                  │          │                  │       │
│   │ "I" "love" "you" │──────────│   "Je" "t'"     │       │
│   │       │          │          │      ▲          │       │
│   │       ▼          │   K, V   │      │          │       │
│   │ Self-Attention   │─────────▶│ Cross-Attention │       │
│   │       │          │          │      │          │       │
│   │       ▼          │          │      ▼          │       │
│   │ Context vectors  │          │ Next token: "aime"│       │
│   │                  │          │                  │       │
│   └──────────────────┘          └──────────────────┘       │
│                                                             │
│   Encoder: Bidirectional (sees all input)                   │
│   Decoder: Autoregressive (generates one token at a time)   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 12: Training

**Training Details**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Model Configurations:                                     │
│                                                             │
│   │ Parameter          │ Base    │ Big      │              │
│   │────────────────────│─────────│──────────│              │
│   │ d_model            │ 512     │ 1024     │              │
│   │ d_ff               │ 2048    │ 4096     │              │
│   │ Heads              │ 8       │ 16       │              │
│   │ Layers             │ 6       │ 6        │              │
│   │ Parameters         │ 65M     │ 213M     │              │
│                                                             │
│   Training:                                                 │
│   • Dataset: WMT 2014 English-German, English-French        │
│   • Hardware: 8 P100 GPUs                                   │
│   • Time: 12 hours (base), 3.5 days (big)                   │
│                                                             │
│   Optimizer: Adam with warmup                               │
│   ┌─────────────────────────────────────────────────────┐   │
│   │ lr = d_model^(-0.5) · min(step^(-0.5),              │   │
│   │                           step · warmup^(-1.5))     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 13: Results

**Results: State of the Art**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   English-German Translation (BLEU Score):                  │
│                                                             │
│   Model                      BLEU    Training Cost         │
│   ────────────────────────────────────────────────          │
│   Previous SOTA (Ensemble)   26.03   $$$$$$$$$             │
│   Transformer (Base)         27.3    $$                    │
│   Transformer (Big)          28.4    $$$                   │
│                               ▲                             │
│                               │                             │
│                        New SOTA! +2.0 BLEU                  │
│                                                             │
│   ─────────────────────────────────────────────────────     │
│                                                             │
│   Training Efficiency:                                      │
│                                                             │
│   │████████████████████████████│ Transformer               │
│   │████████████████████████████████████████████│ RNN       │
│   └──────────────────────────────────────────────▶         │
│                              Training Time                  │
│                                                             │
│   Transformer trains 10-100x faster than RNNs!              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 14: Impact

**Impact: The Foundation of Modern AI**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   2017                                                      │
│   └── Transformer (this paper)                              │
│        │                                                    │
│        ├── 2018: BERT (Google)                              │
│        │         └── Encoder-only, bidirectional            │
│        │                                                    │
│        ├── 2018-2023: GPT-1/2/3/4 (OpenAI)                  │
│        │         └── Decoder-only, autoregressive           │
│        │                                                    │
│        ├── 2020: T5 (Google)                                │
│        │         └── Encoder-decoder, text-to-text          │
│        │                                                    │
│        ├── 2021: CLIP, DALL-E (OpenAI)                      │
│        │         └── Vision + Language                      │
│        │                                                    │
│        ├── 2023: LLaMA, Mistral, etc.                       │
│        │         └── Open-source LLMs                       │
│        │                                                    │
│        └── 2024+: Claude, Gemini, GPT-4, etc.               │
│                  └── State-of-the-art AI systems            │
│                                                             │
│   Citations: 120,000+ (one of most cited ML papers ever)    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Slide 15: Summary

**Key Takeaways**

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   1. ATTENTION IS ALL YOU NEED                              │
│      Replace recurrence with self-attention                 │
│      All tokens can attend to all tokens directly           │
│                                                             │
│   2. PARALLELIZATION                                        │
│      No sequential dependencies                             │
│      10-100x faster training                                │
│                                                             │
│   3. MULTI-HEAD ATTENTION                                   │
│      Multiple attention heads learn different patterns      │
│      Rich, diverse representations                          │
│                                                             │
│   4. POSITIONAL ENCODING                                    │
│      Sinusoidal encoding captures position                  │
│      Generalizes to longer sequences                        │
│                                                             │
│   5. STACKING LAYERS                                        │
│      6 encoder + 6 decoder layers                           │
│      Residual connections + layer norm for stability        │
│                                                             │
│   ╔═══════════════════════════════════════════════════════╗ │
│   ║ This architecture powers virtually all modern LLMs    ║ │
│   ╚═══════════════════════════════════════════════════════╝ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 设计建议

- **配色**: 深色背景配亮色代码高亮，科技感
- **图表**: 网络架构图是核心，使用清晰的框图
- **代码**: 使用等宽字体展示公式
- **动画**: 注意力权重可以动态展示
- **风格**: 学术 + 技术，保持专业
