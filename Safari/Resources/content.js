const hijack = () => {
    const gplexWidget = document.getElementById('gplexWidget');
    if (!gplexWidget) {
        try {
            const isOld = document.getElementById('hdtb-msb');
            if (isOld) {
                throw 'old style';
            }
            
            // Find Bubble
            let bubbleA = null;
            let aS = document.querySelectorAll('a[role="link listitem"]');
            if (aS.length <= 0) {
                aS = document.querySelectorAll('a[role="link"]');
            }
            for (const a of aS) {
                const hasText = a.textContent.trim().length > 0
                const test = a.children.length > 0 && hasText;
                if (test) {
                    bubbleA = a;
                    break;
                }
            }
            
            if (bubbleA) {
                const parent = bubbleA.parentNode;
                
                // Clone
                const clone = parent.cloneNode(true);
                clone.id = "gplexWidget";
                
                // Reformat
                let bodyStyle = window.getComputedStyle(document.body);
                let isLightMode = bodyStyle.backgroundColor === 'rgb(255, 255, 255)';
                const cloneA = clone.querySelector('a');
                cloneA.removeAttribute('jsaction');
                
                let query = document.URL.split("?q=")[1];
                cloneA.href = `https://gplexapp.com/search/?q=${query}`;
                
                const cloneSpan = cloneA.querySelector('span');
                const cloneDiv = cloneA.querySelector('div');
                if (cloneSpan) {
                    cloneSpan.style.color = isLightMode ? "#1a73e8" : "#8AB4F8";
                    cloneSpan.textContent = "GENERATE ✨";
                } else {
                    cloneDiv.style.color = isLightMode ? "#1a73e8" : "#8AB4F8";
                    cloneDiv.textContent = "GENERATE ✨";
                }
                
                // Append to DOM
                const container = parent.parentNode;
                container.insertBefore(clone, container.firstChild);
                console.log('added bubble');
            }
        } catch {
            // Old Style
            const referenceNode = document.getElementById('hdtb-msb');
            if (referenceNode) {
                const newElement = document.createElement('div');
                newElement.id = "gplexWidget";
                newElement.className = "hdtb-mitem";
                const query = document.URL.split("?q=")[1];
                newElement.innerHTML = `<a href='https://gplexapp.com/search/?q=${query}'><span>GENERATE ✨</span></a>`;
                referenceNode.insertBefore(newElement, referenceNode.firstChild);
                
                let bodyStyle = window.getComputedStyle(document.body);
                let isLightMode = bodyStyle.backgroundColor === 'rgb(255, 255, 255)';
                const span = newElement.querySelector('span');
                span.style.color = isLightMode ? "#1a73e8" : "#8AB4F8";
            }
        }
    }
};

hijack();
