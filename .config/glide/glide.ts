// https://glide-browser.app/config
// https://glide-browser.app/api
// https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
// https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts

glide.o.hint_size = "12px";

// Keymaps
glide.keymaps.set("normal", "]b", "tab_next");
glide.keymaps.set("normal", "[b", "tab_prev");
glide.keymaps.set("normal", "]h", "forward");
glide.keymaps.set("normal", "[h", "back");

// Ignore certain sites
const ignored_sites = ['mail.google.com', 'linear.app'];
for (const index in ignored_sites) {
  glide.autocmds.create("UrlEnter", {
    hostname: ignored_sites[index],
  }, async () => {
    await glide.excmds.execute("mode_change ignore");
    return () => glide.excmds.execute("mode_change normal");
  });
}

// Picker for bookmarks
glide.keymaps.set("normal", "<leader>b", async () => {
  const bookmarks = await browser.bookmarks.getRecent(10);

  glide.commandline.show({
    title: "bookmarks",
    options: bookmarks.map((bookmark) => ({
      label: bookmark.title,
      async execute() {
        const tab = await glide.tabs.get_first({
          url: bookmark.url,
        });
        if (tab) {
          await browser.tabs.update(tab.id, {
            active: true,
          });
        } else {
          await browser.tabs.create({
            active: true,
            url: bookmark.url,
          });
        }
      },
    })),
  });
}, { description: "Open the bookmarks picker" });

// Split views

glide.keymaps.set(
  "normal",
  "<C-w>v",
  async ({ tab_id }) => {
    const all_tabs = await glide.tabs.query({});
    const current_index = all_tabs.findIndex((t) =>
      t.id === tab_id
    );
    const other = all_tabs[current_index + 1];
    if (!other) {
      throw new Error("No next tab");
    }
    glide.unstable.split_views.create([tab_id, other]);
  },
  {
    description:
      "Create a split view with the tab to the right",
  },
);

glide.keymaps.set(
  "normal",
  "<C-w>q",
  async ({ tab_id }) => {
    glide.unstable.split_views.separate(tab_id);
  },
  {
    description: "Close the split view for the current tab",
  },
);

