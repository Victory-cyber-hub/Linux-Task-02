# Secure File Management & User Configuration on Kali Linux

![Kali Linux](https://img.shields.io/badge/Platform-Kali%20Linux-557C94?logo=kalilinux&logoColor=white)
![Linux](https://img.shields.io/badge/Focus-Linux%20Administration-FCC624?logo=linux&logoColor=black)
![Level](https://img.shields.io/badge/Level-Beginner%20Friendly-success)
![Portfolio](https://img.shields.io/badge/Portfolio-Cybersecurity%20Lab-blue)

A beginner-friendly Linux administration practical lab demonstrating **user creation, secure file management, directory organization, Linux permissions, file copying/removal, command history, and ownership changes** on Kali Linux.

> **Source workflow:** This repository is based on the supplied practical task, *Secure File Management & User Configuration on Kali Linux*. The original task requires that file operations be performed as the newly created user rather than root, with the ownership-change step explicitly performed as root. See the supplied workflow for the authoritative assignment requirements.

---

## 📌 Lab Overview

The goal of this practical is to demonstrate fundamental Linux filesystem and user-management skills by creating a dedicated user account and building a secure workspace.

The workflow covers:

- Creating a Linux user with a home directory and Bash shell
- Adding the user to the `sudo` group
- Switching from the administrative account to the new user
- Creating a structured workspace
- Creating and listing files
- Redirecting command output into evidence files
- Copying and deleting files
- Applying restrictive file permissions with `chmod`
- Simulating an error and recovering from it
- Observing the effect of changing file ownership
- Preserving command history and final filesystem evidence

## 🎯 Learning Objectives

By completing this lab, you should be able to:

1. Create a Linux user with `useradd`.
2. Configure a user's shell, home directory, and group membership.
3. Navigate the Linux filesystem with `cd`.
4. Create directories and files using `mkdir` and `touch`.
5. Inspect directory contents with `ls`, `ls -l`, and `ls -la`.
6. Redirect command output into files.
7. Copy files with `cp` and remove files with `rm`.
8. Apply specific permissions using `chmod`.
9. Verify permissions with `ls -l`.
10. Understand the practical effect of file ownership changes.

---

## 🧪 Lab Environment

| Component | Requirement |
|---|---|
| Operating System | Kali Linux |
| Primary account | Existing administrative/sudo-capable account |
| New lab user | `agent007` |
| Shell | `/bin/bash` |
| Workspace | `/home/agent007/mission/` |
| Required tools | `useradd`, `usermod`, `mkdir`, `cd`, `touch`, `ls`, `cp`, `rm`, `chmod` |

### Important assignment rule

The supplied workflow states that **root must not be used for the file operations**. The new `agent007` account should perform the lab operations after creation. The final ownership-change exercise is the exception because it explicitly requires root.

---

## 🗺️ Workspace Structure

The target structure is:

```text
/home/agent007/mission/
├── intel/
│   ├── targets.txt
│   ├── routes.txt
│   ├── keys.txt
│   ├── listing1.txt
│   ├── listing2.txt
│   └── listing3.txt
└── ops/
    └── backup/
        └── routes.txt
```

> **Note:** `keys.txt` is intentionally removed during the workflow, so it should **not** appear in the final state.

---

# 🚀 Lab Procedure

## 1. Create the New User

Run the following command from an account authorized to use `sudo`:

```bash
sudo useradd -m -s /bin/bash -G sudo agent007
```

### What it does

- `sudo` — executes the command with administrative privileges.
- `useradd` — creates the user account.
- `-m` — creates the user's home directory.
- `-s /bin/bash` — assigns Bash as the login shell.
- `-G sudo` — adds the user to the `sudo` supplementary group.
- `agent007` — the username.

---

## 2. Set the Password and Switch User

Set the password:

```bash
sudo passwd agent007
```

Then switch to the new account:

```bash
su - agent007
```

Verify the active user:

```bash
whoami
```

Expected result:

```text
agent007
```

Verify the home directory:

```bash
pwd
```

Expected result:

```text
/home/agent007
```

From this point onward, perform the lab's file operations as `agent007`.

---

## 3. Create the Workspace

Create the required directory structure:

```bash
mkdir -p /home/agent007/mission/intel
mkdir -p /home/agent007/mission/ops/backup
```

Move into the workspace:

```bash
cd /home/agent007/mission
```

Verify:

```bash
ls -la
```

Then inspect recursively:

```bash
ls -laR /home/agent007/mission/
```

---

## 4. Create the Intel Files

Move into `intel`:

```bash
cd /home/agent007/mission/intel
```

Create the three empty files:

```bash
touch targets.txt routes.txt keys.txt
```

Verify:

```bash
ls
```

Expected initial files:

```text
keys.txt
routes.txt
targets.txt
```

---

## 5. Capture Listing Evidence

The assignment requires three different listings to be redirected into separate files.

Run:

```bash
ls > listing1.txt
ls -l > listing2.txt
ls -la > listing3.txt
```

Inspect the evidence:

```bash
cat listing1.txt
cat listing2.txt
cat listing3.txt
```

### Why three listings?

- `ls` gives a basic directory listing.
- `ls -l` provides detailed information including permissions, ownership, size, and timestamps.
- `ls -la` also shows hidden files such as `.` and `..`.

> Because the listing files are created sequentially, later listings may include files that were created by earlier commands. That is expected behavior.

---

## 6. Copy `routes.txt` to the Backup Directory

From the `intel` directory:

```bash
cp routes.txt ../ops/backup/
```

Verify:

```bash
ls -la ../ops/backup/
```

Expected:

```text
routes.txt
```

---

## 7. Delete `keys.txt`

Remove the file:

```bash
rm keys.txt
```

Verify:

```bash
ls -la
```

`keys.txt` should no longer be present.

---

## 8. Set Secure Permissions on `targets.txt`

The assignment requires:

- Owner: read + write
- Group: read only
- Others: no permissions

Use:

```bash
chmod 640 targets.txt
```

Verify:

```bash
ls -l targets.txt
```

Expected permission pattern:

```text
-rw-r-----
```

### Permission breakdown

```text
-rw-r-----
 |||||||||
 ||||||||+-- others: no permissions
 ||||||+---- group: read
 ||||++----- owner: read + write
```

Numeric representation:

```text
6 4 0
```

Where:

- `6` = read + write
- `4` = read
- `0` = no permissions

---

## 9. Simulate an Error and Recover

Intentionally remove the backup copy:

```bash
rm ../ops/backup/routes.txt
```

Verify that it is gone:

```bash
ls -la ../ops/backup/
```

Now restore it from `intel`:

```bash
cp routes.txt ../ops/backup/
```

Verify recovery:

```bash
ls -la ../ops/backup/
```

The recovered `routes.txt` should be present.

### What this demonstrates

This step demonstrates basic operational recovery using:

- `rm` to remove a file
- `cp` to restore a known-good copy
- `ls` to verify the resulting filesystem state

---

# 🔐 10. Advanced Ownership Exercise

The supplied task specifically requires changing ownership of `targets.txt` **as root**, then switching back to `agent007` and observing the result.

First identify another existing account that can be used as the owner. The original task gives `root` as an example.

As an administrative/root-capable account:

```bash
sudo chown root:root /home/agent007/mission/intel/targets.txt
```

Then switch back to `agent007` if necessary:

```bash
su - agent007
```

Inspect the file:

```bash
ls -l /home/agent007/mission/intel/targets.txt
```

You should observe that the ownership is no longer `agent007`.

### Important

Do not change the ownership back automatically if your assignment requires evidence of the changed owner. Capture the output for your submission.

---

# 📋 Final Verification

Run:

```bash
ls -laR /home/agent007/mission/
```

Save the output:

```bash
ls -laR /home/agent007/mission/ > /home/agent007/mission/final-output.txt
```

Then display it:

```bash
cat /home/agent007/mission/final-output.txt
```

### Final-state checklist

- [ ] `agent007` exists.
- [ ] `agent007` has a home directory.
- [ ] `agent007` uses `/bin/bash`.
- [ ] `agent007` is in the `sudo` group.
- [ ] `mission/intel` exists.
- [ ] `mission/ops/backup` exists.
- [ ] `targets.txt` exists.
- [ ] `routes.txt` exists in `intel`.
- [ ] `keys.txt` was removed.
- [ ] `routes.txt` exists in `backup`.
- [ ] `targets.txt` has the required permissions.
- [ ] Ownership change was demonstrated.
- [ ] Command history was preserved.
- [ ] Final recursive listing was captured.

---

# 🧾 Submission Evidence

The original workflow requires three categories of submission evidence:

### 1. Command history

Copy your relevant command history into:

```text
evidence/command-history.txt
```

You can retrieve recent commands with:

```bash
history
```

Or:

```bash
history > command-history.txt
```

Do not include passwords or other secrets.

### 2. Final recursive listing

Save the final output to:

```text
evidence/final-output.txt
```

Recommended command:

```bash
ls -laR /home/agent007/mission/ > evidence/final-output.txt
```

If `evidence/` is outside the VM workspace, copy/paste the terminal output into the repository file instead.

### 3. Explanation

Complete:

```text
docs/linux-command-explanations.md
```

The assignment specifically asks for a 4–5 line explanation of:

- `chmod`
- `ls -l`
- `useradd`

A starter template is included in this repository.

---

# 🖥️ Screenshot Evidence

Recommended screenshots for a professional GitHub portfolio:

1. User creation command and successful completion.
2. `whoami` showing `agent007`.
3. Workspace structure.
4. File listings using `ls`, `ls -l`, and `ls -la`.
5. `chmod 640 targets.txt` followed by verification.
6. Error/recovery sequence.
7. Ownership change shown with `ls -l`.
8. Final `ls -laR /home/agent007/mission/`.

Store selected screenshots in:

```text
screenshots/
```

Use descriptive names such as:

```text
01-user-created.png
02-agent007-session.png
03-workspace-structure.png
04-file-permissions.png
05-error-recovery.png
06-ownership-change.png
07-final-verification.png
```

---

# 🧠 Key Linux Commands

| Command | Purpose |
|---|---|
| `useradd` | Creates a new Linux user |
| `passwd` | Sets or changes a user's password |
| `su -` | Switches to another user with a login environment |
| `mkdir` | Creates directories |
| `cd` | Changes the current directory |
| `touch` | Creates empty files or updates timestamps |
| `ls` | Lists directory contents |
| `ls -l` | Shows detailed file information |
| `ls -la` | Shows detailed information including hidden files |
| `cp` | Copies files/directories |
| `rm` | Removes files/directories |
| `chmod` | Changes file permissions |
| `chown` | Changes file ownership |
| `history` | Displays shell command history |

---

# 🔎 Understanding Linux Permissions

Linux permissions are commonly represented by three groups:

```text
owner | group | others
```

For the required `targets.txt` permissions:

```text
-rw-r-----
```

This means:

```text
Owner  = rw-  (read/write)
Group  = r--  (read only)
Others = ---  (no access)
```

Equivalent numeric notation:

```text
640
```

This is a practical example of applying the principle of **least privilege** to a file.

---

# 🛠️ Troubleshooting

## `useradd: Permission denied`

Use an account with `sudo` privileges:

```bash
sudo useradd -m -s /bin/bash -G sudo agent007
```

## `su: Authentication failure`

Verify that the password was correctly assigned:

```bash
sudo passwd agent007
```

Then try:

```bash
su - agent007
```

## `No such file or directory`

Check your current location:

```bash
pwd
```

Then inspect the directory:

```bash
ls -la
```

Use an absolute path when needed:

```bash
cd /home/agent007/mission/intel
```

## `Permission denied` when modifying a file

Check:

```bash
ls -l targets.txt
```

If ownership was changed to another account, the current user may no longer be able to modify the file.

## `routes.txt` is missing from backup

Check both locations:

```bash
ls -la /home/agent007/mission/intel/
ls -la /home/agent007/mission/ops/backup/
```

Restore it:

```bash
cp /home/agent007/mission/intel/routes.txt \
/home/agent007/mission/ops/backup/
```

---

# 📁 Repository Structure

```text
linux-secure-file-management-lab/
├── README.md
├── LICENSE
├── .gitignore
├── evidence/
│   ├── command-history.txt
│   ├── final-output.txt
│   └── README.md
├── docs/
│   ├── linux-command-explanations.md
│   └── evidence-checklist.md
├── scripts/
│   └── lab-commands.sh
└── screenshots/
    └── README.md
```

---

# 🧪 Practical Challenge

After completing the assigned workflow, try to reproduce the final workspace **without looking at the command list**.

Then answer:

1. Why should the file operations be performed as `agent007` rather than root?
2. What does `640` mean in Linux permissions?
3. What happens to a file's ownership when `chown` is used?
4. Why is `ls -la` useful during troubleshooting?
5. What is the difference between deleting a file and copying a backup?
6. What evidence proves that the permission change was successful?

---

# 📚 Skills Demonstrated

This project demonstrates entry-level practical skills in:

- Linux user administration
- Linux filesystem navigation
- File and directory management
- File permissions
- File ownership
- Command-line troubleshooting
- Evidence collection
- Operational documentation
- Basic security principles
- Least-privilege concepts

---

# ⚠️ Safety & Lab Scope

This repository is intended for an **authorized Kali Linux lab environment** and educational portfolio documentation.

Only perform these commands on systems you own or are explicitly authorized to administer.

---

## 📌 Source Assignment

This repository was structured from the supplied practical workflow:

**Practical Task: Secure File Management & User Configuration on Kali Linux**

The source task's objective is to demonstrate fundamental Linux filesystem and user-management commands while setting up a secure workspace for a newly created user. fileciteturn0file0L2-L11

The required workspace, file creation, listing, copy/remove, permissions, recovery, ownership, and submission requirements are preserved from the supplied workflow. fileciteturn0file0L21-L55

---

## 👤 Portfolio Note

For a GitHub portfolio, replace the placeholder evidence files with your **actual terminal screenshots, command history, and final output** from your own Kali Linux lab. This makes the repository demonstrate hands-on work rather than only documentation.
