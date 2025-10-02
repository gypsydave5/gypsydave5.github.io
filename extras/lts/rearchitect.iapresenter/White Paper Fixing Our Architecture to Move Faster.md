# White Paper: Fixing Our Architecture to Move Faster

### **Executive Summary**

Our current architecture is slowing us down. We've ended up in a situation where our **Editorial** system has become an accidental data hoarder. It was built to manage peer review, but now it's also the gatekeeper for almost all submission data.

The result is that every other service is coupled to it, forcing them to ask `Editorial` for data that has nothing to do with the editorial process itself. Making even a simple data change has become a slow, risky chore. This document is my proposal for how we untangle this knot by separating the data from the process that manages it. It’s a plan to get us back to building features quickly and safely.

### **1. Why We Need to Change Things**

If you've worked on our peer review system, you know it's made up of four main parts: **Submission**, **Editorial**, **Sonic**, and **Production**. On the surface, this looks like a decent separation of concerns. The problem is how they talk to each other.

Right now, the data flow has created a real bottleneck. The **Editorial** system has become the center of the universe for data it doesn’t even need. This tight coupling means that a simple change in one place ripples across the entire ecosystem, making our work slow and error-prone. This paper lays out a plan to fix that by decoupling the data from the process.

### **2. Where We Are Today: The Central Bottleneck**

Here's the core of the problem: when an author submits their work, the **Submission** system hands over the *entire* data blob to the **Editorial** system. `Editorial` is now the owner.

The thing is, `Editorial` only cares about the *process* of peer review, not the gigabytes of author-provided content. But because it's holding all the data, every other system has to go back to it with questions. The **Production** system needs to ask it for the data to publish. Even the original **Submission** system has to ask it for the old data when an author wants to make a new version. It's a roundabout and inefficient way to work.

~~~mermaid
graph TD
    subgraph "Problem: Tight Coupling via Editorial"
        A[Submission System] -- "Sends ENTIRE Submission Data Blob" --> B((Editorial System));
        B -- "Acts as Data Store" --> B;
        C[Sonic API] -. "Reads from" .-> B;

        A -- "Queries for its OWN old data to create new version" --> C;
        D[Production System] -- "Queries for data needed to publish" --> C;
    end

    style B fill:#ffcccc,stroke:#cc0000
    style C fill:#cde4ff,stroke:#cc0000
~~~

The fundamental issue here is that we've coupled two different sets of data—the submission data and the peer review data—into a single storage medium: the Editorial event source. The submission data is the science itself, and it changes when authors make revisions. The peer review data is the review *of* that science, and it changes when editors or reviewers take action. Because the reasons for change are different, and the data is interesting to different people for different reasons, binding them together this tightly makes it harder to evolve each one independently.

*As you can see, the **Editorial System** has become a bottleneck. It's holding data hostage, and everyone else has to line up and ask for it back.*

### **3. The Plan: Separating Submission Data from Review Data**

So, how do we fix this? The answer is to stop mixing up the *data* of a submission with the data generated from the *process* of reviewing it. Or, in other words we separate the data that Authors give us from the data that Editors/Reviewers give us. I'm proposing we build a new, dedicated service whose only job is to be the source of truth for submission content: the **Submission Record Store**.

This simple change clarifies the role of every other system:

* **Submission System:** Becomes a straightforward client that writes new versions to the `Store`.
* **Editorial System:** Stops being a data warehouse. It gets notified of a new submission and focuses purely on managing the peer review workflow.
* **Sonic & Production:** They get the data they need directly from the source that owns it—the `Store`—and they ask `Editorial` for what *it* owns: the review status.

#### **A Couple of Important Rules**

To make sure this works well, we need two ground rules:

1. **One Team Owns Both:** The same team that owns the **Submission System** should also own the **Submission Record Store**. The writer and the store need to be in sync.
2. **Only One Writer:** The **Submission System** is the only service that can write to the `Store`. Everyone else gets read-only access. This prevents confusion and keeps the data clean.
3. **No delete:** once submitted, the record will remain there as the permanent source of truth for a submission's author-provided data
4. **No edit:** and so can never be edited; only new versions can be submitted

~~~mermaid
graph TD
    subgraph "Decoupled Future State"
        A[Submission System] -- "Writes [WRITE ACCESS ONLY]" --> E((Submission Record Store));

        subgraph "Notification Flow"
            E -- "Notifies (e.g., Publishes Event)" --> B[Editorial System];
        end

        B -- "Manages Peer Review Process" --> B;

        C[Sonic API] -- "Reads Data [Read-Only]" --> E;
        C -- "Reads Status" --> B;

        D[Production System] -- "Reads Data [Read-Only]" --> E;
        D -- "Reads Status" --> B;
    end

    style E fill:#d4edda,stroke:#155724
~~~

### **4. How We Get There: The Migration Plan**

This is a big change, but we don't have to do it all at once. I've mapped out a careful, step-by-step plan to get us there without breaking anything.

**Phase 1: Build the New Store**
* First, we build the standalone **Submission Record Store** service.
* We lock it down so only the **Submission System** can write to it.
* We get it deployed and ready for action.

**Phase 2: Switch on for New Submissions**
* We update the **Submission System** to send all *new* submissions to our new `Store`.
* `Sonic` and `Production` are updated to check the new `Store` first. If the record isn't there, they fall back to the old way of asking `Editorial`.

**Phase 3: Migrate the Old Data**
* We'll run a background script to move all the historical submission data from `Editorial` over to the `Store`, with plenty of validation to make sure nothing gets lost.

**Phase 4: Cut Over Completely**
* Once all the data is moved, we switch off the fallback. All systems now *only* ask the `Store` for submission data.
* Finally, we can delete the old code and data from the **Editorial** system, and the decoupling is complete.



#### Note

Given that we already use the PRS sender between the Submissions System and Editorial to communicate a new submission, we _could_ choose to convert it into the Submission Record Store

##### Benefits

- already implements an outbox pattern for messaging the Editorial System
- already recieves the whole of a submission record

##### Downsides

- probably a lot of stuff in there that we don't need
- PRS sender is coupled and embedded in the Submission System
- misseed opportunity to build out new and better.





### **5. In Conclusion**

We've hit a wall with the way things are built today. It's not a bug, it's a design problem, and it's holding us back. This plan to introduce a **Submission Record Store** directly tackles that problem.

By separating what a submission *is* from the *process* of what we do with it, we'll get clearer ownership and the ability to make changes faster and more safely. This is an investment in our platform that will pay off by letting us focus on building better features instead of wrestling with a tangled architecture.