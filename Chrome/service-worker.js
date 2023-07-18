chrome.action.onClicked.addListener(async () => {
    chrome.tabs.create({ url: "http://chat.parrotflow.com" });
});
