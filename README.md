

# 🎓 FYP Hub

**FYP Hub** is a mobile platform designed to streamline the most chaotic part of a Final Year Project: **the beginning.** Unlike complex project management tools, FYP Hub focuses on **connections and approvals**. It provides a structured marketplace for students to form teams, find supervisors, and transition from an "idea" to an "officially approved project."

---

## 🚀 Key Features

### 1. The Marketplace

* **Project Ideas Feed:** Browse and join existing project concepts.
* **Find Teammates:** Search for students based on specific skills (Flutter, Python, UI/UX, etc.).
* **Browse Supervisors:** View faculty profiles, research interests, and real-time availability.

### 2. The Request & Inbox System

* **Teammate Requests:** Send and accept invitations to form a project group.
* **Supervisor Requests:** Propose meetings based on a supervisor's listed availability.
* **Real-time Inbox:** Centralized hub for all incoming and outgoing connection requests.

### 3. The "Approval Gate" (Core Logic)

The app uses a unique "Unlock" mechanic:

* A student cannot "Create a Project" until a Supervisor clicks **Approve & Supervise** in the app.
* This action updates the student's status in the database, unlocking the Project Creation suite.

### 4. Milestone Tracker

Once a project is live, the app provides a simplified tracker:

* **Supervisors:** Create deadlines and update status (Pending, Submitted, Approved).
* **Students:** View real-time progress and upcoming deadlines.

---

## 🛠️ Tech Stack

* **Frontend:** [Flutter](https://flutter.dev/) (Dart)
* **Backend/Auth:** [Firebase Authentication](https://firebase.google.com/docs/auth)
* **Database:** [Cloud Firestore](https://firebase.google.com/docs/firestore) (NoSQL)
* **Architecture:** Model-View-Controller (MVC) with clean Data Models.

---

## 📂 Database Schema (Firestore)

The project follows a "Single-Collection" user strategy for maximum performance:

* **`users`**: Stores both Students and Supervisors using a `role` field.
* **`marketplacePosts`**: Stores "Project Idea" and "Find Teammate" posts.
* **`requests`**: Manages the state of all connection attempts (`pending`, `accepted`, `declined`).
* **`projects`**: Stores officially approved project details and team links.
* **`milestones`**: A sub-collection within each project for tracking deadlines.

---

## 🏁 Getting Started

1. **Clone the repo:**
```bash
git clone https://github.com/BinaryVibe/fyp-hub.git

```


2. **Install dependencies:**
```bash
flutter pub get

```


3. **Setup Firebase:**
* Create a Firebase project.
* Add your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).
* Enable Email/Password Auth and Firestore.


4. **Run the app:**
```bash
flutter run

```



---
