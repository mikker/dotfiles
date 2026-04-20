# Mermaid Syntax Reference

Quick reference for generating valid Mermaid diagram code.

## Flowchart

```mermaid
graph TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Action 1]
    B -->|No| D[Action 2]
    C --> E[End]
    D --> E
```

### Direction
- `TD` / `TB` - Top to bottom
- `BT` - Bottom to top
- `LR` - Left to right
- `RL` - Right to left

### Node Shapes
- `A[Text]` - Rectangle
- `A(Text)` - Rounded rectangle
- `A([Text])` - Stadium/pill
- `A[[Text]]` - Subroutine
- `A[(Text)]` - Cylinder (database)
- `A((Text))` - Circle
- `A>Text]` - Asymmetric
- `A{Text}` - Diamond (decision)
- `A{{Text}}` - Hexagon
- `A[/Text/]` - Parallelogram
- `A[\Text\]` - Parallelogram alt
- `A[/Text\]` - Trapezoid
- `A[\Text/]` - Trapezoid alt

### Edge Styles
- `A --> B` - Arrow
- `A --- B` - Line
- `A -.-> B` - Dotted arrow
- `A ==> B` - Thick arrow
- `A -->|text| B` - Arrow with label (preferred)
- `A ---|text| B` - Line with label (preferred)

**Important**: Always use pipe syntax `-->|label|` for edge labels. The space-dash syntax `-- label -->` can cause incomplete renders.

### Subgraphs
```mermaid
graph TD
    subgraph Group1 [Label]
        A --> B
    end
    subgraph Group2
        C --> D
    end
    B --> C
```

## Sequence Diagram

```mermaid
sequenceDiagram
    participant A as Alice
    participant B as Bob
    A->>B: Hello
    B-->>A: Hi there
    A->>+B: Start process
    B-->>-A: Done
```

### Arrow Types
- `->>` - Solid arrow
- `-->>` - Dashed arrow
- `-x` - Solid with x
- `--x` - Dashed with x
- `-)` - Solid open arrow
- `--)` - Dashed open arrow

### Activations
- `+` after arrow activates participant
- `-` after arrow deactivates participant

### Notes and Boxes
```mermaid
sequenceDiagram
    Note over A,B: Shared note
    Note right of A: Side note
    rect rgb(200, 220, 255)
        A->>B: In a box
    end
```

### Loops and Conditionals
```mermaid
sequenceDiagram
    loop Every minute
        A->>B: Ping
    end
    alt Success
        B-->>A: Pong
    else Failure
        B-->>A: Error
    end
    opt Optional
        A->>B: Extra step
    end
```

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing : start
    Processing --> Done : complete
    Processing --> Error : fail
    Error --> Idle : reset
    Done --> [*]
```

### Composite States
```mermaid
stateDiagram-v2
    state Active {
        [*] --> Running
        Running --> Paused : pause
        Paused --> Running : resume
    }
    Idle --> Active : activate
    Active --> Idle : deactivate
```

### Notes
```mermaid
stateDiagram-v2
    State1 : Description here
    note right of State1
        Additional info
    end note
```

## Class Diagram

```mermaid
classDiagram
    class Animal {
        +String name
        +int age
        +makeSound() void
    }
    class Dog {
        +bark() void
    }
    Animal <|-- Dog : extends
```

### Relationships
- `<|--` - Inheritance
- `*--` - Composition
- `o--` - Aggregation
- `-->` - Association
- `--` - Link (solid)
- `..>` - Dependency
- `..|>` - Realisation
- `..` - Link (dashed)

### Cardinality
```mermaid
classDiagram
    Customer "1" --> "*" Order
    Order "1" --> "1..*" LineItem
```

### Visibility
- `+` Public
- `-` Private
- `#` Protected
- `~` Package/Internal

## Entity-Relationship Diagram

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    PRODUCT }|..|{ LINE-ITEM : "ordered in"
```

### Relationship Types
- `||` - Exactly one
- `|{` - One or more
- `o{` - Zero or more
- `o|` - Zero or one

### Identifying vs Non-identifying
- `--` - Identifying (solid)
- `..` - Non-identifying (dashed)

### Attributes
```mermaid
erDiagram
    CUSTOMER {
        string id PK
        string name
        string email UK
    }
    ORDER {
        int id PK
        string customer_id FK
        date created_at
    }
```

## Styling

### CSS Classes
```mermaid
graph TD
    A:::highlight --> B
    classDef highlight fill:#f96,stroke:#333
```

### Inline Styles
```mermaid
graph TD
    A --> B
    style A fill:#bbf,stroke:#333
```

## Tips

1. **Escape special characters**: Use quotes for labels with special chars: `A["Label with (parens)"]`
2. **Multi-line labels**: Use `<br/>` for line breaks
3. **Comments**: Use `%%` for comments that won't render
4. **IDs vs Labels**: Node IDs should be simple, labels can be complex: `node1["Complex Label Here"]`
