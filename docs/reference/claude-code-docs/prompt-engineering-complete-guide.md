# Claude Prompt Engineering - Complete Guide

**Source:** https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/

**Consolidated:** 2025-10-09

---

# Table of Contents

1. [Prompt Engineering Overview](#prompt-engineering-overview)
2. [Prompt Generator](#prompt-generator)
3. [Be Clear and Direct](#be-clear-and-direct)
4. [Use Examples (Multishot Prompting)](#use-examples-multishot-prompting)
5. [Let Claude Think (Chain of Thought)](#let-claude-think-chain-of-thought)
6. [Use XML Tags](#use-xml-tags)
7. [System Prompts (Role Prompting)](#system-prompts-role-prompting)
8. [Prefill Claude's Response](#prefill-claudes-response)
9. [Chain Complex Prompts](#chain-complex-prompts)
10. [Long Context Tips](#long-context-tips)

---

# Prompt Engineering Overview

## Before Prompt Engineering

Prerequisites:
1. Clear success criteria for your use case
2. Methods to empirically test those criteria
3. A first draft prompt to improve

## When to Prompt Engineer

### Prompting vs. Finetuning

Prompt engineering offers several advantages:
- Resource efficiency
- Cost-effectiveness
- Maintains model updates
- Time-saving
- Minimal data requirements
- Rapid iteration
- Domain adaptation
- Preserves general knowledge
- Transparency

## How to Prompt Engineer

Recommended techniques (in order):
1. Use Prompt Generator
2. Be clear and direct
3. Use examples (multishot)
4. Let Claude think (chain of thought)
5. Use XML tags
6. Give Claude a role (system prompts)
7. Prefill Claude's response
8. Chain complex prompts
9. Apply long context tips

## Prompt Engineering Tutorials

Two interactive learning options:
- [GitHub prompting tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial)
- [Google Sheets prompting tutorial](https://docs.google.com/spreadsheets/d/19jzLgRruG9kjUQNKtCg1ZjdD6l6weA6qRXG5zLIAhC8)

## Key Insights

> "Prompt engineering is far faster than other methods of model behavior control"

The approach focuses on crafting effective text instructions to guide AI behavior without extensive retraining, often yielding significant performance improvements quickly.

---

# Prompt Generator

## Overview

The prompt generator is a tool designed to help users create high-quality prompt templates for Claude models. Key points include:

- Compatible with all Claude models, including those with extended thinking capabilities
- Helps solve the "blank page problem" by providing a starting point for prompts
- Follows prompt engineering best practices

## How to Use

### Access Options
1. Try the prompt generator directly on the [Claude Console](https://console.anthropic.com/dashboard)
2. Explore the [prompt generator Google Colab notebook](https://anthropic.com/metaprompt-notebook/)
   - Requires an [API key](https://console.anthropic.com/settings/keys)

## Key Insights

> "Sometimes, the hardest part of using an AI model is figuring out how to prompt it effectively."

The tool is particularly useful for:
- Generating initial draft prompt templates
- Providing a foundation for further testing and iteration
- Overcoming initial uncertainty in prompt creation

## Next Steps

Additional resources:
- [Prompt library](https://docs.claude.com/en/resources/prompt-library/library)
- [GitHub prompting tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial)
- [Google Sheets prompting tutorial](https://docs.google.com/spreadsheets/d/19jzLgRruG9kjUQNKtCg1ZjdD6l6weA6qRXG5zLIAhC8)

---

# Be Clear and Direct

## Key Principles of Prompting Claude

When interacting with Claude, treat it like a "brilliant but very new employee (with amnesia) who needs explicit instructions." The more precisely you explain what you want, the better Claude's response will be.

### Golden Rule of Clear Prompting
> "Show your prompt to a colleague, ideally someone who has minimal context on the task, and ask them to follow the instructions. If they're confused, Claude will likely be too."

## How to Be Clear, Contextual, and Specific

### Provide Contextual Information
Give Claude additional context such as:
- What the task results will be used for
- The intended audience
- The workflow the task belongs to
- The end goal of the task
- What a successful task completion looks like

### Be Specific About Expectations
- Clearly state exactly what you want Claude to do
- For example, if you want only code output, explicitly say so
- Provide instructions as sequential, numbered steps

## Examples

### Example 1: Anonymizing Customer Feedback

#### Unclear Prompt
```
Please remove all personally identifiable information from these customer feedback messages: {{FEEDBACK_DATA}}
```

#### Clear Prompt
```
Your task is to anonymize customer feedback for our quarterly review.

Instructions:
1. Replace all customer names with "CUSTOMER_[ID]"
2. Replace email addresses with "EMAIL_[ID]@example.com"
3. Redact phone numbers as "PHONE_[ID]"
4. If a message mentions a specific product, leave it intact
5. If no PII is found, copy the message verbatim
6. Output only the processed messages, separated by "---"

Data to process: {{FEEDBACK_DATA}}
```

### Example 2: Marketing Email Campaign

#### Vague Prompt
```
Write a marketing email for our new AcmeCloud features.
```

#### Specific Prompt
```
Your task is to craft a targeted marketing email for our Q3 AcmeCloud feature release.

Instructions:
1. Write for mid-size tech companies (100-500 employees) upgrading from on-prem to cloud
2. Highlight 3 key new features: advanced data encryption, real-time collaboration, automated backups
3. Use a professional yet approachable tone
4. Keep it under 200 words
5. Include a clear call-to-action to schedule a demo
6. End with contact information: demo@acmecloud.com

Context: This is part of our Q3 campaign targeting companies concerned about data security during cloud migration.
```

---

# Use Examples (Multishot Prompting)

## Why use examples?

Examples are a powerful technique to improve Claude's performance by:
- Increasing accuracy
- Ensuring consistency
- Enhancing output quality

## Crafting Effective Examples

Key principles for creating effective examples:

1. **Relevance**: Examples should closely match your specific use case
2. **Diversity**: Include varied examples that cover different scenarios
3. **Clarity**: Use XML tags to structure examples

### Example: Customer Feedback Analysis

**Without Examples:**
Claude provides a generic, less structured analysis of customer feedback.

**With Examples:**
```xml
<examples>
<example>
Input: The new dashboard is a mess! It takes forever to load, and I can't find the export button. Fix this ASAP!
Category: UI/UX, Performance
Sentiment: Negative
Priority: High
</example>
</examples>
```

By providing a structured example, Claude can:
- Categorize feedback more precisely
- Rate sentiment consistently
- Assign appropriate priority levels

## Pro Tips
- Include 3-5 diverse, relevant examples
- More examples generally lead to better performance
- Ask Claude to evaluate or generate additional examples if needed

## Recommended Resources
- [Prompt Library](https://docs.claude.com/en/resources/prompt-library/library)
- [GitHub Prompting Tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial)
- [Google Sheets Prompting Tutorial](https://docs.google.com/spreadsheets/d/19jzLgRruG9kjUQNKtCg1ZjdD6l6weA6qRXG5zLIAhC8)

---

# Let Claude Think (Chain of Thought)

## Before Implementing Chain of Thought (CoT)

### Why Let Claude Think?

Benefits of chain of thought prompting:
- **Accuracy:** Reduces errors in complex tasks like math, logic, and analysis
- **Coherence:** Creates more structured and organized responses
- **Debugging:** Helps identify where prompts might be unclear

### Why Not Let Claude Think?

Potential drawbacks:
- Increased output length may impact latency
- Not suitable for all tasks
- Best used for complex problems requiring multi-step reasoning

## How to Prompt for Thinking

CoT techniques (from least to most complex):

### 1. Basic Prompt
- Simply include "Think step-by-step"
- Lacks specific guidance
- Least structured approach

### 2. Guided Prompt
- Outline specific steps for thinking process
- More detailed than basic prompt
- Still lacks clear structure

### 3. Structured Prompt
- Use XML tags like `<thinking>` and `<answer>`
- Separates reasoning from final answer
- Most comprehensive approach

## Examples

### Financial Analysis Without Thinking

Without step-by-step reasoning, Claude provides a surface-level recommendation without deep analysis.

### Financial Analysis With Thinking

With chain of thought:
- Breaks down problem systematically
- Calculates exact figures
- Considers multiple factors
- Provides a more nuanced and confident recommendation

## Key Tips

- Always have Claude output its thinking process
- Use CoT for tasks a human would carefully think through
- Balance depth of analysis with context window constraints

## Recommended Use Cases

- Complex mathematical problems
- Multi-step analysis
- Writing detailed documents
- Decision-making with multiple factors

---

# Use XML Tags

## Why use XML tags?

XML tags help structure prompts by:
- Providing clarity
- Improving accuracy
- Offering flexibility
- Making responses easier to parse

## Tagging Best Practices

1. Be consistent with tag names
2. Nest tags hierarchically
3. Use meaningful tag names that describe the content

## Examples

### Financial Report Example

**Without XML tags:**
- Claude might misunderstand the task structure
- Potential mixing of instructions and context

**With XML tags:**
```xml
<instructions>
1. Include sections: Revenue Growth, Profit Margins, Cash Flow
2. Highlight strengths and areas for improvement
</instructions>

<data>{{SPREADSHEET_DATA}}</data>

<formatting_example>{{Q1_REPORT}}</formatting_example>
```

### Legal Contract Analysis Example

**Without XML tags:**
- Disorganized analysis
- Missed key points

**With XML tags:**
```xml
<instructions>
1. Analyze these clauses:
- Indemnification
- Limitation of liability
- IP ownership

2. Note unusual or concerning terms
3. Compare to our standard contract
4. Summarize findings
5. List actionable recommendations
</instructions>

<agreement>{{CONTRACT}}</agreement>

<standard_contract>{{STANDARD_CONTRACT}}</standard_contract>
```

**Power user tip**: Combine XML tags with other techniques like multishot prompting and chain of thought for more structured, high-performance prompts.

---

# System Prompts (Role Prompting)

## Why Use Role Prompting?

Role prompting can:
- Enhance accuracy in complex scenarios
- Tailor communication tone
- Improve focus on specific task requirements

## How to Give Claude a Role

Use the `system` parameter in the Messages API:

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-3-7-sonnet-20250219",
    max_tokens=2048,
    system="You are a seasoned data scientist at a Fortune 500 company.",
    messages=[
        {"role": "user", "content": "Analyze this dataset for anomalies: <dataset>{{DATASET}}</dataset>"}
    ]
)
```

**Tip**: Experiment with specific role details. A "data scientist specializing in customer insight analysis" might yield different insights than a general data scientist.

## Examples

### Example 1: Legal Contract Analysis

**Without Role Prompting:**
- Generic summary of contract points
- Misses critical risk details

**With Role Prompting (as General Counsel):**
- Identifies serious contractual risks
- Provides professional, detailed analysis
- Recommends specific actions to mitigate risks

### Example 2: Financial Analysis

**Without Role Prompting:**
- Basic financial summary
- Surface-level observations

**With Role Prompting (as CFO):**
- Deeper strategic insights
- Actionable recommendations
- Considers investor perspectives
- Highlights potential concerns and growth strategies

## Key Takeaways

- The system prompt sets Claude's professional context
- More specific roles lead to more nuanced responses
- Use roles to align Claude's analysis with specific professional perspectives

---

# Prefill Claude's Response

## How to Prefill Claude's Response

Prefilling allows you to guide Claude's responses by including initial text in the `Assistant` message. This technique helps:
- Direct Claude's actions
- Skip preambles
- Enforce specific formats
- Maintain character consistency

### Basic Example

```python
import anthropic

client = anthropic.Anthropic()
response = client.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "What is your favorite color?"},
        {"role": "assistant", "content": "As an AI assistant, I don't have a favorite color, But if I had to pick, it would be green because"}  # Prefill here
    ]
)
```

**Important Notes:**
- The prefill content cannot end with trailing whitespace
- Prefilling is not supported with extended thinking modes

## Example 1: Controlling Output Formatting

**Power User Tip**: Prefilling `{` forces Claude to skip the preamble and directly output a JSON object.

### Without Prefilling
When extracting product details without prefilling, Claude provides a verbose response with explanations.

### With Prefilling
By prefilling with `{`, Claude directly outputs the structured JSON:

```json
{
  "name": "SmartHome Mini",
  "size": "5 inches wide",
  "price": "$49.99",
  "colors": [
    "black",
    "white"
  ]
}
```

## Example 2: Maintaining Character in Roleplay

**Role-play Tip**: Prefilling a bracketed `[ROLE_NAME]` helps Claude maintain character, especially in longer conversations.

### Without Role Prompting
Without specific guidance, Claude might respond generically.

### With Role Prompting
Prefilling `[Sherlock Holmes]` helps Claude stay in character:

```
[Sherlock Holmes]

Ah, what have we here? A most curious specimen, Watson! Let us examine this shoe with a discerning eye...
```

## Key Takeaways
- Prefilling offers fine-grained control over Claude's output format and style
- Use prefilling to skip preambles and get directly to structured output
- Particularly useful for maintaining consistency in roleplay scenarios

---

# Chain Complex Prompts

## Why Chain Prompts?

Prompt chaining breaks down complex tasks into smaller, manageable subtasks. Key benefits include:

1. **Accuracy**: Each subtask gets Claude's full attention
2. **Clarity**: Simpler instructions lead to clearer outputs
3. **Traceability**: Easily identify and fix issues in the prompt chain

## When to Chain Prompts

Use prompt chaining for:
- Multi-step research synthesis
- Document analysis
- Iterative content creation
- Tasks involving multiple transformations or complex instructions

**Debugging Tip**: If Claude struggles with a step, isolate that specific subtask in its own prompt.

## How to Chain Prompts

1. Break task into distinct, sequential steps
2. Use XML tags for clear handoffs between prompts
3. Ensure each subtask has a single, clear objective
4. Iterate and refine based on performance

### Example Chained Workflows

- **Content creation**: Research → Outline → Draft → Edit → Format
- **Data processing**: Extract → Transform → Analyze → Visualize
- **Decision-making**: Gather info → List options → Analyze → Recommend
- **Verification loops**: Generate → Review → Refine → Re-review

## Advanced: Self-Correction Chains

Create prompts that have Claude review and improve its own work. This is especially useful for high-stakes tasks.

### Example: Self-Correcting Research Summary

1. **First Prompt**: Generate initial summary
2. **Second Prompt**: Review summary for accuracy, clarity, completeness
3. **Third Prompt**: Refine summary based on feedback

## Practical Tips

- For independent subtasks, run prompts in parallel for efficiency
- Use clear, specific instructions for each step
- Leverage XML tags to structure prompt handoffs
- Continuously test and refine your prompt chains

## Use Cases

The documentation includes detailed examples of prompt chaining for:
- Legal contract analysis
- Multitenancy strategy review
- Medical research paper summarization

Each example demonstrates breaking complex tasks into manageable, focused subtasks.

---

# Long Context Tips

## Essential Tips for Long Context Prompts

### 1. Document Placement
- Place long documents and inputs (~20K+ tokens) near the top of your prompt, above your query and instructions
- Placing queries at the end can improve response quality by up to 30%, especially with complex, multi-document inputs

### 2. Structuring Document Content
Use XML tags to organize multiple documents with metadata:

```xml
<documents>
  <document index="1">
    <source>annual_report_2023.pdf</source>
    <document_content>
      {{ANNUAL_REPORT}}
    </document_content>
  </document>
  <document index="2">
    <source>competitor_analysis_q2.xlsx</source>
    <document_content>
      {{COMPETITOR_ANALYSIS}}
    </document_content>
  </document>
</documents>

Analyze the annual report and competitor analysis. Identify strategic advantages and recommend Q3 focus areas.
```

### 3. Grounding Responses in Quotes
Ask Claude to quote relevant parts of documents first to help cut through the "noise" of document contents:

```xml
You are an AI physician's assistant. Your task is to help doctors diagnose possible patient illnesses.

<documents>
  <document index="1">
    <source>patient_symptoms.txt</source>
    <document_content>
      {{PATIENT_SYMPTOMS}}
    </document_content>
  </document>
  <document index="2">
    <source>patient_records.txt</source>
    <document_content>
      {{PATIENT_RECORDS}}
    </document_content>
  </document>
  <document index="3">
    <source>patient01_appt_history.txt</source>
    <document_content>
      {{PATIENT01_APPOINTMENT_HISTORY}}
    </document_content>
  </document>
</documents>

Find quotes from the patient records and appointment history that are relevant to diagnosing the patient's reported symptoms. Place these in <quotes> tags. Then, based on these quotes, list all information that would help the doctor diagnose the patient's symptoms.
```

## Key Strategies

1. **Structure matters**: Use XML tags to organize multiple documents
2. **Query placement**: Put instructions after long content for better results
3. **Quote grounding**: Have Claude cite relevant passages before answering
4. **Metadata inclusion**: Add source information to help Claude track references

---

# Additional Resources

- **Prompt Library**: https://docs.claude.com/en/resources/prompt-library/library
- **GitHub Prompting Tutorial**: https://github.com/anthropics/prompt-eng-interactive-tutorial
- **Google Sheets Tutorial**: https://docs.google.com/spreadsheets/d/19jzLgRruG9kjUQNKtCg1ZjdD6l6weA6qRXG5zLIAhC8
- **Claude Console**: https://console.anthropic.com/dashboard
- **API Keys**: https://console.anthropic.com/settings/keys
- **Metaprompt Notebook**: https://anthropic.com/metaprompt-notebook/

---

**Document consolidated from:** https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/

**All content © Anthropic - Used for educational reference purposes**
