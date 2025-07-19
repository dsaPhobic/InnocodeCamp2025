<%@ page import="java.util.List" %>
<%@ page import="model.Message" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<Message> chatHistory = (List<Message>) session.getAttribute("chatHistory");
    if (chatHistory == null) {
        chatHistory = new java.util.ArrayList<>();
    }
%>
<style>
    .chat1-fade-in {
        animation: chat1-fade-in 0.7s cubic-bezier(.4,2,.3,1) both;
    }
    @keyframes chat1-fade-in {
        from {
            opacity: 0;
            transform: translateY(40px) scale(0.95);
        }
        to {
            opacity: 1;
            transform: none;
        }
    }
    .chat1-bubble-fade {
        animation: chat1-bubble-fade 0.7s cubic-bezier(.4,2,.3,1) both;
    }
    @keyframes chat1-bubble-fade {
        from {
            opacity: 0;
            transform: scale(0.7);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }
    .chat1-body {
        margin: 0;
        padding: 0;
    }
    #chat1-bubble {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 64px;
        height: 64px;
        background: #4a90e2;
        border-radius: 50%;
        box-shadow: 0 4px 16px rgba(0,0,0,0.18);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 1001;
        transition: box-shadow 0.2s;
    }
    #chat1-bubble:hover {
        box-shadow: 0 8px 32px rgba(44,62,80,0.22);
    }
    #chat1-chatbox {
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 360px;
        height: 470px;
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.18);
        display: none;
        flex-direction: column;
        font-family: Arial, sans-serif;
        z-index: 1002;
        opacity: 0;
        transform: scale(0.95);
        transition: opacity 0.35s cubic-bezier(.4,2,.6,1), transform 0.35s cubic-bezier(.4,2,.6,1);
    }
    #chat1-chatbox.open {
        display: flex;
        opacity: 1;
        transform: scale(1);
    }
    #chat1-chatbox.closing {
        opacity: 0;
        transform: scale(0.95);
        transition: opacity 0.25s cubic-bezier(.4,2,.6,1), transform 0.25s cubic-bezier(.4,2,.6,1);
    }
    #chat1-chatbox-header {
        background: #4a90e2;
        color: #fff;
        padding: 12px;
        border-radius: 12px 12px 0 0;
        font-size: 18px;
        font-weight: bold;
        position: relative;
    }
    #chat1-chatbox-close {
        position: absolute;
        right: 12px;
        top: 10px;
        background: none;
        border: none;
        color: #fff;
        font-size: 22px;
        cursor: pointer;
    }
    #chat1-chatbox-messages {
        flex: 1;
        padding: 12px;
        overflow-y: auto;
        background: #f7f7f7;
        display: flex;
        flex-direction: column;
    }
    #chat1-chatbox-messages ul {
        list-style: none;
        padding: 0;
        margin: 0;
        display: flex;
        flex-direction: column;
    }
    #chat1-chatbox-messages li {
        margin-bottom: 10px;
        padding: 10px 16px;
        border-radius: 18px;
        max-width: 75%;
        word-break: break-word;
        font-size: 15px;
        animation: chat1-fade-in 0.35s ease;
    }
    #chat1-chatbox-messages li.user {
        background: #e1f5fe;
        align-self: flex-end;
        text-align: right;
    }
    #chat1-chatbox-messages li.assistant {
        background: #e8eaf6;
        align-self: flex-start;
        text-align: left;
    }
    #chat1-chatbox-loading {
        text-align: center;
        color: #aaa;
        font-size: 13px;
        margin: 10px 0;
        animation: chat1-thinking-pulse 1.2s infinite;
    }
    @keyframes chat1-thinking-pulse {
        0%, 100% {
            opacity: 0.5;
        }
        50% {
            opacity: 1;
        }
    }
    #chat1-chatbox-form {
        display: flex;
        padding: 10px;
        border-top: 1px solid #eee;
        background: #fafafa;
    }
    #chat1-chatbox-form input[type="text"] {
        flex: 1;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 15px;
    }
    #chat1-chatbox-form button {
        margin-left: 8px;
        padding: 8px 16px;
        background: #4a90e2;
        color: #fff;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        cursor: pointer;
        transition: background 0.2s, transform 0.2s;
    }
    #chat1-chatbox-form button:hover {
        background: #2563eb;
        transform: scale(1.07);
    }
    #chat1-chatbox-footer {
        text-align: center;
        padding: 6px;
        font-size: 12px;
        color: #aaa;
    }
    .chat1-pre-question-btn {
        margin: 4px 6px;
        padding: 7px 16px;
        background: #e1f5fe;
        border: 1px solid #4a90e2;
        border-radius: 8px;
        color: #333;
        font-size: 15px;
        cursor: pointer;
        transition: background 0.2s, transform 0.2s;
    }
    .chat1-pre-question-btn:hover {
        background: #b3e5fc;
        transform: scale(1.08);
    }
    @media (max-width: 600px) {
        #chat1-chatbox {
            width: 98vw;
            right: 1vw;
            height: 70vh;
            min-width: 0;
        }
        #chat1-bubble {
            right: 10px;
            bottom: 10px;
        }
    }
