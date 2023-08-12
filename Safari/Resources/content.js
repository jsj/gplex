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
            let aS = document.querySelectorAll('a[role="link listitem"]');
            if (!aS.length > 0) {
                aS = document.querySelectorAll('a[role="link"]');
            }
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
            let bodyStyle = window.getComputedStyle(document.body);
            let isLightMode = bodyStyle.backgroundColor === 'rgb(255, 255, 255)';
            const cloneA = clone.querySelector('a');
            cloneA.removeAttribute('jsaction');
            
            let query = document.URL.split("?q=")[1];
            cloneA.href = `https://gplexapp.com/search/?q=${query}`;
            
            //cloneA.href = `parrotflow://?q=`;
            const cloneSpan = cloneA.querySelector('span');
            if (cloneSpan) {
                cloneSpan.style.color = isLightMode ? "#1a73e8" : "#8AB4F8";
                cloneSpan.textContent = "GENERATE ✨";
            } else {
                cloneDiv.style.color = isLightMode ? "#1a73e8" : "#8AB4F8";
                const cloneDiv = cloneA.querySelector('div');
                cloneDiv.textContent = "GENERATE ✨";
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
                
                let bodyStyle = window.getComputedStyle(document.body);
                let isLightMode = bodyStyle.backgroundColor === 'rgb(255, 255, 255)';
                const span = newElement.querySelector('span');
                span.style.color = isLightMode ? "#1a73e8" : "#8AB4F8";
            }
        }
    }
};

hijack();
