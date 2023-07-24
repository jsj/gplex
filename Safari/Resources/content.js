const hijack = () => {
    const referenceNode = document.getElementById('hdtb-msb');
    if (referenceNode) {
        if (!document.getElementById('parrotflowWidget')) {
            const newElement = document.createElement('div');
            newElement.id = "parrotflowWidget";
            newElement.className = "hdtb-mitem";
            const urlComponents = document.URL.split("?q=");
            if (urlComponents.length > 1) {
                const queryParameter = urlComponents[1];
                newElement.innerHTML = `<a href='parrotflow://?q=${queryParameter}'><span>Chat</span></a>`;
            }
            referenceNode.insertBefore(newElement, referenceNode.firstChild);
        }
    } else {
        if (!document.getElementById('parrotflowWidget')) {
            const firstBubbleElement = document.querySelector('div[role="listitem"]');
            if (firstBubbleElement) {
                const urlComponents = document.URL.split("?q=");
                if (urlComponents.length > 1) {
                    const queryParameter = urlComponents[1];
                    const parentNode = firstBubbleElement.parentNode;
                    const clonedElement = firstBubbleElement.cloneNode(true);
                    clonedElement.id = "parrotflowWidget";
                    const aTag = clonedElement.firstChild;
                    aTag.removeAttribute('jsaction');
                    aTag.href = `parrotflow://?q=${queryParameter}`;
                    const span = aTag.querySelector('span');
                    span.textContent = "Chat";
                    parentNode.insertBefore(clonedElement, parentNode.firstChild);
                }
            }
        }
    }
};

hijack();
