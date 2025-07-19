<%@ page import="java.util.List" %>
<%@ page import="model.Message" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    List<Message> chatHistory = (List<Message>) session.getAttribute("chatHistory");
    if (chatHistory == null) {
        chatHistory = new java.util.ArrayList<>();
    }
%>
<div class="chat1-wrapper">
    <style>
        .chat1-wrapper {
            /* Scope all chat styles to this wrapper */
        }

        .chat1-wrapper #chat-bubble {
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
        .chat1-wrapper #chat-bubble:hover {
            box-shadow: 0 8px 32px rgba(44,62,80,0.22);
        }

        .chat1-wrapper #chatbox {
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
        .chat1-wrapper #chatbox.open {
            display: flex;
            opacity: 1;
            transform: scale(1);
        }
        .chat1-wrapper #chatbox.closing {
            opacity: 0;
            transform: scale(0.95);
            transition: opacity 0.25s cubic-bezier(.4,2,.6,1), transform 0.25s cubic-bezier(.4,2,.6,1);
        }

        .chat1-wrapper #chatbox-header {
            background: #4a90e2;
            color: #fff;
            padding: 12px;
            border-radius: 12px 12px 0 0;
            font-size: 18px;
            font-weight: bold;
            position: relative;
        }

        .chat1-wrapper #chatbox-close {
            position: absolute;
            right: 12px;
            top: 10px;
            background: none;
            border: none;
            color: #fff;
            font-size: 22px;
            cursor: pointer;
        }

        .chat1-wrapper #chatbox-messages {
            flex: 1;
            padding: 12px;
            overflow-y: auto;
            background: #f7f7f7;
            display: flex;
            flex-direction: column;
        }

        .chat1-wrapper #chatbox-messages ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
        }

        .chat1-wrapper #chatbox-messages li {
            margin-bottom: 10px;
            padding: 10px 16px;
            border-radius: 18px;
            max-width: 75%;
            word-break: break-word;
            font-size: 15px;
            animation: chat-fade-in 0.35s ease;
        }

        .chat1-wrapper #chatbox-messages li.user {
            background: #e1f5fe;
            align-self: flex-end;
            text-align: right;
        }

        .chat1-wrapper #chatbox-messages li.assistant {
            background: #e8eaf6;
            align-self: flex-start;
            text-align: left;
        }

        @keyframes chat-fade-in {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .chat1-wrapper #chatbox-loading {
            text-align: center;
            color: #aaa;
            font-size: 13px;
            margin: 10px 0;
            animation: thinking-pulse 1.2s infinite;
        }

        @keyframes thinking-pulse {
            0% {
                opacity: 0.5;
            }
            50% {
                opacity: 1;
            }
            100% {
                opacity: 0.5;
            }
        }

        .chat1-wrapper #chatbox-form {
            display: flex;
            padding: 10px;
            border-top: 1px solid #eee;
            background: #fafafa;
        }

        .chat1-wrapper #chatbox-form input[type="text"] {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        .chat1-wrapper #chatbox-form button {
            margin-left: 8px;
            padding: 8px 16px;
            background: #4a90e2;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
        }

        .chat1-wrapper #chatbox-footer {
            text-align: center;
            padding: 6px;
            font-size: 12px;
            color: #aaa;
        }
        .chat1-wrapper .pre-question-btn {
            margin: 4px 6px;
            padding: 7px 16px;
            background: #e1f5fe;
            border: 1px solid #4a90e2;
            border-radius: 8px;
            color: #333;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .chat1-wrapper .pre-question-btn:hover {
            background: #b3e5fc;
        }
    </style>

    <div id="chat-bubble" onclick="showChatBox()" title="Open chat">
        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="white" viewBox="0 0 24 24">
            <path d="M20 2H4C2.897 2 2 2.897 2 4v16l4-4h14c1.103 0 2-.897 2-2V4C22 2.897 21.103 2 20 2z"/>
        </svg>
    </div>

    <div id="chatbox">
        <div id="chatbox-header">
            Chatbot Interface 1
            <button id="chatbox-close" onclick="hideChatBox()" title="Close chat">&times;</button>
        </div>
        <div id="chatbox-messages">
            <% if (chatHistory.isEmpty()) { %>
            <div id="pre-questions" style="padding:12px;text-align:center;">
                <div style="margin-bottom:8px;font-weight:bold;">Bạn có thể thử hỏi:</div>
                <button class="pre-question-btn" onclick="sendPreQuestion('Gợi ý lộ trình học để trở thành Backend Developer?')">Lộ trình Backend Developer?</button>
                <button class="pre-question-btn" onclick="sendPreQuestion('Tôi cần học gì để xin việc ngành IT?')">Học gì để xin việc IT?</button>
                <button class="pre-question-btn" onclick="sendPreQuestion('Giải thích REST API là gì?')">REST API là gì?</button>
                <button class="pre-question-btn" onclick="sendPreQuestion('Viết một đoạn SQL truy vấn dữ liệu từ bảng Users.')">Ví dụ truy vấn SQL?</button>
            </div>
            <% } %>
            <ul id="chatbox-list">
                <% for (Message msg : chatHistory) {
                        if ("user".equals(msg.getRole()) && msg.getBase64Image() != null) { %>
                <li style="text-align:right;color:#444;font-style:italic;margin-bottom:-4px;border:1px dashed #4a90e2;padding:4px 10px;border-radius:10px;background:#f0f8ff;display:inline-block;align-self:flex-end;max-width:75%;animation:chat-fade-in 0.35s ease;">* image</li>
                    <% }%>
                <li class="<%= msg.getRole()%>"><b><%= msg.getRole()%>:</b> <span class="markdown-body"><%= msg.getText()%></span></li>
                    <% }%>
            </ul>
        </div>
        <form id="chatbox-form">
            <input type="text" name="message" placeholder="Type your message..." />
            <input type="hidden" name="fromPage" value="chat1.jsp" />
            <button type="submit">Send</button>
        </form>
        <div id="chat1-nav" style="text-align:center;margin:18px 0 0 0;">
            <a href="chat2.jsp" style="color:#4a90e2;text-decoration:none;font-size:15px;">Go to Chat 2</a>
        </div>
        <div id="chatbox-footer">&copy; Cursor Chat</div>
    </div>

    <script>
        function showChatBox() {
            const chatbox = document.getElementById('chatbox');
            chatbox.classList.remove('closing');
            chatbox.style.display = 'flex';
            // Force reflow to enable transition
            void chatbox.offsetWidth;
            chatbox.classList.add('open');
            document.getElementById('chat-bubble').style.display = 'none';
        }

        function hideChatBox() {
            const chatbox = document.getElementById('chatbox');
            chatbox.classList.remove('open');
            chatbox.classList.add('closing');
            setTimeout(() => {
                chatbox.style.display = 'none';
                chatbox.classList.remove('closing');
            }, 250); // match transition duration
            document.getElementById('chat-bubble').style.display = 'flex';
        }

        function scrollToBottom() {
            const container = document.getElementById('chatbox-messages');
            container.scrollTop = container.scrollHeight;
        }

        function setLoading(loading) {
            let loader = document.getElementById('chatbox-loading');
            if (!loader) {
                loader = document.createElement('div');
                loader.id = 'chatbox-loading';
                loader.innerText = 'Thinking...';
                document.getElementById('chatbox-messages').appendChild(loader);
            }
            loader.style.display = loading ? 'block' : 'none';
        }

        function renderMessages(messages) {
            const ul = document.getElementById('chatbox-list');
            ul.innerHTML = '';
            messages.forEach(msg => {
                if (msg.role === 'user' && msg.base64Image) {
                    const line = document.createElement('li');
                    line.innerText = '* image';
                    line.style = 'text-align:right;color:#444;font-style:italic;margin-bottom:-4px;border:1px dashed #4a90e2;padding:4px 10px;border-radius:10px;background:#f0f8ff;display:inline-block;align-self:flex-end;max-width:75%;animation:chat-fade-in 0.35s ease;';
                    ul.appendChild(line);
                }
                const li = document.createElement('li');
                li.className = msg.role;
                li.innerHTML = '<b>' + msg.role + ':</b> <span class="markdown-body">' + (msg.text ? marked.parse(msg.text) : '') + '</span>';
                ul.appendChild(li);
            });
            scrollToBottom();
        }

        function sendMessageAjax(e) {
            e.preventDefault();
            const input = document.querySelector('#chatbox-form input[name="message"]');
            const message = input.value.trim();
            if (!message)
                return;

            const ul = document.getElementById('chatbox-list');
            const li = document.createElement('li');
            li.className = 'user';
            li.innerHTML = '<b>user:</b> ' + message;
            ul.appendChild(li);
            scrollToBottom();

            const formData = new FormData();
            formData.append("message", message);
            formData.append("fromPage", "chat1.jsp");
            formData.append("ajax", "1");

            input.value = '';
            input.focus();

            setLoading(true);

            fetch('ChatbotServlet', {
                method: 'POST',
                body: formData
            })
                    .then(res => res.json())
                    .then(data => {
                        setLoading(false);
                        if (data && data.chatHistory) {
                            renderMessages(data.chatHistory);
                        }
                    })
                    .catch(() => {
                        setLoading(false);
                        alert("Error sending message.");
                    });
        }

        function sendPreQuestion(text) {
            const input = document.querySelector('#chatbox-form input[name="message"]');
            input.value = text;
            document.getElementById('chatbox-form').dispatchEvent(new Event('submit', {cancelable: true, bubbles: true}));
        }

        document.getElementById('chatbox-form').addEventListener('submit', sendMessageAjax);

        // Parse markdown for chat history on page load
        window.addEventListener("DOMContentLoaded", () => {
            document.querySelectorAll('.markdown-body').forEach(el => {
                const raw = el.textContent;
                el.innerHTML = marked.parse(raw);
            });
        });
    </script>
</div>
