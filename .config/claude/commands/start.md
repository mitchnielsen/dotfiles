Starts work on a new feature branch for a Linear or Github issue.

Issue: #$ARGUMENTS

If the issue here looks like "ABC-123", it is likely a Linear issue ID, so
you can look it up using the `linear` MCP tools. If the argument here looks
like #123, it is likely a Github issue ID, so you can look it up using the `gh`
CLI tool.  Otherwise, if it's just a bunch of words, it's an idea I want
to try out and will just be specified as English, in which case it is
not tied to an issue tracker.

First, read the issue from the issue tracker, and follow any other links or
references provided in the issue description to understand what it's about.

Then, create a comprehensive plan for implementing or fixing the issue,
including how you're going to test it. Use planning mode if possible. Testing
should be the first priority in most repositories. If you're unsure about how
to test something, ask me for clarification. Some repositories don't have any
unit test suites, or the test suites they have aren't runnable locally, and that
is okay.

Then, present the plan to me and wait for my approval before proceeding with the
implementation. After I've approved, please proceed with the implementation
unattended and autonomously. If there are relevant tests, write them first and
then use them to guide your work. Don't stop and declare victory until the tests
are passing.
