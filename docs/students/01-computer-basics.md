# Lesson 1: Computer Basics

**Time:** 30 minutes

**Goal:** Learn six basic computer words by creating, saving, closing, and
reopening a text file.

**Materials:** A Windows or macOS computer. No developer tools or project folder
are required.

## Lesson Plan

| Time | Activity |
| ---: | --- |
| 0–3 min | Why developers need these words |
| 3–10 min | Six computer basics |
| 10–20 min | Create and reopen a `.txt` file |
| 20–25 min | Exercise: identify each concept |
| 25–30 min | Partner explanation and exit checkpoint |

## What You Will Learn

By the end, you should be able to:

- Explain operating system, application, process, file, folder, and path.
- Create and save a plain-text file.
- Locate and reopen the saved file.
- Use the six words to explain what happened.

![Map connecting the operating system, applications, processes, files, folders, paths, and the computer interface](../images/computer_basics_map.svg)

## Six Computer Basics — 7 Minutes

| Word | Meaning | Today's example |
| --- | --- | --- |
| **Operating system (OS)** | The main software that manages the computer | Windows or macOS |
| **Application (app)** | A program used to do work | Notepad or TextEdit |
| **Process** | An application that is currently running | Notepad or TextEdit running now |
| **File** | A named piece of stored information | `my-first-file.txt` |
| **Folder** | A container that organizes files and folders | `Documents` |
| **Path** | The address of a file or folder | `Documents/my-first-file.txt` |

The `.txt` ending is called a **file extension**. It tells people and the
operating system that the file contains plain text.

Two distinctions matter:

- A **folder** contains the file; a **path** tells you how to find the file.
- An **application** can be stored on the computer even when it is closed. A
  **process** exists while that application is running.

## Activity: Create and Reopen a Text File — 10 Minutes

Choose the instructions for your operating system.

### Windows: Use Notepad

1. Open the **Start** menu.
2. Search for `Notepad` and open it.
3. Type:

   ```text
   This is my first text file.
   ```

4. Select **File → Save As**.
5. Select the **Documents** folder.
6. Enter `my-first-file.txt` as the filename.
7. Select **Save**.
8. Close Notepad.
9. Open **File Explorer**, then open **Documents**.
10. Find `my-first-file.txt` and double-click it.

Notepad should start again and display the sentence you saved.

> If Windows displays only `my-first-file`, the `.txt` extension may be hidden.
> The file is still a text file. Your teacher can enable **View → Show → File
> name extensions** in File Explorer when appropriate.

### macOS: Use TextEdit

1. Open **Spotlight Search** with **Command+Space**.
2. Search for `TextEdit` and open it.
3. Select **New Document** if a document does not open automatically.
4. Select **Format → Make Plain Text**. This is important because TextEdit can
   also create rich-text files.
5. Type:

   ```text
   This is my first text file.
   ```

6. Select **File → Save**.
7. Enter `my-first-file.txt` in the **Save As** field.
8. Choose the **Documents** folder and select **Save**.
9. If TextEdit asks whether to use `.txt`, choose **Use .txt**.
10. Quit TextEdit with **TextEdit → Quit TextEdit**.
11. Open **Finder**, then open **Documents**.
12. Find `my-first-file.txt` and double-click it.

TextEdit should start again and display the sentence you saved.

## Exercise: Explain What Happened — 5 Minutes

Complete the table with a partner:

| Question | Your answer |
| --- | --- |
| Which operating system did you use? |  |
| Which application created the file? |  |
| When was that application a process? |  |
| What is the complete filename? |  |
| Which folder contains the file? |  |
| What is the path from Documents to the file? |  |
| What does the `.txt` extension represent? |  |

<details>
<summary>Show sample answers</summary>

- Operating system: Windows or macOS.
- Application: Notepad or TextEdit.
- Process: while Notepad or TextEdit was open and running.
- Filename: `my-first-file.txt`.
- Folder: `Documents`.
- Path from Documents: `Documents/my-first-file.txt`.
- `.txt`: a plain-text file.

</details>

## Exit Checkpoint — 5 Minutes

Close the text editor and explain this story to a partner:

> I used an application to create a file. While the application was running, it
> was a process. I saved the file in a folder. Its path tells me where to find
> it. My operating system helped manage all of these parts.

Then demonstrate that you can:

- Find `my-first-file.txt` in Documents.
- Identify its filename and `.txt` extension.
- Open it and see the saved sentence.
- Quit the application when finished.

If you finish early, use the
[Computer Basics Extra Practice](reference/computer-basics-extra-practice.md).

## Think Like an HCI Designer

Notepad, TextEdit, File Explorer, and Finder are interfaces. Labels, folder
icons, selection highlights, and file extensions help represent what the
computer contains and what it is doing.

## What Comes Next

Continue to [Lesson 2: Terminal and Development Tools](02-terminal-and-development-tools.md).
