## Why is SQL Injection Dangerous?

SQL injection is not just a theoretical vulnerability — it's one of the most exploited flaws in real-world systems. Here's why it's so dangerous:

### What an attacker can do:
- **Read sensitive data** — including user passwords, emails, financial records, etc.
- **Modify or delete data** — which can corrupt the integrity of the system.
- **Bypass authentication** — for example, by injecting `' OR '1'='1` into login fields.
- **Execute administrative commands** — like dropping tables or changing user roles.
- **In some cases, execute OS-level commands** — if the database is misconfigured or the code is poorly secured.

### Real-world consequences:
- **Massive data breaches** — with millions of records exposed.
- **Financial losses** — including fraud and stolen payment info.
- **Reputation damage** — especially when personal data is leaked.
- **Legal penalties** — under data protection laws like GDPR or CCPA.

### Still relevant today:
SQL injection remains a top threat in the [OWASP Top 10](https://owasp.org/www-project-top-ten/) under category:
- **A03:2021 – Injection**

This category includes SQL, command, NoSQL, and other types of injection attacks. Despite being well-known, these vulnerabilities are still found in many applications due to insecure coding practices.

### Good news:
SQL injection is **easy to prevent**:
- Use **prepared statements** and **parameterized queries**
- Avoid string concatenation with user input in SQL queries
- Use static analysis tools like `plpgsql_check` to review database procedures