</style>
<div id="chat1-bubble" class="chat1-bubble-fade" onclick="chat1ShowChatBox()" title="Open chat">
    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="white" viewBox="0 0 24 24">
        <path d="M20 2H4C2.897 2 2 2.897 2 4v16l4-4h14c1.103 0 2-.897 2-2V4C22 2.897 21.103 2 20 2z"/>
    </svg>
</div>
<div id="chat1-chatbox" class="chat1-fade-in">
    <div id="chat1-chatbox-header">
        Career Chatbot <span style="font-size:13px;font-weight:400;opacity:0.8;">(Chuyên về nghề nghiệp IT)</span>
        <button id="chat1-chatbox-close" onclick="chat1HideChatBox()" title="Close chat">&times;</button>
    </div>

    <div id="chat1-chatbox-messages">
        <% if (chatHistory.isEmpty()) { %>
        <div id="chat1-pre-questions" style="padding:12px;text-align:center;">
            <div style="margin-bottom:8px;font-weight:bold;">Thử hỏi về nghề nghiệp IT:</div>
            <button class="chat1-pre-question-btn" onclick="chat1SendPreQuestion('Các kỹ năng cần thiết để trở thành lập trình viên backend là gì?')">Kỹ năng backend?</button>
            <button class="chat1-pre-question-btn" onclick="chat1SendPreQuestion('Lộ trình học front-end developer?')">Lộ trình front-end?</button>
            <button class="chat1-pre-question-btn" onclick="chat1SendPreQuestion('Ngành IT lương bao nhiêu?')">Lương ngành IT?</button>
            <button class="chat1-pre-question-btn" onclick="chat1SendPreQuestion('Cách viết CV xin việc IT?')">Cách viết CV IT?</button>

        </div>
        <% } %>
        <ul id="chat1-chatbox-list">
            <% for (Message msg : chatHistory) {
                    if ("user".equals(msg.getRole()) && msg.getBase64Image() != null) { %>
            <li style="text-align:right;color:#444;font-style:italic;margin-bottom:-4px;border:1px dashed #4a90e2;padding:4px 10px;border-radius:10px;background:#f0f8ff;display:inline-block;align-self:flex-end;max-width:75%;animation:chat1-fade-in 0.35s ease;">* image</li>
                <% }%>
            <li class="<%= msg.getRole()%>"><b><%= msg.getRole()%>:</b> <span class="markdown-body" data-raw="<%= msg.getText().replace("\"", "&quot;").replace("'", "&#39;")%>"></span></li>
                <% }%>
        </ul>
    </div>
    <form id="chat1-chatbox-form">
        <input type="text" name="message" placeholder="Hỏi về nghề IT, lập trình, kỹ năng, lương..." />
        <input type="hidden" name="fromPage" value="chat1.jsp" />
        <input type="hidden" name="careerContext" value="it-career" />
        <button type="submit">Send</button>
    </form>
    <div id="chat1-nav" style="text-align:center;margin:18px 0 0 0;">
        <a href="chat2.jsp" style="color:#4a90e2;text-decoration:none;font-size:15px;">Go to Chat 2</a>
    </div>
    <div id="chat1-chatbox-footer">&copy; Cursor Chat</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<script>
                function chat1ShowChatBox() {
                    const chatbox = document.getElementById('chat1-chatbox');
                    chatbox.classList.remove('closing');
                    chatbox.style.display = 'flex';
                    void chatbox.offsetWidth;
                    chatbox.classList.add('open');
                    document.getElementById('chat1-bubble').style.display = 'none';
                    chat1ScrollToBottom();
                }
                function chat1HideChatBox() {
                    const chatbox = document.getElementById('chat1-chatbox');
                    chatbox.classList.remove('open');
                    chatbox.classList.add('closing');
                    setTimeout(() => {
                        chatbox.style.display = 'none';
                        chatbox.classList.remove('closing');
                    }, 250);
                    document.getElementById('chat1-bubble').style.display = 'flex';
                }
                function chat1ScrollToBottom() {
                    const container = document.getElementById('chat1-chatbox-messages');
                    container.scrollTop = container.scrollHeight;
                }
                function chat1SetLoading(loading) {
                    let loader = document.getElementById('chat1-chatbox-loading');
                    if (!loader) {
                        loader = document.createElement('div');
                        loader.id = 'chat1-chatbox-loading';
                        loader.innerText = 'Thinking...';
                        document.getElementById('chat1-chatbox-messages').appendChild(loader);
                    }
                    loader.style.display = loading ? 'block' : 'none';
                }
                function chat1RenderMessages(messages) {
                    const ul = document.getElementById('chat1-chatbox-list');
                    ul.innerHTML = '';
                    messages.forEach(msg => {
                        if (msg.role === 'user' && msg.base64Image) {
                            const line = document.createElement('li');
                            line.innerText = '* image';
                            line.style = 'text-align:right;color:#444;font-style:italic;margin-bottom:-4px;border:1px dashed #4a90e2;padding:4px 10px;border-radius:10px;background:#f0f8ff;display:inline-block;align-self:flex-end;max-width:75%;animation:chat1-fade-in 0.35s ease;';
                            ul.appendChild(line);
                        }
                        const li = document.createElement('li');
                        li.className = msg.role;
                        li.innerHTML = '<b>' + msg.role + ':</b> <span class="markdown-body">' + (msg.text ? marked.parse(msg.text) : '') + '</span>';
                        ul.appendChild(li);
                    });
                    chat1ScrollToBottom();
                }
                function chat1SendMessageAjax(e) {
                    e.preventDefault();
                    const input = document.querySelector('#chat1-chatbox-form input[name="message"]');
                    const message = input.value.trim();
                    if (!message)
                        return;
                    const ul = document.getElementById('chat1-chatbox-list');
                    const li = document.createElement('li');
                    li.className = 'user';
                    li.innerHTML = '<b>user:</b> ' + message;
                    ul.appendChild(li);
                    chat1ScrollToBottom();
                    const formData = new FormData();
                    formData.append("message", message);
                    formData.append("fromPage", "chat1.jsp");
                    formData.append("ajax", "1");
                    formData.append("careerContext", "it-career");
                    input.value = '';
                    input.focus();
                    chat1SetLoading(true);
                    fetch('chat', {
                        method: 'POST',
                        body: formData
                    })
                            .then(res => res.json())
                            .then(data => {
                                chat1SetLoading(false);
                                if (data && data.chatHistory) {
                                    chat1RenderMessages(data.chatHistory);
                                }
                            })
                            .catch(() => {
                                chat1SetLoading(false);
                                alert("Error sending message.");
                            });
                }
                function chat1SendPreQuestion(text) {
                    const input = document.querySelector('#chat1-chatbox-form input[name="message"]');
                    input.value = text;
                    document.getElementById('chat1-chatbox-form').dispatchEvent(new Event('submit', {cancelable: true, bubbles: true}));
                }
                document.getElementById('chat1-chatbox-form').addEventListener('submit', chat1SendMessageAjax);
                window.addEventListener("DOMContentLoaded", () => {
                    document.querySelectorAll('.markdown-body').forEach(el => {
                        const raw = el.getAttribute('data-raw');
                        el.innerHTML = marked.parse(raw);
                    });
                    chat1ScrollToBottom();
                });
</script>
