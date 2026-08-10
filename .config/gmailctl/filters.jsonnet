local github = { from: 'notifications@github.com' };
local reason(name) = { cc: name + '@noreply.github.com' };
local archive = {
  archive: true,
  markRead: true,
};

{
  version: 'v1alpha3',
  rules: [
    // Automated security reports do not require inbox triage.
    {
      filter: {
        and: [
          { from: 'security-notifications@prefect.io' },
          {
            or: [
              { subject: 'Sysdig Scanning Report - New Workloads:' },
              { subject: 'Sysdig Scanning Report - New Hosts:' },
              { subject: 'SentinelOne - New Suspicious threat detected' },
            ],
          },
        ],
      },
      actions: archive,
    },
    // Ignore all GitHub activity performed by these automation bots. Gmail's
    // from operator matches the display name in GitHub's From header.
    {
      filter: {
        or: [
          { from: 'vercel[bot]' },
          { from: 'github-actions[bot]' },
        ],
      },
      actions: archive,
    },
    // Ignore short-lived release automation PRs opened and merged by the
    // Prefect CI bot. This intentionally ignores comments on those PRs too.
    {
      filter: {
        and: [
          github,
          { subject: '[PrefectHQ/platform] nebula-' },
        ],
      },
      actions: archive,
    },
    // Ignore automated dependency rollout PRs across Prefect repositories.
    // This intentionally ignores comments on those PRs too.
    {
      filter: {
        and: [
          github,
          { subject: 'dependency-version-' },
        ],
      },
      actions: archive,
    },
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
      name: 'archive Sysdig new workload scanning reports',
      messages: [{
        from: 'security-notifications@prefect.io',
        subject: 'Sysdig Scanning Report - New Workloads: Daily High+ CVEs (cloud2) report available',
      }],
      actions: archive,
    },
    {
      name: 'archive Sysdig new host scanning reports',
      messages: [{
        from: 'security-notifications@prefect.io',
        subject: 'Sysdig Scanning Report - New Hosts: Daily High+ CVEs (cloud2) report available',
      }],
      actions: archive,
    },
    {
      name: 'archive SentinelOne suspicious threat notifications',
      messages: [{
        from: 'security-notifications@prefect.io',
        subject: "SentinelOne - New Suspicious threat detected - machine trent's Apple MacBook Pro",
      }],
      actions: archive,
    },
    {
      name: 'keep other security notifications',
      messages: [{
        from: 'security-notifications@prefect.io',
        subject: 'Action required: security incident update',
      }],
      actions: {},
    },
    {
      name: 'archive activity from Vercel bot',
      messages: [{
        from: 'vercel[bot]',
        subject: 'Preview deployment completed',
      }],
      actions: archive,
    },
    {
      name: 'archive activity from GitHub Actions bot',
      messages: [{
        from: 'github-actions[bot]',
        subject: 'Update dependency versions',
      }],
      actions: archive,
    },
    {
      name: 'keep activity from other bots',
      messages: [{
        from: 'codecov[bot]',
        subject: 'Coverage report',
      }],
      actions: {},
    },
    {
      name: 'archive a Prefect release automation PR',
      messages: [{
        from: 'notifications@github.com',
        subject: '[PrefectHQ/platform] nebula-7167fad (PR #12043)',
      }],
      actions: archive,
    },
    {
      name: 'archive an automated dependency rollout PR',
      messages: [{
        from: 'notifications@github.com',
        subject: 'Re: [PrefectHQ/cluster-deployment] dependency-version-minor-2026-07-30 (PR #539)',
      }],
      actions: archive,
    },
    {
      name: 'keep other PRs in PrefectHQ/platform',
      messages: [{
        from: 'notifications@github.com',
        subject: '[PrefectHQ/platform] Improve API reliability (PR #12044)',
      }],
      actions: {},
    },
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
