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
glide.keymaps.set("normal", "<leader>cr", "config_reload");
glide.keymaps.set("normal", "<D-t", "tab_new");
glide.keymaps.set("normal", "<D-s>", () => {
  glide.o.native_tabs = glide.o.native_tabs === "show" ? "hide" : "show";
});

glide.autocmds.create("UrlEnter", {
  hostname: "mail.google.com",
}, async () => {
  glide.buf.keymaps.del("normal", "e");
});

// Picker for bookmarks
glide.keymaps.set("normal", "<leader>b", async () => {
  const bookmarks = await browser.bookmarks.getRecent(100);

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

// split view: create
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

// split view: close
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

// custom search engines
const searchEnginesList = [
  { keywords: ["ddg", "dd", "duck"], url: "https://duckduckgo.com/?q={searchTerms}", name: "DuckDuckGo", is_default: true },
  { keywords: ["g", "google"], url: "https://www.google.com/search?q={searchTerms}", name: "Google", suggest_url: "https://suggestqueries.google.com/complete/search?client=firefox&q={searchTerms}" },
  { keywords: ["gi"], url: "https://www.google.com/search?udm=2&q={searchTerms}", name: "Google Images", suggest_url: "https://suggestqueries.google.com/complete/search?client=firefox&q={searchTerms}" },
  { keywords: ["y", "yt", "youtube"], url: "https://www.youtube.com/results?search_query={searchTerms}", name: "YouTube" },
  { keywords: ["w", "wiki", "wikipedia"], url: "https://ru.wikipedia.org/wiki/Special:Search?search={searchTerms}", name: "Wikipedia" },
  { keywords: ["gh", "github"], url: "https://github.com/search?q={searchTerms}", name: "GitHub" },
  { keywords: ["ghp", "github:prefect"], url: "https://github.com/prefecthq/?q={searchTerms}", name: "GitHub.com/PrefectHQ" },
];
for (const engine of searchEnginesList) {
  for (const keyword of engine.keywords) {
    glide.search_engines.add({
      name: `${keyword} [${engine.name}]`, keyword: keyword, search_url: engine.url, is_default: engine.is_default,
      suggest_url: engine.suggest_url ?? "https://ac.duckduckgo.com/ac/?q={searchTerms}&type=list"
    });
  }
}
