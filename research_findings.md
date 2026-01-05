# Seimas Open Data Analysis & Transparency Strategy

After a deep dive into the Seimas Open Data portal and existing datasets, I have identified several high-impact data points that can significantly enhance public transparency and help citizens form better-informed opinions.

## 1. Legislative Influence & Activity
*   **Initiated Projects**: Track which MPs are most active in proposing new laws.
*   **Proposal Success Rate**: Compare initiated projects vs. passed laws to see who actually gets things done.
*   **Amendments**: Track who is trying to change existing bills and in what direction.

## 2. Financial & Resource Transparency
*   **Assistants & Secretaries**: Publicly list who is working for each MP. This helps identify potential nepotism or lobbying connections.
*   **Business Trips (Komandiruotės)**: Track where MPs are traveling, for how long, and at what cost to the taxpayer.
*   **Agenda Transparency**: Real-time tracking of MP daily agendas to see who they are meeting with.

## 3. Voting Behavior & Accountability
*   **Voting Attendance**: Beyond just "active/inactive," track exact attendance percentages for plenary sessions.
*   **Party Loyalty vs. Independence**: Calculate how often an MP votes against their own party's majority.
*   **Specific Issue Tracking**: Group votes by category (e.g., Environment, Tax, Human Rights) to show an MP's actual stance on specific topics.

## 4. Committee & Commission Work
*   **Committee Attendance**: Much of the real work happens in committees. Tracking attendance and activity here is crucial.
*   **Committee Roles**: Highlight chairs and vice-chairs who hold significant power over specific sectors.

## Proposed Integration Plan
1.  **Phase 1: MP Assistants & Trips**: These are relatively easy to extract and provide immediate "interest" value for the public.
2.  **Phase 2: Legislative Success Metrics**: Calculate "Efficiency Scores" based on initiated vs. passed projects.
3.  **Phase 3: Deep Voting Analysis**: Categorize bills to provide "Stance Profiles" for each MP.

## Technical Strategy
Since direct XML API access is restricted, I will use a **hybrid extraction method**:
*   **Automated Browser Scraping**: For high-level lists (Assistants, Trips).
*   **OpenSanctions/Mirror Sources**: For core identity and PEP (Politically Exposed Person) data.
*   **Manual Data Dumps**: For complex historical voting records if needed.
