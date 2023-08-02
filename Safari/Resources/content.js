const hijack = () => {
    const parrotflowWidget = document.getElementById('parrotflowWidget');
    if (!parrotflowWidget) {
        try  {
            
            const isOld = document.getElementById('hdtb-msb');
            if (isOld) {
                throw 'old style';
            }
            
            // Find Bubble
            let bubbleA = null;
            const aS = document.querySelectorAll('a[role="link"]');
            for (const a of aS) {
              const test = a.textContent.trim().length > 0;
              if (test) {
                bubbleA = a;
                break;
              }
            }
            const parent = bubbleA.parentNode;
            
            // Clone
            const clone = parent.cloneNode(true);
            clone.id = "parrotflowWidget"
            
            // Reformat
            const cloneA = clone.querySelector('a');
            cloneA.removeAttribute('jsaction');
            cloneA.href = `parrotflow://?q=${document.URL.split("?q=")[1]}`;
            const cloneSpan = cloneA.querySelector('span');
            if (cloneSpan) {
                cloneSpan.textContent = "Chat";
            } else {
                const cloneDiv = cloneA.querySelector('div');
                cloneDiv.textContent = "Chat";
            }
            
            // Append to DOM
            const container = parent.parentNode;
            container.insertBefore(clone, container.firstChild);
            console.log('added bubble');
        } catch {
            
            // Old Style
            const referenceNode = document.getElementById('hdtb-msb');
            if (referenceNode) {
                const newElement = document.createElement('div');
                newElement.id = "parrotflowWidget";
                newElement.className = "hdtb-mitem";
                const queryParameter = document.URL.split("?q=")[1];
                newElement.innerHTML = `<a href='parrotflow://?q=${queryParameter}'><span>Chat</span></a>`;
                referenceNode.insertBefore(newElement, referenceNode.firstChild);
            }
        }
    }
};

hijack();
