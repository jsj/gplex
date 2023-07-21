
chrome.runtime.onInstalled.addListener(async () => {
    chrome.contextMenus.create({
    id: "chat",
    title: "Chat with Parrotflow",
    type: 'normal',
    contexts: ['selection']
    });
});

chrome.contextMenus.onClicked.addListener((item, tab) => {
  const url = new URL(`https://chat.parrotflow.com/`);
  url.searchParams.set('p', item.selectionText);
  chrome.tabs.create({ url: url.href, index: tab.index + 1 });
});

chrome.action.onClicked.addListener(async () => {
    chrome.tabs.create({ url: "http://chat.parrotflow.com" });
});
