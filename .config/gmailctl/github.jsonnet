local github = { from: 'notifications@github.com' };
local reason(name) = { cc: name + '@noreply.github.com' };
local archive = {
  archive: true,
  markRead: true,
};

{
  version: 'v1alpha3',
  rules: [
    // SwiftBar tracks outstanding reviews. Archive only the initial request
    // email so later comments on the PR still reach the inbox.
    {
      filter: {
        and: [
          github,
          reason('review_requested'),
          { has: 'requested your review on' },
        ],
      },
      actions: archive,
    },
    // CI results are available on the PR and do not require inbox triage.
    {
      filter: {
        and: [
          github,
          reason('ci_activity'),
        ],
      },
      actions: archive,
    },
    // Ignore lifecycle events such as merges, closures, and reopenings.
    {
      filter: {
        and: [
          github,
          reason('state_change'),
        ],
      },
      actions: archive,
    },
    // Ignore newly opened PRs received because a repository is watched.
    // Subsequent comments do not contain this phrase and remain in the inbox.
    {
      filter: {
        and: [
          github,
          reason('subscribed'),
          { has: 'wants to merge' },
        ],
      },
      actions: archive,
    },
  ],
  tests: [
    {
      name: 'archive a direct review request',
      messages: [{
        from: 'notifications@github.com',
        cc: ['review_requested@noreply.github.com'],
        body: 'alice requested your review on org/repo#123.',
      }],
      actions: archive,
    },
    {
      name: 'keep a comment while review is requested',
      messages: [{
        from: 'notifications@github.com',
        cc: ['review_requested@noreply.github.com'],
        body: 'alice commented on this pull request.',
      }],
      actions: {},
    },
    {
      name: 'archive CI activity',
      messages: [{
        from: 'notifications@github.com',
        cc: ['ci_activity@noreply.github.com'],
        body: 'Web tests failed.',
      }],
      actions: archive,
    },
    {
      name: 'archive a PR state change',
      messages: [{
        from: 'notifications@github.com',
        cc: ['state_change@noreply.github.com'],
        body: 'alice merged one commit into main.',
      }],
      actions: archive,
    },
    {
      name: 'archive a newly opened watched PR',
      messages: [{
        from: 'notifications@github.com',
        cc: ['subscribed@noreply.github.com'],
        body: 'alice wants to merge two commits into main from feature.',
      }],
      actions: archive,
    },
    {
      name: 'keep a comment on a watched PR',
      messages: [{
        from: 'notifications@github.com',
        cc: ['subscribed@noreply.github.com'],
        body: 'alice commented on this pull request.',
      }],
      actions: {},
    },
  ],
}
