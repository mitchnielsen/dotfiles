# Firefox

Here are the customizations I make to the Firefox browser.

## Tree Style Tabs

The [Tree Style Tabs extension](https://addons.mozilla.org/en-US/firefox/addon/tree-style-tab/)
provides a tab tree in the browser, which helps maintain the context of links followed and makes
it easier to separate tabs by project or idea.

There are a couple customizations to make this look nicer in Firefox.

1. Set up the userChrome using [this guide](https://www.userchrome.org/how-create-userchrome-css.html).
1. Add the CSS to the `userChrome.css` file per [these docs](https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#for-userchromecss):

    ```css
    /* Hide header at top of sidebar */
    #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
      display: none;
    }

    /* Hide the tab bar at the top when the sidebar is open */
    /* Only works in Firefox if layout.css.has-selector.enabled is set to true in about:config . */
    html#main-window body:has(#sidebar-box[sidebarcommand=treestyletab_piro_sakura_ne_jp-sidebar-action][checked=true]:not([hidden=true])) #TabsToolbar {
      visibility: collapse !important;
    }
    ```

## UI tweaks

There are some UI tweaks that generally make Firefox look nicer. There are many documented in
[userchrome.org: styling Proton UI](https://www.userchrome.org/firefox-89-styling-proton-ui.html).

In `about:config`:

- Compact mode: `browser.uidensity` = `1`
