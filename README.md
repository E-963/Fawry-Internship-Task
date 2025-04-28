# Custom Command and DNS Troubleshooting

## Task 1: Build `mygrep.sh` Script

### Script Requirements
- Create a script named `mygrep.sh`.
- Search for a string in a text file (case-insensitive).
- Support options:
  - `-n` → Show line numbers.
  - `-v` → Invert match (print non-matching lines).
  - Combinations like `-vn` or `-nv` must work.

### Technical Conditions
- Script must be executable (`chmod +x mygrep.sh`).
- Validate input (e.g., check file existence, correct arguments).
- Output should mimic `grep` as closely as possible.

### Testing Cases (with `testfile.txt`)

Content of `testfile.txt`:
```
Hello world
This is a test
another test line
HELLO AGAIN
Don't match this line
Testing one two three
```

Run and capture screenshots for the following tests:
- `./mygrep.sh hello testfile.txt`
- `./mygrep.sh -n hello testfile.txt`
- `./mygrep.sh -vn hello testfile.txt`
- `./mygrep.sh -v testfile.txt` (should show an error about missing search string)

---

### Reflective Section

**How the Script Handles Arguments and Options**
- Checks if options start with `-`.
- Parses options manually or using `getopts`.
- Validates if both a search string and filename are provided.
- Handles missing file or missing search string errors.
- Executes search based on passed options.

**How Structure Would Change for More Options**
- To support regex or options like `-i`, `-c`, `-l`, the script would need advanced option parsing.
- Regular expression matching would replace simple string matching.
- Structure would be modular, with separate handling for each option.

**Hardest Part**
- Correctly handling combined options like `-vn`.
- Keeping the output format identical to `grep`.

---

### Bonus
- Add support for `--help` to print usage instructions.
- Use `getopts` for cleaner option parsing.

---

## Task 2: DNS Troubleshooting

### Problem Description
The internal dashboard (`internal.example.com`) is unreachable. Users are seeing "host not found" errors.

---

### Step 1: Verify DNS Resolution

Compare DNS responses:
- Using default `/etc/resolv.conf`:
  ```
  nslookup internal.example.com
  ```
- Using Google's DNS server (8.8.8.8):
  ```
  nslookup internal.example.com 8.8.8.8
  ```

---

### Step 2: Diagnose Service Reachability

- Get the IP address from DNS resolution.
- Check service reachability on port 80 or 443:
  ```
  curl http://<resolved-ip>
  ```
  or
  ```
  telnet <resolved-ip> 80
  ```
  or
  ```
  nc -zv <resolved-ip> 80
  ```

- Check if the service is listening:
  ```
  ss -tuln | grep 80
  ```

---

### Step 3: Possible Causes

DNS Layer:
- DNS server is down
- DNS misconfiguration

Network Layer:
- Firewall blocking port 80 or 443
- Routing issues

Service Layer:
- Web server is not running
- Web server is not listening on correct IP or port

Local Machine Layer:
- Wrong or missing `/etc/hosts` entry

---

### Step 4: Propose and Apply Fixes

**DNS Server Issue**
- Confirm:
  ```
  dig internal.example.com @<dns-server-ip>
  ```
- Fix:
  - Update `/etc/resolv.conf`.
  - Restart systemd-resolved:
    ```
    systemctl restart systemd-resolved
    ```

**Firewall Blocking**
- Confirm:
  ```
  sudo iptables -L
  ```
- Fix:
  ```
  sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
  ```

**Web Server Not Running**
- Confirm:
  ```
  systemctl status apache2
  ```
- Fix:
  ```
  sudo systemctl start apache2
  ```

**Incorrect /etc/hosts Entry**
- Confirm:
  ```
  cat /etc/hosts
  ```
- Fix:
  ```
  echo "192.168.1.100 internal.example.com" | sudo tee -a /etc/hosts
  ```

---

### Bonus

- Bypass DNS by adding a manual `/etc/hosts` entry:
  ```
  192.168.1.100 internal.example.com
  ```
- Test it:
  ```
  ping internal.example.com
  curl http://internal.example.com
  ```

- Persist DNS settings:
  ```
  sudo systemctl enable systemd-resolved
  sudo systemctl start systemd-resolved
  ```

---

# Submission Checklist
- `mygrep.sh` script uploaded.
- Screenshots for all required test cases.
- Reflective section answered.
- DNS troubleshooting steps included.
- Bonus tasks completed if possible.

