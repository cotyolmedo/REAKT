# REAKT ExecPlans

## Purpose

An ExecPlan is a living implementation document for complex REAKT work.

Use one when a task:

- changes multiple subsystems
- changes architecture
- introduces a substantial feature
- changes the communication protocol
- changes the database schema
- requires significant refactoring
- is expected to take multiple implementation steps

Do not create an ExecPlan for a trivial typo, one-line fix or isolated configuration change.

## Required structure

Every ExecPlan should contain:

### 1. Objective

What must exist when the work is complete.

### 2. Current state

What exists now and which files/components are relevant.

### 3. Requirements

Explicit functional and technical requirements.

### 4. Constraints

Hardware, software, compatibility, school requirements and project rules.

### 5. Design

Describe the proposed architecture and data/control flow.

### 6. Implementation steps

Numbered, concrete steps that can be executed and validated.

### 7. Validation

Tests, builds, simulations or inspections required to verify the result.

### 8. Documentation changes

Which documentation files must be updated.

### 9. Risks and rollback

Potential failure modes and how to revert safely.

### 10. Status

Mark each step as:

- `[ ]` pending
- `[~]` in progress
- `[x]` completed
- `[!]` blocked

## Living-document rule

Update the plan as implementation progresses.

If the implementation discovers that the original plan is wrong, update the plan rather than silently diverging from it.

An ExecPlan is not permission to invent requirements. It is a record of an agreed technical approach.
