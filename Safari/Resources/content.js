hijack = () => {
    var referenceNode = document.getElementById('hdtb-msb');
    if (!document.getElementById('parrotflowWidget')) {
        var newElement = document.createElement('div');
        newElement.id = "parrotflowWidget"
        newElement.className = "hdtb-mitem";
        const urlComponents = document.URL.split("?q=");
        if (urlComponents.length > 1) {
            const queryParamater = decodeURIComponent(urlComponents[1]);
            newElement.innerHTML = `<a href='parrotflow://?q=${queryParamater}'><span>Chat</span><a>`;
        }
    }
    referenceNode.insertBefore(newElement, referenceNode.firstChild);
}

hijack()

